# ABINSTEIN OS

An independent Linux-based mobile operating system for ARM64 architecture.

## Vision

ABINSTEIN OS is a modern, modular mobile OS built from scratch with:

- **Kernel**: Linux ARM64/aarch64
- **Display**: Wayland + Qt 6/QML
- **Hardware Support**: Wi-Fi, Bluetooth, audio, camera, modem, sensors
- **Applications**: Native mobile apps with Qt/QML
- **Connectivity**: Full networking stack with state management
- **Security**: Privilege separation, secure IPC via D-Bus
- **Package Management**: Abinstein package manager with OTA support
- **Innovation**: Quantum/Qubit simulator core

## Target Platforms

1. **QEMU** (ARM64) - Primary development target
2. **Samsung Galaxy A20e** - Future hardware target (requires hardware verification)

## Project Status

- [ ] Kernel compilation (ARM64)
- [ ] Rootfs construction
- [ ] Initramfs creation
- [ ] QEMU boot
- [ ] D-Bus system
- [ ] Wayland compositor
- [ ] Qt 6/QML shell
- [ ] Launcher
- [ ] Settings
- [ ] Networking
- [ ] Wi-Fi connectivity detection
- [ ] Bluetooth integration
- [ ] Package manager
- [ ] OTA updates
- [ ] Recovery system
- [ ] Quantum core
- [ ] Security hardening
- [ ] Full testing suite

## Quick Start

### Build for QEMU

```bash
./build_os.sh qemu
```

### Build Kernel Only

```bash
./build_os.sh kernel
```

### Build Rootfs

```bash
./build_os.sh rootfs
```

### Run Tests

```bash
./build_os.sh test
```

## Architecture

```
Hardware
  ↓
Linux Kernel (ARM64)
  ↓
HAL (Hardware Abstraction Layer)
  ↓
System Services (D-Bus, networking, power, audio)
  ↓
Wayland Compositor
  ↓
Qt 6 / QML Shell & Applications
```

## Directory Structure

```
abinstein-os/
├── boot/           # Boot configuration & u-boot
├── kernel/         # Linux kernel ARM64 config
├── device/         # Device-specific configs
├── toolchain/      # ARM64 cross-compilation toolchain
├── rootfs/         # Root filesystem structure
├── initramfs/      # Initial RAM filesystem
├── core/           # Core system libraries
├── hal/            # Hardware Abstraction Layer
├── services/       # System services
├── network/        # Networking & Wi-Fi
├── bluetooth/      # Bluetooth subsystem
├── audio/          # Audio system (ALSA/PipeWire)
├── camera/         # Camera framework
├── modem/          # Modem interface
├── display/        # Display management
├── input/          # Input handling
├── compositor/     # Wayland compositor
├── shell/          # Mobile UI shell
├── launcher/       # App launcher
├── ui/             # Common UI components
├── apps/           # Native applications
├── security/       # Security framework
├── package-manager/# Package management system
├── updater/        # OTA update system
├── recovery/       # Recovery environment
├── quantum/        # Quantum/Qubit simulator
├── qemu/           # QEMU-specific configs
├── tools/          # Diagnostic & build tools
├── tests/          # Test suite
├── docs/           # Documentation
├── scripts/        # Helper scripts
├── build/          # Build output (generated)
├── CMakeLists.txt  # Main build configuration
├── README.md       # This file
└── ROADMAP.md      # Development roadmap
```

## Documentation

- **[ROADMAP.md](./ROADMAP.md)** - Development roadmap and milestones
- **[docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)** - System architecture
- **[docs/BUILD.md](./docs/BUILD.md)** - Build system documentation
- **[docs/BOOT.md](./docs/BOOT.md)** - Boot process
- **[docs/NETWORK.md](./docs/NETWORK.md)** - Networking subsystem
- **[docs/WIFI.md](./docs/WIFI.md)** - Wi-Fi implementation & connectivity state
- **[docs/A20E.md](./docs/A20E.md)** - Samsung Galaxy A20e target
- **[docs/SECURITY.md](./docs/SECURITY.md)** - Security framework
- **[docs/TESTING.md](./docs/TESTING.md)** - Testing strategy
- **[docs/RECOVERY.md](./docs/RECOVERY.md)** - Recovery system
- **[docs/OTA.md](./docs/OTA.md)** - OTA update mechanism

## Build Requirements

- CMake 3.20+
- GCC/Clang with ARM64 support
- Linux kernel headers (ARM64)
- Standard build tools (make, git)
- QEMU with ARM64 support (for emulation)

## Absolute Rules

1. **Never delete working functionality** - Preserve existing implementations
2. **Never rewrite unnecessarily** - Modify only what needs fixing
3. **Maintain modular architecture** - Keep layers separate
4. **Mark reality accurately** - IMPLEMENTED vs PARTIAL vs EXPERIMENTAL vs UNSUPPORTED
5. **Never fake hardware support** - Unsupported features must be clearly marked
6. **No destructive auto-operations** - Require explicit user confirmation
7. **Preserve escape routes** - Always maintain path to restore system
8. **Test everything** - No untested code in main branch
9. **No Android dependencies** - Pure Linux only
10. **No Chromium** - Use WPE WebKit for browser

## Hardware Support Status

See individual subsystem documentation for detailed hardware support matrices.

### QEMU (ARM64)
- **Status**: Primary development target
- **CPU**: Generic ARM64
- **Display**: QEMU framebuffer + Wayland
- **Networking**: QEMU virtual NIC

### Samsung Galaxy A20e
- **Status**: Future hardware target
- **SoC**: MediaTek Helio P22
- **CPU**: ARM Cortex-A53 (octa-core)
- **RAM**: 3GB / 4GB variants
- **Storage**: 32GB / 64GB internal + microSD
- **Note**: Real hardware verification required before claiming full support

## Contributing

1. Create feature branch
2. Implement changes while preserving working code
3. Write tests for new functionality
4. Update documentation
5. Mark implementation status clearly
6. Submit for review

## License

TBD - Linux kernel components follow GPL v2+, application framework to be determined.

## Status Summary

**Current Phase**: Project initialization and infrastructure setup

**Next Steps**:
1. Set up ARM64 cross-compilation toolchain
2. Configure Linux kernel for ARM64 QEMU
3. Build initial rootfs
4. Create initramfs and boot infrastructure
5. Establish D-Bus system
6. Integrate Wayland + Qt 6

---

*ABINSTEIN OS - Building the future of independent mobile computing*
