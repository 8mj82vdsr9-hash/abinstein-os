# ABINSTEIN OS - Samsung Galaxy A20e Camera & Gallery Implementation Guide

## Overview

This guide explains how ABINSTEIN OS implements camera and gallery functionality for the Samsung Galaxy A20e, completely independent of Android.

## Camera Hardware (Galaxy A20e)

### Camera Specifications

```
Rear Camera:
  - 13 MP f/2.0
  - 1/3.06" sensor
  - PDAF (Phase Detection Auto Focus)
  - LED flash
  - Video: 1080p @ 30fps, 720p @ 60fps
  - Microphone: Noise cancellation

Front Camera:
  - 8 MP f/2.0
  - 1/4" sensor
  - Fixed focus
  - Video: 1080p @ 30fps
```

### Camera Interface (Galaxy A20e)

The Galaxy A20e uses the Exynos 7884 SoC which includes:
- ISP (Image Signal Processor)
- CSI-2 (Camera Serial Interface)
- Video4Linux2 (V4L2) kernel drivers
- Device node: `/dev/video0` (rear), `/dev/video1` (front)

## ABINSTEIN Camera Architecture

### libcamera Integration

Instead of Android's camera HAL, ABINSTEIN uses **libcamera**:

```
Application (QML Camera App)
        ↓
  Qt 6 Multimedia
        ↓
  libcamera Library
        ↓
  libcamera-core
        ↓
Kernel V4L2 Drivers
        ↓
  SoC Camera Hardware
```

### libcamera Advantages

- **Hardware-agnostic**: Works on any Linux system with V4L2 support
- **No Android dependency**: Pure Linux userspace
- **Portable**: Used by Raspberry Pi, embedded Linux, etc.
- **Open source**: Full control and transparency
- **Modern**: Supports complex features (HDR, RAW, etc.)

## File Structure

```
camera/
├── CMakeLists.txt           # Camera library build
├── include/
│   ├── camera_manager.h     # Device enumeration & control
│   ├── camera_device.h      # Low-level camera access
│   ├── camera_preview.h     # Real-time preview
│   ├── photo_capture.h      # Still photos
│   ├── video_recorder.h     # Video recording
│   ├── camera_settings.h    # ISO, exposure, focus
│   ├── focus_manager.h      # Auto/manual focus
│   ├── exposure_manager.h   # Exposure control
│   └── white_balance.h      # Color correction
└── src/
    └── [implementations]

gallery/
├── CMakeLists.txt           # Gallery app build
├── include/
│   ├── gallery_model.h      # Media enumeration
│   ├── image_viewer.h       # Full-screen viewing
│   ├── video_viewer.h       # Video playback
│   ├── thumbnail_provider.h # Thumbnail generation
│   ├── media_scanner.h      # File discovery
│   ├── image_editor.h       # Photo editing
│   ├── slideshow.h          # Slideshow mode
│   └── metadata_reader.h    # EXIF/metadata
└── src/
    └── [implementations]
```

## Camera Manager Implementation

### Device Enumeration

```cpp
// Get all available cameras
QList<QString> cameras = camera_manager->getAvailableCameras();

// Select specific camera
camera_manager->selectCamera("1"); // Rear camera
camera_manager->selectCamera("0"); // Front camera
```

### Camera Capabilities

```cpp
// Check what this camera can do
bool has_focus = camera_manager->hasCapability(camera_id, CameraCapability::AutoFocus);
bool has_flash = camera_manager->hasCapability(camera_id, CameraCapability::FlashControl);
bool can_zoom = camera_manager->hasCapability(camera_id, CameraCapability::DigitalZoom);
```

### Resolution Support

```cpp
// Galaxy A20e rear camera typical resolutions:
QList<QSize> resolutions = camera_manager->getSupportedResolutions();
// Results: 4160x3120 (13MP), 3264x2448, 2560x1920, 2048x1536, 1920x1440, 1280x960, 640x480
```

### Frame Rate Support

```cpp
QList<int> frame_rates = camera_manager->getSupportedFrameRates();
// Results: 30, 60, 120 fps (depending on resolution)
```

## Photo Capture

### Basic Photo Capture

```cpp
PhotoCapture photo_capture;

// Capture high-quality JPEG
bool success = photo_capture.capturePhoto(
    "/home/user/Pictures/photo_001.jpg",
    PhotoCapture::Format::JPEG,
    PhotoCapture::Quality::High
);
```

