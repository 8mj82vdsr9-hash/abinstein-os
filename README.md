# ABINSTEIN OS

ABINSTEIN OS is an independent Linux-based mobile operating system designed for ARM64 devices. It is built around a modular architecture, hardware abstraction, Qt/QML-based interfaces, and a mobile-first system design intended for emulation, device experimentation, and future real hardware support.

## Vision

ABINSTEIN OS is a modern mobile operating system designed from the ground up with:

- Kernel: Linux ARM64 / aarch64
- Display stack: Wayland + Qt 6 / QML
- Hardware support: Wi-Fi, Bluetooth, audio, camera, modem, sensors
- Applications: native mobile apps with Qt/QML
- Connectivity: full networking stack with state management
- Security: privilege separation and secure IPC via D-Bus
- Package management: custom package manager with OTA support
- Innovation: quantum / qubit simulation core

## Target Platforms

1. QEMU (ARM64) - Primary development target
2. Samsung Galaxy A20e - Real hardware evaluation target
3. Pixel-style display / pixel screen evaluation - Prototype UI and display integration track

## Hardware Catalog

The project currently tracks the following hardware families and components.

### Development / Emulation Hardware
- QEMU ARM64 virtual platform
- Generic ARM64 SoC emulation
- Virtual framebuffer / virtual display
- Virtual NIC / networking emulation

### Mobile Hardware Targets
- Samsung Galaxy A20e
  - SoC: Exynos 7885
  - CPU: ARM Cortex-A53 (octa-core)
  - RAM: 3GB / 4GB
  - Storage: 32GB / 64GB + microSD
  - Display: 6.4-inch Infinity-V display
  - Connectivity: Wi-Fi, Bluetooth, LTE, GPS, sensors
  - Status: future target, verification required
- Pixel screen / Pixel display prototype track
  - Includes pixel-class display panels and display stack evaluation
  - Status: prototype / evaluation phase, not yet verified as supported hardware

### Hardware Component Families
- Display panels: AMOLED / LCD / OLED mobile displays, including pixel-style panel evaluations
- Touchscreens: capacitive touch controllers and calibration paths
- Wi-Fi radios: IEEE 802.11 interfaces
- Bluetooth radios: HCI adapters and pairing stacks
- Audio devices: speakers, microphones, and audio codecs
- Camera modules: rear and front imaging sensors
- Sensors: proximity, accelerometer, gyroscope, ambient light
- Modems: LTE / cellular control paths
- Storage: eMMC / UFS / flash-backed device storage
- Power: battery, PMIC, charging, thermal management

## Project Status

- [x] Repository initialization
- [x] Project structure
- [x] Build system foundation (CMake)
- [ ] ARM64 toolchain setup
- [ ] Linux kernel ARM64 configuration
- [ ] Device tree framework
- [ ] Boot image generation
- [ ] Root filesystem construction
- [ ] Initramfs creation
- [ ] QEMU boot validation
- [ ] D-Bus integration
- [ ] Wayland compositor foundation
- [ ] Qt 6 / QML shell
- [ ] Application framework
- [ ] Browser app foundation
- [ ] Camera system foundation
- [ ] Network stack
- [ ] Wi-Fi support validation
- [ ] Bluetooth integration
- [ ] Package manager
- [ ] OTA support
- [ ] Recovery system
- [ ] Quantum core
- [ ] Security hardening
- [ ] Full testing suite

## Architecture

```text
Applications & Services
    ↓
Qt 6 / QML Framework
    ↓
Wayland Compositor
    ↓
D-Bus System Bus
    ↓
System Services
    ↓
Hardware Abstraction Layer (HAL)
    ↓
Linux Kernel (ARM64)
    ↓
Hardware
```

## Key Components

### 1. Linux Kernel
- ARM64 / aarch64 support
- Device tree support
- DRM/KMS graphics support
- Mobile-friendly kernel configuration
- Modular driver design for portability

### 2. Hardware Abstraction Layer (HAL)
- Unified platform interface for hardware access
- Device-specific implementations for QEMU and A20e
- Clean separation between userspace and hardware drivers
- Support for display, input, power, and sensor control

