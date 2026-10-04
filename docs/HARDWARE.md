# ABINSTEIN OS Hardware Catalog

This document tracks the device families, hardware components, and support status relevant to the ABINSTEIN OS project.

## Supported / Target Platforms

### 1. QEMU ARM64
- **Status**: Primary development target
- **Purpose**: Kernel, userspace, system services, and display validation
- **Platform type**: Virtualized ARM64 machine
- **Hardware profile**: Generic CPU, virtual NIC, virtual framebuffer

### 2. Samsung Galaxy A20e
- **Status**: Future hardware target
- **Platform type**: Real mobile device
- **SoC**: MediaTek Helio P22
- **CPU**: ARM Cortex-A53 octa-core
- **RAM**: 3GB / 4GB
- **Storage**: 32GB / 64GB + microSD
- **Focus areas**: Display, touchscreen, Wi-Fi, Bluetooth, audio, modem, power

### 3. Pixel display / Pixel screen evaluation
- **Status**: Prototype / evaluation track
- **Platform type**: Display hardware evaluation
- **Purpose**: Validate display driver and compositor behavior for Pixel-class panels
- **Focus areas**: panel detection, display timing, touch integration, brightness control, rotation
- **Important note**: Not yet marked as a fully supported hardware target until verification is complete

## Hardware Component Matrix

| Component | Examples | Status |
| --- | --- | --- |
| CPU | ARM64, Cortex-A53, Helio P22 | Planned / evaluated |
| Display | QEMU framebuffer, Pixel-style panel, AMOLED/LCD | Prototype / planned |
| Input | Touchscreen, buttons, gestures | Planned |
| Networking | Wi-Fi, Bluetooth, Ethernet, modem | Planned |
| Audio | Speaker, microphone, codec | Planned |
| Storage | eMMC, UFS, microSD | Planned |
| Power | Battery, charging, suspend/resume | Planned |
| Cameras | Front/rear camera interfaces | Planned |
| Sensors | GPS, light, proximity, accelerometer | Planned |

## Pixel Screen Notes

The Pixel screen branch is treated as an early hardware validation effort. It is recorded here as a display prototype track so the project remains transparent about what is implemented, partial, or under evaluation.

## Support Rules

- Do not claim a device is supported until it has been tested on real hardware.
- Mark experimental display work clearly as prototype/evaluation.
- Maintain a separate path for hardware validation and production support.
- Keep implementation claims aligned with actual verification status.

## Summary

ABINSTEIN OS is currently centered around ARM64 QEMU for development, with Samsung Galaxy A20e as the main real-device target and Pixel display work treated as an early evaluation effort for screen and compositor integration.
