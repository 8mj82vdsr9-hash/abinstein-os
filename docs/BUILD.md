# ABINSTEIN OS BUILD GUIDE

## Quick Start (5 minutes)

### 1. Install Dependencies

```bash
cd abinstein-os
sudo bash scripts/install-deps.sh
```

This installs:
- `gcc-aarch64-linux-gnu` - ARM64 cross-compiler
- `qemu-system-arm` - ARM64 emulator
- All build tools (make, cmake, git, curl, wget, tar, etc.)

### 2. Build and Boot in QEMU

```bash
./build_os.sh qemu
```

This will:
1. Download Linux kernel 6.1.92
2. Configure it for ARM64 QEMU
3. Compile kernel
4. Download and compile BusyBox
5. Create rootfs with essential utilities
6. Build initramfs
7. **Launch QEMU and boot the system**

You should see:
```
🌟 ABINSTEIN OS - QUANTUM MOBILE OS 🌟

====================================
Welcome to ABINSTEIN OS (QEMU ARM64)
====================================

[INFO] Available commands: ls, cat, echo, mount, ps, top, uname, etc.
[INFO] Type 'exit' to shutdown system

sh-5.2# _
```

### 3. Test the System

Try these commands in the shell:

```bash
# Check system info
uname -a
cat /proc/cpuinfo
cat /proc/meminfo
ls -la /

# List mounted filesystems
mount | grep -E 'proc|sys|dev'

# Test BusyBox utilities
echo "Hello ABINSTEIN OS"
date
uptime

# Exit to shutdown
exit
```

## Build Targets

### Full Build & Boot (Recommended)
```bash
./build_os.sh qemu
```
- Compiles everything from scratch
- Boots in QEMU
- Takes ~5-10 minutes first time (downloads ~200MB kernel source)

### Build Kernel Only
```bash
./build_os.sh kernel
```
- Downloads and compiles Linux kernel
- Output: `build/output/Image`
- Takes ~3-5 minutes

### Build Rootfs Only
```bash
./build_os.sh rootfs
```
- Creates root filesystem with BusyBox
- Output: `build/output/rootfs/`
- Takes ~1-2 minutes

### Build Initramfs Only
```bash
./build_os.sh initramfs
```
- Creates compressed initial RAM filesystem
- Output: `build/output/initramfs.cpio.gz`
- Takes ~1 minute

### Boot Existing Build
```bash
./build_os.sh boot
```
- Skip compilation, just boot existing kernel and initramfs
- Takes ~5 seconds

### Clean All Build Artifacts
```bash
./build_os.sh clean
```
- Removes entire `build/` directory
- Frees ~2GB disk space

## Options

### Verbose Output
```bash
./build_os.sh qemu --verbose
```

### Debug Build (with symbols)
```bash
./build_os.sh kernel --debug
```

### Check Requirements Only
```bash
./build_os.sh --check
```

## System Architecture

### Build Process Flow

```
┌─────────────────────────────────────┐
│   1. Download Linux Kernel 6.1.92   │ (kernel.org CDN)
├─────────────────────────────────────┤
│   2. Configure for ARM64 QEMU       │ (virt platform)
├─────────────────────────────────────┤
│   3. Cross-compile with aarch64-gcc │ (parallel jobs)
├─────────────────────────────────────┤
│   4. Download BusyBox 1.36.1        │ (busybox.net)
├─────────────────────────────────────┤
│   5. Static compile BusyBox         │ (for rootfs)
├─────────────────────────────────────┤
│   6. Create Linux directory tree    │ (/bin, /etc, /dev, etc)
├─────────────────────────────────────┤
│   7. Create device nodes            │ (/dev/console, /dev/null, etc)
├─────────────────────────────────────┤
│   8. Install init script            │ (initramfs/init)
├─────────────────────────────────────┤
│   9. Create CPIO archive            │ (compressed initramfs)
├─────────────────────────────────────┤
│  10. Boot in QEMU ARM64             │ (kernel + initramfs)
└─────────────────────────────────────┘
```

### Output Structure

```
build/
├── output/
│   ├── Image              # Compiled Linux kernel
│   ├── rootfs/            # Root filesystem directory
│   └── initramfs.cpio.gz  # Compressed initial RAM filesystem
├── sources/
│   ├── linux-6.1.92/      # Linux kernel source
│   └── busybox-1.36.1/    # BusyBox source
├── cache/
│   ├── linux-6.1.92.tar.xz       # Downloaded kernel
│   └── busybox-1.36.1.tar.bz2    # Downloaded BusyBox
├── tools/                 # Cross-compilation tools
├── logs/
│   ├── kernel-build.log   # Kernel compilation log
│   └── busybox-build.log  # BusyBox compilation log
└── build.log              # Main build log
```

## QEMU Emulation Details

### Launch Command

```bash
qemu-system-aarch64 \
  -machine virt \
  -cpu cortex-a53 \
  -smp 2 \
  -m 1024 \
  -kernel build/output/Image \
  -initrd build/output/initramfs.cpio.gz \
  -append "root=/dev/ram rw console=ttyAMA0 console=tty0" \
  -serial stdio \
  -display none \
  -no-reboot
```

### What Each Option Does

- `-machine virt` - QEMU ARM64 virtual machine platform
- `-cpu cortex-a53` - Emulate ARM Cortex-A53 processor (used in Galaxy A20e)
- `-smp 2` - 2 CPU cores
- `-m 1024` - 1024 MB RAM
- `-kernel` - Path to compiled Linux kernel
- `-initrd` - Path to initial RAM filesystem
- `-append` - Kernel boot parameters
- `-serial stdio` - Serial console output to terminal
- `-display none` - No GUI window (headless mode)
- `-no-reboot` - Don't auto-reboot on kernel panic

