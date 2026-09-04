# ABINSTEIN OS Build System

## Overview

ABINSTEIN OS uses CMake for its build system, with shell scripts for orchestration.

## Prerequisites

### Host Requirements
- Linux system (Ubuntu 20.04+ recommended)
- CMake 3.20+
- Make or Ninja
- git
- curl/wget

### ARM64 Cross-Compilation
- gcc-aarch64-linux-gnu
- g++-aarch64-linux-gnu
- binutils-aarch64-linux-gnu
- linux-headers-arm64

### Installation (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install -y \
    cmake \
    make \
    git \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    linux-headers-arm64 \
    qemu-system-arm64
```

## Build Directory Structure

```
abinstein-os/
├── build/               # Build output (generated)
│   ├── CMakeCache.txt
│   ├── CMakeFiles/
│   ├── kernel/
│   ├── rootfs/
│   ├── images/
│   └── bin/             # Built executables
├── sysroot/            # ARM64 sysroot (generated)
└── ...
```

## Build Targets

### 1. QEMU ARM64 Complete Build

```bash
./build_os.sh qemu
```

This target:
1. Builds ARM64 cross-compilation toolchain
2. Configures and builds Linux kernel
3. Creates initial RAM filesystem
4. Builds root filesystem
5. Generates bootable image
6. Launches QEMU ARM64
7. Boots the OS

### 2. Linux Kernel Only

```bash
./build_os.sh kernel
```

Configuration:
- ARM64 generic configuration for QEMU
- Device tree support
- Minimal required drivers
- Debug symbols in development mode

### 3. Root Filesystem

```bash
./build_os.sh rootfs
```

Includes:
- Base file system hierarchy
- Core utilities
- System libraries
- Configuration files
- Users and groups

### 4. Initial RAM Filesystem

```bash
./build_os.sh initramfs
```

Creates early-boot environment with:
- init program
- Module loading
- Rootfs discovery and mounting
- Error recovery

### 5. Bootable Image

```bash
./build_os.sh image
```

Generates:
- Kernel image
- Device tree binary
- Initramfs
- Boot configuration
- Complete bootable image

### 6. Samsung Galaxy A20e Target

```bash
./build_os.sh a20e
```

**WARNING**: This target is experimental and requires:
- Device tree for A20e
- MediaTek-specific drivers
- Real hardware for testing
- Bootloader knowledge

### 7. Test Suite

```bash
./build_os.sh test
```

Runs:
- Unit tests
- Integration tests
- Boot tests (if applicable)

### 8. Clean Build

```bash
./build_os.sh clean
```

Removes all generated artifacts.

## Advanced Options

### Verbose Output

```bash
./build_os.sh qemu --verbose
```

Enable detailed build output.

### Debug Build

```bash
./build_os.sh kernel --debug
```

Include debug symbols and disable optimizations.

## Manual Build Steps

For development, you can run individual build phases:

### 1. Configure CMake

```bash
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DABINSTEIN_PLATFORM=qemu \
      ..
```

### 2. Build Components

```bash
make                    # Build all
make abinstein-core     # Build core library
make abinstein-hal      # Build HAL
make abinstein-services # Build services
```

### 3. Check Build Status

```bash
ctest --output-on-failure  # Run tests
```

## Cross-Compilation Details

### Toolchain File

Location: `toolchain/abinstein-aarch64.cmake`

Defines:
- ARM64 compilers (gcc, g++)
- Compiler flags
- Sysroot path
- Search paths for libraries

### Compiler Flags

```cmake
-mcpu=generic          # Generic ARM64 CPU
-mtune=generic+crc     # Tuning for ARM64+CRC
-O2                    # Release optimization
-g                     # Debug symbols (debug build)
```

## Sysroot Management

The sysroot contains ARM64 libraries and headers:

```bash
# Setup sysroot (if needed manually)
mkdir -p sysroot
aarch64-linux-gnu-sysroot-setup.sh  # Script to populate sysroot
```

## Environment Variables

```bash
# Override cross compiler
export CC=aarch64-linux-gnu-gcc
export CXX=aarch64-linux-gnu-g++

# Set sysroot
export SYSROOT=/path/to/sysroot

# Build type
export CMAKE_BUILD_TYPE=Release
```

## Troubleshooting

### "Compiler not found"

```bash
sudo apt install gcc-aarch64-linux-gnu
```

### "CMake toolchain file not found"

Ensure you're in the project root directory when running build scripts.

### "sysroot: No such file"

The sysroot is created automatically. If missing, run:

```bash
./build_os.sh toolchain
```

### "QEMU not found"

```bash
sudo apt install qemu-system-arm64
```

## Build Performance

### Parallel Compilation

```bash
make -j$(nproc)  # Use all CPU cores
```

### Ccache (Optional)

Speed up recompilation:

```bash
sudo apt install ccache
export CC=ccache gcc
export CXX=ccache g++
```

## Continuous Integration

The build system is designed for CI/CD:

```bash
# CI-friendly build
./build_os.sh qemu --verbose 2>&1 | tee build.log
echo $? # Exit code
```

Expected exit code: 0 for success, non-zero for failure.
