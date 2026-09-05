#!/bin/bash
# ABINSTEIN OS Complete Build System
# Builds Linux kernel, rootfs, and bootable images for QEMU and Samsung Galaxy A20e
# ARM64 cross-compilation with no Android dependencies

set -e

# ============================================================================
# CONFIGURATION & SETUP
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
OUT_DIR="${BUILD_DIR}/output"
SOURCES_DIR="${BUILD_DIR}/sources"
TOOLS_DIR="${BUILD_DIR}/tools"
CACHE_DIR="${BUILD_DIR}/cache"
LOG_DIR="${BUILD_DIR}/logs"

# Cross-compiler configuration
CROSS_COMPILE="aarch64-linux-gnu-"
CROSS_CC="${CROSS_COMPILE}gcc"
CROSS_OBJCOPY="${CROSS_COMPILE}objcopy"

# Kernel and rootfs versions
KERNEL_VERSION="6.1.92"
BUSYBOX_VERSION="1.36.1"
BUSYBOX_URL="https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2"
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz"

# QEMU configuration
QEMU_CPU="cortex-a53"
QEMU_MEMORY="1024"
QEMU_CORES="2"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo_status() {
    echo -e "${GREEN}[ABINSTEIN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# ============================================================================
# PREREQUISITES CHECK
# ============================================================================

check_requirements() {
    echo_status "Checking build requirements..."
    
    local missing_tools=()
    
    # Check cross-compiler
    if ! command -v ${CROSS_CC} &> /dev/null; then
        missing_tools+=("aarch64-linux-gnu-gcc (install: sudo apt-get install gcc-aarch64-linux-gnu)")
    fi
    
    # Check build tools
    local tools=("make" "cmake" "git" "curl" "wget" "tar" "gzip" "bzip2" "xz-utils" "bc")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    # Check QEMU
    if ! command -v qemu-system-aarch64 &> /dev/null; then
        missing_tools+=("qemu-system-aarch64 (install: sudo apt-get install qemu-system-arm)")
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo_error "Missing required tools:
$(printf '  - %s\n' "${missing_tools[@]}")

On Ubuntu/Debian, install with:
  sudo apt-get update
  sudo apt-get install -y \\
    gcc-aarch64-linux-gnu \\
    binutils-aarch64-linux-gnu \\
    make cmake git curl wget \\
    tar gzip bzip2 xz-utils bc \\
    qemu-system-arm"
    fi
    
    echo_status "All requirements satisfied"
}

# ============================================================================
# DIRECTORY SETUP
# ============================================================================

setup_directories() {
    echo_status "Setting up build directories..."
    mkdir -p "${BUILD_DIR}" "${OUT_DIR}" "${SOURCES_DIR}" "${TOOLS_DIR}" "${CACHE_DIR}" "${LOG_DIR}"
    echo_status "Directories ready at ${BUILD_DIR}"
}

# ============================================================================
# KERNEL BUILD
# ============================================================================

build_kernel() {
    echo_status "Building Linux kernel ${KERNEL_VERSION} (ARM64)..."
    
    local kernel_dir="${SOURCES_DIR}/linux-${KERNEL_VERSION}"
    local kernel_archive="${CACHE_DIR}/linux-${KERNEL_VERSION}.tar.xz"
    
    # Download kernel if not cached
    if [ ! -f "${kernel_archive}" ]; then
        echo_status "Downloading Linux kernel from kernel.org..."
        mkdir -p "${CACHE_DIR}"
        curl -L "${KERNEL_URL}" -o "${kernel_archive}" || echo_error "Failed to download kernel"
    fi
    
    # Extract kernel
    if [ ! -d "${kernel_dir}" ]; then
        echo_status "Extracting kernel source..."
        tar -xf "${kernel_archive}" -C "${SOURCES_DIR}" || echo_error "Failed to extract kernel"
    fi
    
    cd "${kernel_dir}"
    
    # Configure kernel for QEMU ARM64
    echo_status "Configuring kernel for QEMU ARM64 (virt platform)..."
    if [ -f ".config" ]; then
        make ARCH=arm64 CROSS_COMPILE="${CROSS_COMPILE}" clean > /dev/null 2>&1
    fi
    
    # Use generic ARM64 defconfig as base
    make ARCH=arm64 CROSS_COMPILE="${CROSS_COMPILE}" defconfig > /dev/null 2>&1
    
    # Customize kernel config for QEMU
    cat >> .config << 'EOF'
# ABINSTEIN customizations
CONFIG_SERIAL_AMBA_PL011=y
CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_HID=y
CONFIG_HID_GENERIC=y
CONFIG_USB=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_STORAGE=y
CONFIG_EXT4_FS=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_TMPFS=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_NET=y
CONFIG_VIRTIO_BLK=y
CONFIG_VIRTIO_MMIO=y
CONFIG_DRM=y
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
EOF
    
    # Build kernel
    echo_status "Compiling kernel (this may take several minutes)..."
    make -j$(nproc) ARCH=arm64 CROSS_COMPILE="${CROSS_COMPILE}" Image > "${LOG_DIR}/kernel-build.log" 2>&1 || echo_error "Kernel build failed. Check ${LOG_DIR}/kernel-build.log"
    
    # Copy kernel image
    cp arch/arm64/boot/Image "${OUT_DIR}/Image" || echo_error "Failed to copy kernel image"
    echo_status "Kernel built successfully: ${OUT_DIR}/Image"
    
    cd "${SCRIPT_DIR}"
}

# ============================================================================
# BUSYBOX BUILD (for rootfs utilities)
# ============================================================================

build_busybox() {
    echo_status "Building BusyBox ${BUSYBOX_VERSION}..."
    
    local busybox_dir="${SOURCES_DIR}/busybox-${BUSYBOX_VERSION}"
    local busybox_archive="${CACHE_DIR}/busybox-${BUSYBOX_VERSION}.tar.bz2"
    
    # Download BusyBox
    if [ ! -f "${busybox_archive}" ]; then
        echo_status "Downloading BusyBox from busybox.net..."
        curl -L "${BUSYBOX_URL}" -o "${busybox_archive}" || echo_error "Failed to download BusyBox"
    fi
    
    # Extract BusyBox
    if [ ! -d "${busybox_dir}" ]; then
        echo_status "Extracting BusyBox source..."
        tar -xf "${busybox_archive}" -C "${SOURCES_DIR}" || echo_error "Failed to extract BusyBox"
    fi
    
    cd "${busybox_dir}"
    
    # Configure BusyBox
    echo_status "Configuring BusyBox for ARM64..."
    make CROSS_COMPILE="${CROSS_COMPILE}" ARCH=arm64 defconfig > /dev/null 2>&1
    
    # Enable static linking
    sed -i 's/^# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
    sed -i 's/^# CONFIG_STATIC_LIBGCC is not set/CONFIG_STATIC_LIBGCC=y/' .config
    
    # Build BusyBox
    echo_status "Compiling BusyBox..."
    make -j$(nproc) CROSS_COMPILE="${CROSS_COMPILE}" ARCH=arm64 > "${LOG_DIR}/busybox-build.log" 2>&1 || echo_error "BusyBox build failed"
    
    # Install BusyBox
    echo_status "Installing BusyBox utilities..."
    make CROSS_COMPILE="${CROSS_COMPILE}" ARCH=arm64 CONFIG_PREFIX="${OUT_DIR}/rootfs" install > /dev/null 2>&1
    
    echo_status "BusyBox built and installed"
    cd "${SCRIPT_DIR}"
}

# ============================================================================
# ROOTFS BUILD
# ============================================================================

build_rootfs() {
    echo_status "Building root filesystem..."
    
    local rootfs="${OUT_DIR}/rootfs"
    
    # Create rootfs directory structure
    echo_status "Creating Linux directory structure..."
    mkdir -p "${rootfs}"/{bin,sbin,etc,lib,usr/{bin,sbin,lib},proc,sys,dev,tmp,root,var/{log,run,cache},home}
    
    # Copy BusyBox binaries
    if [ ! -d "${rootfs}/bin" ] || [ -z "$(ls -A ${rootfs}/bin 2>/dev/null)" ]; then
        echo_warn "BusyBox not yet installed, building now..."
        build_busybox
    fi
    
    # Create essential device nodes
    echo_status "Creating device nodes..."
    sudo mknod -m 622 "${rootfs}/dev/console" c 5 1 2>/dev/null || true
    sudo mknod -m 666 "${rootfs}/dev/null" c 1 3 2>/dev/null || true
    sudo mknod -m 666 "${rootfs}/dev/zero" c 1 5 2>/dev/null || true
    sudo mknod -m 666 "${rootfs}/dev/full" c 1 7 2>/dev/null || true
    sudo mknod -m 644 "${rootfs}/dev/random" c 1 8 2>/dev/null || true
    sudo mknod -m 644 "${rootfs}/dev/urandom" c 1 9 2>/dev/null || true
    sudo mknod -m 666 "${rootfs}/dev/tty" c 5 0 2>/dev/null || true
    sudo mknod -m 666 "${rootfs}/dev/tty0" c 4 0 2>/dev/null || true
    
    # Create /etc/fstab
    echo_status "Creating filesystem table..."
    cat > "${rootfs}/etc/fstab" << 'EOF'
proc    /proc   proc    defaults  0  0
sysfs   /sys    sysfs   defaults  0  0
devtmpfs /dev   devtmpfs defaults  0  0
EOF
    
    # Create /etc/hostname
    echo "abinstein-qemu" > "${rootfs}/etc/hostname"
    
    # Create /etc/hosts
    cat > "${rootfs}/etc/hosts" << 'EOF'
127.0.0.1    localhost
127.0.0.1    abinstein-qemu
::1          localhost
EOF
    
    # Create /etc/inittab (minimal init configuration)
    cat > "${rootfs}/etc/inittab" << 'EOF'
# /etc/inittab: BusyBox init configuration
::sysinit:/etc/init.d/rcS
::respawn:/bin/sh
::ctrlaltdel:/sbin/reboot
::shutdown:/sbin/swapoff -a
::shutdown:/bin/umount -a -r
EOF
    
    # Create init scripts directory
    mkdir -p "${rootfs}/etc/init.d"
    
    # Create /etc/init.d/rcS (startup script)
    cat > "${rootfs}/etc/init.d/rcS" << 'EOF'
#!/bin/sh
# ABINSTEIN OS Startup Script

echo "=== ABINSTEIN OS BOOT ==="
echo "Mounting filesystems..."
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev
mkdir -p /dev/pts
mount -t devpts none /dev/pts
mount -t tmpfs tmpfs /run

echo "Setting up environment..."
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export HOME=/root

echo ""
echo "===================================="
echo "  ABINSTEIN OS - QEMU ARM64 BUILD  "
echo "===================================="
echo ""
echo "System ready. Launching shell..."
echo ""
EOF
    chmod +x "${rootfs}/etc/init.d/rcS"
    
    # Create /sbin/init symlink if needed
    if [ ! -e "${rootfs}/sbin/init" ]; then
        ln -sf ../bin/busybox "${rootfs}/sbin/init" 2>/dev/null || true
    fi
    
    echo_status "Rootfs created at ${rootfs}"
}

# ============================================================================
# INITRAMFS BUILD
# ============================================================================

build_initramfs() {
    echo_status "Building initramfs (initial RAM filesystem)..."
    
    local rootfs="${OUT_DIR}/rootfs"
    local initramfs_dir="${OUT_DIR}/initramfs"
    local initramfs_cpio="${OUT_DIR}/initramfs.cpio.gz"
    
    # Use rootfs as initramfs base
    if [ -d "${initramfs_dir}" ]; then
        rm -rf "${initramfs_dir}"
    fi
    cp -r "${rootfs}" "${initramfs_dir}"
    
    # Copy init script from initramfs directory if it exists
    if [ -f "${SCRIPT_DIR}/initramfs/init" ]; then
        echo_status "Using custom init from initramfs/init"
        cp "${SCRIPT_DIR}/initramfs/init" "${initramfs_dir}/init"
        chmod +x "${initramfs_dir}/init"
    else
        echo_warn "Custom init not found, using BusyBox default"
    fi
    
    # Create CPIO archive
    echo_status "Creating CPIO archive..."
    cd "${initramfs_dir}"
    find . -print0 | cpio -0 -H newc -o | gzip -9 > "${initramfs_cpio}" || echo_error "Failed to create initramfs"
    cd "${SCRIPT_DIR}"
    
    echo_status "Initramfs created: ${initramfs_cpio}"
}

# ============================================================================
# QEMU BOOT
# ============================================================================

boot_qemu() {
    echo_status "Preparing to boot QEMU..."
    
    local kernel="${OUT_DIR}/Image"
    local initramfs="${OUT_DIR}/initramfs.cpio.gz"
    
    if [ ! -f "${kernel}" ]; then
        echo_error "Kernel image not found at ${kernel}"
    fi
    
    if [ ! -f "${initramfs}" ]; then
        echo_error "Initramfs not found at ${initramfs}"
    fi
    
    echo_info "Kernel: ${kernel}"
    echo_info "Initramfs: ${initramfs}"
    echo_info "QEMU will boot with:"
    echo_info "  - ${QEMU_CORES} CPU cores"
    echo_info "  - ${QEMU_MEMORY} MB RAM"
    echo_info "  - ARM64 CPU (Cortex-A53)"
    echo ""
    echo_status "Launching QEMU..."
    echo_status "(Press Ctrl+A then X to exit QEMU)"
    echo ""
    
    qemu-system-aarch64 \
        -machine virt \
        -cpu cortex-a53 \
        -smp ${QEMU_CORES} \
        -m ${QEMU_MEMORY} \
        -kernel "${kernel}" \
        -initrd "${initramfs}" \
        -append "root=/dev/ram rw console=ttyAMA0 console=tty0" \
        -serial stdio \
        -display none \
        -no-reboot
}

# ============================================================================
# CLEAN BUILD
# ============================================================================

clean_build() {
    echo_status "Cleaning build artifacts..."
    rm -rf "${BUILD_DIR}"
    echo_status "Clean complete"
}

# ============================================================================
# HELP AND USAGE
# ============================================================================

show_usage() {
    cat << 'EOF'
ABINSTEIN OS Build System

Usage: ./build_os.sh <target> [options]

Targets:
  qemu              Build kernel, rootfs, and boot in QEMU (full pipeline)
  kernel            Build Linux kernel for ARM64
  rootfs            Build root filesystem with BusyBox
  initramfs         Build initial RAM filesystem
  boot              Boot already-built kernel and initramfs in QEMU
  clean             Remove all build artifacts
  a20e              Build for Samsung Galaxy A20e (experimental - not yet implemented)

Options:
  --verbose         Enable verbose output
  --debug           Build with debug symbols
  --check           Check requirements only
  --help            Show this help message

Examples:
  ./build_os.sh qemu              # Full build and boot
  ./build_os.sh kernel            # Build kernel only
  ./build_os.sh rootfs            # Build rootfs only
  ./build_os.sh boot              # Boot existing build
  ./build_os.sh clean             # Clean all artifacts
  ./build_os.sh qemu --verbose    # Full build with verbose output

Required packages:
  gcc-aarch64-linux-gnu
  binutils-aarch64-linux-gnu
  make cmake git curl wget
  tar gzip bzip2 xz-utils bc
  qemu-system-arm

Install on Ubuntu/Debian:
  sudo apt-get install -y gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu \\
    make cmake git curl wget tar gzip bzip2 xz-utils bc qemu-system-arm

For more information, see docs/BUILD.md
EOF
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

TARGET="$1"
shift || true

# Parse options
VERBOSE=0
DEBUG=0
while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose)
            VERBOSE=1
            shift
            ;;
        --debug)
            DEBUG=1
            shift
            ;;
        --check)
            check_requirements
            exit 0
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo_error "Unknown option: $1"
            ;;
    esac
done

case "${TARGET}" in
    qemu)
        echo_status "=== ABINSTEIN OS QEMU Full Build Pipeline ==="
        setup_directories
        check_requirements
        build_kernel
        build_busybox
        build_rootfs
        build_initramfs
        boot_qemu
        ;;
    kernel)
        setup_directories
        check_requirements
        build_kernel
        ;;
    rootfs)
        setup_directories
        check_requirements
        build_busybox
        build_rootfs
        ;;
    initramfs)
        setup_directories
        check_requirements
        if [ ! -d "${OUT_DIR}/rootfs" ]; then
            build_busybox
            build_rootfs
        fi
        build_initramfs
        ;;
    boot)
        echo_status "Booting existing QEMU image..."
        boot_qemu
        ;;
    clean)
        clean_build
        ;;
    a20e)
        echo_status "Building ABINSTEIN OS for Samsung Galaxy A20e"
        echo_warn "A20e target not yet implemented"
        echo_warn "This requires hardware-specific kernel config, device tree, and boot chain"
        echo_info "See docs/A20E.md for hardware specifications"
        ;;
    *)
        echo_error "Unknown target: ${TARGET}"
        show_usage
        ;;
esac

echo_status "Done"
