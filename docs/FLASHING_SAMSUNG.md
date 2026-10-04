# Samsung Flashing Guide for ABINSTEIN OS

## Important Note

Odin does not accept plain `.zip` files for a Linux-based custom OS image like ABINSTEIN OS. Odin is designed for Samsung firmware packages in `.tar` or `.tar.md5` format, not raw Linux image files.

For ABINSTEIN OS, the correct flashing path is:

- Use raw image files (`.img`) with fastboot or Heimdall
- Or flash a custom recovery then install the OS image from recovery
- Do not expect Odin to install a Linux OS packaged as a ZIP archive

## Recommended Method: Fastboot + IMG Files

This is the easiest and most reliable method for Samsung Galaxy A20e and similar devices.

### Prerequisites

- Samsung Galaxy A20e or supported device
- USB debugging enabled
- OEM unlock enabled
- Bootloader unlocked
- ADB and fastboot installed on your PC
- ABINSTEIN OS images built in the `build/` directory:
  - `boot.img`
  - `system.img`
  - `recovery.img`
  - `vendor.img` (if applicable)

### Step 1: Enable Developer Options

1. Go to Settings
2. Tap About phone
3. Tap Build number repeatedly until Developer mode is enabled
4. Open Developer Options
5. Enable:
   - OEM unlocking
   - USB debugging

### Step 2: Connect the Phone

```bash
adb devices
```

If the phone is listed, continue. If not, install the proper Samsung USB drivers or use the correct USB cable.

### Step 3: Reboot to Bootloader

```bash
adb reboot bootloader
```

### Step 4: Verify Fastboot Device

```bash
fastboot devices
```

If the device appears, you are ready to flash.

### Step 5: Flash the Images

```bash
fastboot flash recovery recovery.img
fastboot flash boot boot.img
fastboot flash system system.img
fastboot flash vendor vendor.img
```

If your build does not include a vendor image, skip that line.

### Step 6: Wipe Data

```bash
fastboot -w
```

This clears the device data and ensures a clean install.

### Step 7: Reboot

```bash
fastboot reboot
```

---

## Alternative: Heimdall (Linux/Mac)

Heimdall is the Linux/Mac equivalent of Odin. It accepts raw partitions rather than ZIP files.

### Install Heimdall

On Ubuntu/Debian:

```bash
sudo apt install heimdall-flash
```

On macOS:

```bash
brew install heimdall
```

### Put Device in Download Mode

1. Power off the phone
2. Hold Volume Down + Power
3. Connect USB cable to the PC
4. Continue holding until the device enters Download mode

### Flash Using Heimdall

```bash
heimdall flash \
  --RECOVERY recovery.img \
  --BOOT boot.img \
  --SYSTEM system.img \
  --VENDOR vendor.img
```

Then reboot:

```bash
heimdall reboot
```

---

## Odin Method: What It Accepts

Odin is only for Samsung firmware packages in Samsung's packaging format, usually:

- `.tar`
- `.tar.md5`

It does not support:

- `.zip` from a Linux custom OS build
- raw `.img` files from a generic Linux system
- Android ROM packages built as a generic OS image

For ABINSTEIN OS, use either:

- fastboot with raw `.img` files, or
- Heimdall with raw partition images

---

## If the Phone Won't Flash

### Check Device Connection

```bash
adb devices
fastboot devices
```

### Unlock the Bootloader

```bash
fastboot flashing unlock
```

Confirm on the phone if prompted.

### Try a clean wipe

```bash
fastboot erase userdata
fastboot erase cache
fastboot -w
```

### Reboot to recovery

```bash
adb reboot recovery
```

---

## Build Output Requirement

Your build pipeline must generate raw partition images, not only ZIP packages.

Example expected outputs:

```bash
ls build/
```

Expected files:

- `boot.img`
- `system.img`
- `recovery.img`
- `vendor.img` (sometimes optional)

If your build only produces a ZIP package, it will not work with Odin directly and may need to be converted or repackaged for Samsung's official firmware format.

---

## Correct Workflow for ABINSTEIN OS

The correct process is:

1. Build raw Android/Linux boot images
2. Flash via fastboot or Heimdall
3. Wipe userdata
4. Reboot to the new OS

Do not use a ZIP file with Odin unless the repo explicitly provides a Samsung-compatible `.tar` firmware package.

---

## Recommended Choice

For ABINSTEIN OS, the preferred install path is:

- Samsung A20e: fastboot + raw `.img` files
- Samsung phones with alternative flashing support: Heimdall
- Odin: only for official Samsung firmware, not for this Linux-based OS project

---

## Quick Summary

- Odin accepts Samsung ROM archives, not custom Linux ZIPs
- ABINSTEIN OS should be flashed as raw partition images
- Use `fastboot` or `Heimdall`, not Odin, for this project