### Burst Mode

```cpp
// Capture 10 photos in rapid succession
photo_capture.startBurstCapture(
    10,
    "/home/user/Pictures/burst/",
    PhotoCapture::Format::JPEG
);

// Monitor progress
while (photo_capture.getBurstProgress() < 100) {
    usleep(100000); // 100ms
}
```

### HDR Capture

```cpp
// High Dynamic Range photo (combines multiple exposures)
photo_capture.captureHDR("/home/user/Pictures/hdr_001.jpg");
```

## Video Recording

### Start Recording

```cpp
bool success = camera_manager->startVideoRecording(
    "/home/user/Videos/video_001.mp4"
);
```

### Pause/Resume

```cpp
// Pause without stopping file write
camera_manager->pauseVideoRecording();

// Resume recording to same file
camera_manager->resumeVideoRecording();
```

### Stop Recording

```cpp
camera_manager->stopVideoRecording();
// File is now complete and playable
```

## Camera Settings

### Exposure Control

```cpp
// Exposure Value (EV): -2.0 to +2.0
camera_manager->setExposure(0.5);  // Brighter
camera_manager->setExposure(-0.5); // Darker
```

### White Balance

```cpp
camera_manager->setWhiteBalance("auto");      // Automatic
camera_manager->setWhiteBalance("daylight");  // Sunny outdoor
camera_manager->setWhiteBalance("cloudy");    // Overcast
camera_manager->setWhiteBalance("tungsten");  // Indoor incandescent
camera_manager->setWhiteBalance("fluorescent"); // Neon/fluorescent
```

### Focus Control

```cpp
camera_manager->setFocus("auto");        // Continuous autofocus
camera_manager->setFocus("manual");      // Manual focus (with distance)
camera_manager->setFocus("macro");       // Close-up focus
camera_manager->setFocus("infinity");    // Landscape focus
```

### Flash Control

```cpp
camera_manager->setFlash("off");     // No flash
camera_manager->setFlash("on");      // Always flash
camera_manager->setFlash("auto");    // Smart flash
camera_manager->setFlash("red-eye"); // Red-eye reduction
```

### Zoom

```cpp
// Digital zoom (1.0 = no zoom, 2.0 = 2x zoom)
camera_manager->setZoom(1.5); // 1.5x digital zoom
```

## Gallery Implementation

### Media Scanning

```cpp
GalleryModel gallery;

// Scan common photo/video directories
gallery.scanMediaFiles({
    "/home/user/Pictures",
    "/home/user/Videos",
    "/home/user/DCIM"
});
```

### Filtering & Sorting

```cpp
// Show only photos
gallery.filterByType("photo");

// Sort by capture date (newest first)
gallery.sortBy("date");

// Filter by date range
QDateTime start = QDateTime(QDate(2026, 1, 1));
QDateTime end = QDateTime::currentDateTime();
gallery.filterByDate(start, end);

// Search by name
gallery.searchMedia("vacation");
```

### Favorites

```cpp
// Mark as favorite
gallery.setFavorite(0, true);

// Get all favorites
QList<MediaItem> favorites = gallery.getFavorites();
```

### Albums

```cpp
// Create new album
gallery.createAlbum("Vacation 2026");

// Add media to album
gallery.addToAlbum(0, "Vacation 2026");

// Get album contents
QList<MediaItem> album = gallery.getAlbumContents("Vacation 2026");

// Delete album
gallery.deleteAlbum("Vacation 2026");
```

### Image Editing

```cpp
ImageEditor editor;

// Load image
editor.loadImage("/home/user/Pictures/photo_001.jpg");

// Rotate
editor.rotate(90);

// Crop
editor.crop(100, 100, 800, 600);

// Adjust brightness
editor.adjustBrightness(20);

// Apply filter
editor.applySharpen(5);

// Auto enhance
editor.autoEnhance();

// Save
editor.saveImage("/home/user/Pictures/photo_001_edited.jpg");
```

## Galaxy A20e Hardware Setup

### Kernel Camera Drivers

For Galaxy A20e to work, the Linux kernel must have:

