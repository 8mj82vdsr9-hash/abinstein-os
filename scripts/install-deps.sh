#!/bin/bash
# Installation script for ABINSTEIN OS build dependencies
# Supports Ubuntu/Debian systems

set -e

echo "ABINSTEIN OS - Build Dependencies Installer"
echo "============================================"
echo ""

# Check if running on Ubuntu/Debian
if [ ! -f /etc/os-release ]; then
    echo "Error: Could not detect Linux distribution"
    exit 1
fi

source /etc/os-release

if [[ ! "$ID" =~ ^(ubuntu|debian)$ ]]; then
    echo "Warning: This script is optimized for Ubuntu/Debian"
    echo "Your system: $PRETTY_NAME"
    echo "You may need to adapt package names for your distribution"
    echo ""
fi

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo"
    exit 1
fi

echo "Installing ABINSTEIN OS build dependencies..."
echo ""

# Update package lists
echo "[1/3] Updating package lists..."
apt-get update

# Install cross-compilation toolchain
echo "[2/3] Installing ARM64 cross-compilation toolchain..."
apt-get install -y \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    make \
    cmake \
    git \
    curl \
    wget \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    bc \
    pkg-config

# Install QEMU for ARM64 emulation
echo "[3/3] Installing QEMU for ARM64 emulation..."
apt-get install -y qemu-system-arm

echo ""
echo "Installation complete!"
echo ""
echo "Verification:"
aarch64-linux-gnu-gcc --version | head -n1
qemu-system-aarch64 --version | head -n1

echo ""
echo "You can now build ABINSTEIN OS with:"
echo "  ./build_os.sh qemu"