### 3. D-Bus System Bus
- Central IPC backbone
- Service registration and discovery
- Device state tracking
- System service communication

### 4. Wayland + Qt 6 / QML
- Mobile UI framework
- Modern windowing and compositing model
- App shell and launcher support
- Flexible interface development for embedded devices

### 5. Native Mobile Applications
- Browser
- App store
- Camera and gallery
- Settings and system tools
- Core services and user-facing system apps

### 6. Networking and Sensor Stack
- Wi-Fi management
- Bluetooth interfaces
- Cellular / modem abstraction
- Sensor polling and event handling

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

## Samsung A20e Flashing Guide

ABINSTEIN OS is designed to be flashed to supported ARM64 devices, including the Samsung Galaxy A20e, using raw partition images instead of standard Samsung Odin firmware packages.

### Correct Flash Method

Use one of the following:

- fastboot with raw `.img` files
- Heimdall with raw partition images

Do not use Odin for a generic custom Linux OS ZIP package unless Samsung firmware packaging is explicitly provided.

### Example Fastboot Flow

```bash
adb reboot bootloader
fastboot devices
fastboot flashing unlock
fastboot flash recovery recovery.img
fastboot flash boot boot.img
fastboot flash system system.img
fastboot flash vendor vendor.img
fastboot -w
fastboot reboot
```

### Example Heimdall Flow

```bash
heimdall flash \
  --RECOVERY recovery.img \
  --BOOT boot.img \
  --SYSTEM system.img \
  --VENDOR vendor.img
```

## Directory Structure

```text
abinstein-os/
├── apps/            # Native mobile applications
├── camera/          # Camera subsystem
├── core/            # Core system libraries and utilities
├── docs/            # Documentation and architecture notes
├── gallery/         # Media gallery
├── hal/             # Hardware abstraction layer
├── initramfs/       # Initial RAM filesystem
├── kernel/          # ARM64 kernel tree and config
├── network/         # Networking stack and connectivity
├── quantum/         # Quantum / qubit subsystem
├── rootfs/          # Root filesystem tree
├── scripts/         # Utility scripts
├── services/        # System daemons and services
├── shell/           # Mobile shell and UI shell parts
├── tests/           # Validation and regression tests
├── toolchain/       # ARM64 cross-compilation toolchain
├── tools/           # Utility tools
├── build_os.sh      # Main build script
├── CMakeLists.txt   # Top-level build configuration
├── README.md        # Project overview
├── ROADMAP.md       # Development roadmap
└── LICENSE          # License details if present
```

## Roadmap

### Phase 1: Foundation
- Repository and project structure
- Build system setup
- ARM64 toolchain
- Kernel and boot basics
- Rootfs and initramfs

### Phase 2: Hardware Abstraction and Services
- HAL design
- D-Bus service framework
- Device manager
- Networking and connectivity services
- Sensor and power management

### Phase 3: Display, Graphics, and Compositor
- Wayland support
- Compositor implementation
- Input and gesture handling
- Qt 6 + QML integration

### Phase 4: Mobile UI and Applications
- Launcher and status bar
- Settings app
- Browser app
- Camera and gallery
- App store and package manager

### Phase 5: Production Readiness
- Stability and performance tuning
- Hardware validation
- Security review and hardening
- OTA update pipeline
- Full test coverage

## Why ABINSTEIN OS?

ABINSTEIN OS is designed for those who want an independent mobile operating system that is:

- open and configurable
- Linux-first
- ARM64-focused
- modular and extensible
- suitable for experimentation, porting, and custom hardware development

It combines modern mobile OS design patterns with embedded system flexibility, making it ideal as a prototype mobile platform and a learning-centered Linux OS project.

## Contributing

Contributions are welcome in the following areas:

- kernel and boot configuration
- HAL and device support
- D-Bus service design
- Wayland / compositor work
- Qt 6 / QML shell
- networking and device drivers
- testing and CI

## Final Note

ABINSTEIN OS is still in early-stage development, but it is structured around a serious mobile OS architecture with real hardware targets, proper service separation, and a roadmap toward a complete ARM64-based mobile environment.