```bash
# Device tree defines camera hardware
device/samsung-galaxy-a20e/exynos7884-a20e.dtsi:
  - Camera ISP definitions
  - CSI-2 interface configuration
  - Sensor I2C addresses
  - GPIO pins for flash/focus

# Kernel drivers
/drivers/media/platform/exynos4-is/
  - Exynos ISP driver
  - FIMC driver (camera interface)
  - SCALER driver (image processing)

# Sensor drivers
/drivers/media/i2c/
  - IMX258 driver (rear sensor)
  - OV8856 driver (front sensor) - depends on actual hardware
```

### Device Tree Camera Configuration

```dts
// Example from device/samsung-galaxy-a20e/camera.dtsi

camera {
    compatible = "samsung,exynos7884-camera";
    
    rear_camera {
        compatible = "sony,imx258";
        reg = <0x1a>;  // I2C address
        clocks = <&cmu CSIS_CLK>;
        power-supply = <&reg_camera_vdd>;
        gpio-enable = <&gpd1 4 0>;  // GPIO control
        
        port {
            imx258_ep: endpoint {
                remote-endpoint = <&csi_in>;
                data-lanes = <1 2 3 4>;
                clock-lanes = <0>;
            };
        };
    };
    
    csi {
        compatible = "samsung,exynos7884-csis";
        
        port {
            csi_in: endpoint {
                remote-endpoint = <&imx258_ep>;
            };
        };
    };
};
```

## Building for Galaxy A20e

### Target-Specific Build

```bash
# Build camera library for A20e
./build_os.sh a20e --camera

# Includes:
# - libcamera compiled for Exynos 7884
# - Camera sensor drivers
# - Device tree modifications
# - libcamera-core for ARM64
```

### Installation

```bash
# Copy to A20e via recovery
# Camera libraries go to /system/lib64/libcamera.so*
# Camera config goes to /etc/libcamera/ov*.json
# Device tree goes to boot.img
```

## Testing Camera Functionality

### QEMU Virtual Camera

```bash
# Launch QEMU with virtual camera
qemu-system-aarch64 \
  ... \
  -device virtio-camera-device

# In QEMU shell:
ls /dev/video*  # Should show /dev/video0
```

### Actual A20e Device

```bash
# Connect via ADB/recovery shell
adb shell

# Test camera device
ls -la /dev/video*
# Should show:
# /dev/video0  (rear camera)
# /dev/video1  (front camera)

# Test libcamera
libcamera-hello --list
# Should enumerate available cameras
```

## Performance Optimization

### Memory Efficiency
- Thumbnail generation: Offload to separate thread
- Gallery grid: Virtual list model (lazy loading)
- Video playback: Hardware decoder when available

### Speed
- Camera preview: Direct display without copies
- Photo capture: Hardware JPEG encoding
- Gallery scanning: Background thread with progress updates

### Power Management
- Idle camera preview: Reduced frame rate
- Video recording: Only when needed
- Display: Lower brightness for photo review

## Known Limitations

### QEMU
- No real camera hardware
- Virtual camera provides test patterns
- Resolution/framerate limitations

### Galaxy A20e
- Requires hardware sensor support in kernel
- No optical zoom (digital only)
- HDR performance depends on ISP capabilities
- Thermal throttling at high bitrate recording

## Troubleshooting

### Camera won't initialize
```bash
# Check libcamera installation
pkg-config --list-all | grep libcamera

# Check camera permissions
ls -la /dev/video*

# Test with libcamera-hello
libcamera-hello --list
```

### No video preview
```bash
# Check Wayland display server
echo $WAYLAND_DISPLAY

# Test Wayland socket
ls -la /run/user/$(id -u)/wayland-*
```

### Photos not saving
```bash
# Check storage permissions
ls -la /home/user/Pictures/

# Check disk space
df -h /home/user/

# Check for errors
journalctl -u abinstein-camera.service
```

## Future Enhancements

- [ ] Manual focus distance control
- [ ] RAW DNG support
- [ ] Lens distortion correction
- [ ] Advanced HDR processing
- [ ] Time-lapse and slow-motion
- [ ] Panorama stitching
- [ ] Face detection and tracking
- [ ] QR code scanning
- [ ] Augmented reality filters
- [ ] Cloud backup integration

## See Also

- [libcamera Documentation](https://libcamera.org/)
- [Android Camera HAL (for reference)](https://source.android.com/devices/camera)
- [Linux V4L2 API](https://www.kernel.org/doc/html/latest/userspace-api/media/v4l/v4l2.html)
- [Qt 6 Multimedia](https://doc.qt.io/qt-6/qtmultimedia-index.html)
