# ABINSTEIN OS Architecture

## System Layers

```
┌─────────────────────────────────────────────┐
│      Applications & Services                │
│  (Launcher, Settings, Browser, Apps)        │
├─────────────────────────────────────────────┤
│      Qt 6 / QML Framework                   │
│  (UI Components, Graphics Rendering)        │
├─────────────────────────────────────────────┤
│      Wayland Compositor                     │
│  (Window Management, Input Routing)         │
├─────────────────────────────────────────────┤
│      D-Bus System Bus                       │
│  (IPC, Service Discovery)                   │
├─────────────────────────────────────────────┤
│      System Services                        │
│  (Power, Audio, Network, Display, etc.)     │
├─────────────────────────────────────────────┤
│      Hardware Abstraction Layer (HAL)       │
│  (Unified interface for all hardware)       │
├─────────────────────────────────────────────┤
│      Linux Kernel (ARM64)                   │
│  (Process management, Memory, Drivers)      │
├─────────────────────────────────────────────┤
│      Hardware                               │
│  (CPU, Display, Storage, Networking)        │
└─────────────────────────────────────────────┘
```

## Key Components

### 1. Linux Kernel
- ARM64 architecture (aarch64)
- Device Tree support
- DRM/KMS for graphics
- All necessary drivers for target hardware
- Modular design for portability

### 2. Hardware Abstraction Layer (HAL)
- Unified interface for hardware access
- Platform-specific implementations
- Separate configurations for QEMU and A20e
- Clean separation from userspace

### 3. D-Bus System Bus
- Central communication backbone
- Service registration and discovery
- Privileged operations through system bus
- Session bus for user applications

### 4. System Services
- **Power Management**: Battery, charging, suspend/resume
- **Display Manager**: Screen configuration, rotation
- **Network Manager**: Wi-Fi, Bluetooth, cellular (where available)
- **Audio Manager**: Volume, routing, device management
- **Input Manager**: Touchscreen, buttons, gestures
- **Device Manager**: Hardware detection and management

### 5. Wayland + Compositor
- Wayland protocol implementation
- Custom mobile compositor for:
  - Window management
  - Touch input routing
  - Screen rotation
  - Gesture recognition
  - Visual transitions

### 6. Qt 6 / QML Framework
- Qt Quick for rapid UI development
- Qt DBus for D-Bus communication
- Qt Multimedia (when applicable)
- Qt Network for applications
- Custom mobile-optimized components

### 7. Mobile Shell (UI)
- Status bar and system information
- Lock screen
- Launcher with app grid
- Quick settings panel
- Notification center
- Recent apps switcher
- All integrated with Wayland gestures

## Communication Patterns

### IPC via D-Bus
All system components communicate through D-Bus:

```
Application 
    ↓ (D-Bus call)
System Service
    ↓ (kernel API)
Kernel Driver
    ↓ (hardware operation)
Hardware
```

### Example: Wi-Fi Connection
1. User taps Wi-Fi in Settings
2. Settings application → D-Bus NetworkManager.Connect()
3. NetworkManager → HAL → kernel driver → Wi-Fi hardware
4. Hardware associates → NetworkManager updates state
5. NetworkManager → D-Bus signal → Settings UI updates

## Module Dependencies

```
┌─ Apps (Launcher, Settings, Browser, etc.)
├─ Qt 6 / QML (depends on)
│  ├─ Wayland client libraries
│  ├─ D-Bus client
│  └─ Platform plugins
├─ Wayland Compositor (depends on)
│  ├─ D-Bus (for input, output services)
│  ├─ DRM/KMS (for display management)
│  └─ libinput (for input devices)
├─ System Services (depends on)
│  ├─ D-Bus daemon
│  ├─ HAL
│  ├─ kernel drivers
│  └─ platform libraries
├─ HAL (depends on)
│  ├─ kernel APIs
│  ├─ Device tree
│  └─ platform-specific code
└─ Linux Kernel (depends on)
   └─ Hardware
```

## Security Model

### Privilege Separation
- Root services: Power, network, security
- User services: Applications, user UI
- D-Bus enforces permissions

### Sandboxing
- Applications run with minimal privileges
- File system access restricted
- IPC through D-Bus (auditable)
- Camera/microphone access explicit

### Trust Chain
- Secure boot (where applicable)
- Signed kernel
- Verified rootfs
- OTA update verification

## Platform Variations

### QEMU ARM64
- HAL layer uses QEMU device models
- Framebuffer for display
- Virtual NIC for networking
- No real hardware constraints

### Samsung Galaxy A20e
- HAL layer uses MediaTek Helio P22 interfaces
- Display drivers for panel
- Real Wi-Fi/Bluetooth hardware
- Power management with real battery
- Modem for cellular connectivity

## Data Flow Example: Network State

```
User Action (Tap Wi-Fi)
    ↓
UI (Settings/QML)
    ↓
D-Bus NetworkManager.Connect(ssid, password)
    ↓
NetworkManager Service
    ├─ Calls HAL setWifiEnabled()
    ├─ Calls HAL scan()
    ├─ Calls HAL associate(ssid, auth)
    ├─ Calls kernel DHCP
    ├─ Checks DNS
    ├─ Verifies internet connectivity
    └─ Emits signal NetworkStateChanged()
        ↓
    D-Bus signal received by UI
        ↓
    Settings UI updates to show "Connected"
    Browser ConnectivityChecker updates
    All apps receive notification
```

## Future Extensions

- **VoIP Integration**: Matrix.org or SIP support
- **Containerization**: Flatpak-style sandboxing
- **Desktop Convergence**: Matrix output for external display
- **Biometric Security**: Fingerprint/face recognition
- **Extended Reality**: AR/VR capabilities