### Exit QEMU

Press `Ctrl+A` then `X` to exit.

## Troubleshooting

### Issue: "aarch64-linux-gnu-gcc: command not found"

**Solution**: Install ARM64 toolchain
```bash
sudo apt-get install gcc-aarch64-linux-gnu
```

### Issue: "qemu-system-aarch64: command not found"

**Solution**: Install QEMU
```bash
sudo apt-get install qemu-system-arm
```

### Issue: Kernel build fails with "CONFIG_STATIC_LIBGCC not found"

**Solution**: Your kernel version is too old. The script uses kernel 6.1.92 LTS which supports this. Try cleaning:
```bash
./build_os.sh clean
./build_os.sh qemu
```

### Issue: Build is very slow

**Reason**: First build downloads and compiles ~200MB source
- Subsequent boots will use cached sources
- Compilation uses all CPU cores automatically
- Check your internet speed if download is slow

### Issue: "Out of disk space" error

**Solution**: Clean previous builds
```bash
./build_os.sh clean
```
This frees ~2GB. You need at least 3GB free disk space for full build.

### Issue: Boot hangs or kernel panic

**Check the logs**:
```bash
cat build/logs/kernel-build.log
cat build/logs/busybox-build.log
```

**Try rebuilding**:
```bash
./build_os.sh clean
./build_os.sh qemu --verbose
```

## Performance Tips

### Speed Up Kernel Compilation

Edit `build_os.sh` and increase parallel jobs:
```bash
make -j$(nproc) ...  # Default: uses all cores
```

For manual control:
```bash
make -j8 ...  # Use 8 parallel jobs
```

### Enable Caching

The script automatically caches:
- Downloaded kernel source
- Downloaded BusyBox source
- Downloaded cross-compiler packages

Subsequent builds will skip downloads.

### Reduce QEMU Memory Usage

Edit `build_os.sh`:
```bash
QEMU_MEMORY="512"  # Reduce from 1024 to 512 MB
```

## System Specifications

### Linux Kernel
- Version: 6.1.92 LTS (Long Term Support)
- Architecture: ARM64 (aarch64)
- Target: QEMU virt platform (generic)
- Kernel size: ~15-20 MB uncompressed

### BusyBox
- Version: 1.36.1
- Built as: Static binary (no dependencies)
- Provides: Essential Linux utilities (sh, ls, cat, mount, etc.)
- Size: ~1-2 MB

### QEMU Emulation
- CPU: ARM Cortex-A53 (same as Galaxy A20e)
- Cores: 2
- RAM: 1024 MB
- No persistent storage (RAM-only boot)

## Next Steps

### After First Boot

1. **Explore the system**
   ```bash
   ls /
   cat /proc/cpuinfo
   mount
   ```

2. **Test utilities**
   ```bash
   echo "ABINSTEIN works!"
   date
   ps aux
   ```

3. **Check documentation**
   - Read `docs/ARCHITECTURE.md` for system design
   - Read `docs/NETWORK.md` for networking (next phase)
   - Read `docs/A20E.md` for hardware target

### Development

1. **Add custom applications**
   - Place source in `apps/`
   - Add to `CMakeLists.txt`
   - Rebuild with `./build_os.sh qemu`

2. **Modify kernel**
   - Edit `build/sources/linux-6.1.92/.config`
   - Recompile with `./build_os.sh kernel`

3. **Add system services**
   - Create in `services/src/`
   - Use D-Bus for IPC
   - Configure in rootfs `/etc/`

## Build System Features

✓ **Automated Downloads** - Fetches from official sources (kernel.org, busybox.net)
✓ **Caching** - Reuses downloaded sources
✓ **Cross-Compilation** - Full ARM64 toolchain support
✓ **Colored Output** - Easy status tracking
✓ **Logging** - Complete build logs for debugging
✓ **Requirement Checking** - Verifies dependencies before build
✓ **Error Handling** - Stops on any compilation error
✓ **Parallel Compilation** - Uses all available CPU cores
✓ **QEMU Integration** - One-command boot
✓ **No Android Dependencies** - Pure Linux stack

## Disk Space Requirements

- Downloaded sources cache: ~300 MB
- Extracted sources: ~800 MB
- Build artifacts: ~500 MB
- **Total**: ~1.6 GB minimum
- **Recommended**: 3+ GB free space

## Network Requirements

- First build downloads ~200 MB:
  - Linux kernel 6.1.92: ~120 MB
  - BusyBox 1.36.1: ~2 MB
  - Build dependencies
- Subsequent builds: None (uses cache)
- Minimum bandwidth: 1 Mbps (reasonable)

## Estimated Build Times

- First build (full): **8-12 minutes**
  - Download: 1-2 min (depends on internet)
  - Kernel compile: 5-8 min
  - Rootfs/initramfs: 30 sec
  - QEMU launch: 10 sec

- Subsequent boots: **10-15 seconds**
  - Skips downloads and compilation
  - Straight to QEMU launch

## See Also

- [ARCHITECTURE.md](./ARCHITECTURE.md) - System design
- [ROADMAP.md](../ROADMAP.md) - Development phases
- [BROWSER.md](./BROWSER.md) - Web browser (WPE WebKit)
- [APPSTORE.md](./APPSTORE.md) - App distribution
- [A20E.md](./A20E.md) - Samsung Galaxy A20e target
