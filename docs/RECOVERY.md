# Recovery and Repair Procedures

## Purpose

ABINSTEIN OS is designed to remain recoverable even when the normal boot path fails. If the system does not start correctly, the system must automatically attempt a repair cycle before falling back to a recovery shell.

## Recovery Philosophy

The recovery model is based on three principles:

1. Preserve user data.
2. Prefer the last known-good state over destructive resets.
3. Keep a minimal recovery environment available even if the regular UI fails to open.

## Boot Recovery Sequence

When the device fails to boot or the main shell does not open:

1. Bootloader verifies kernel and initramfs.
2. The system checks the integrity of rootfs, device tree, and configuration files.
3. If corruption is detected, the boot manager selects the most recent known-good snapshot.
4. The system attempts to repair missing or damaged runtime files.
5. If repair succeeds, the system restarts and tries to open the normal UI again.
6. If repair fails, the device enters recovery mode and opens a shell for manual diagnosis.

## Recovery Modes

### 1. Automatic repair mode
Used when the system can still reach the boot manager. This mode restores broken config or metadata without erasing user data.

### 2. Safe rollback mode
Used when the current root image is inconsistent or unstable. This mode boots the last healthy image and preserves user data and configuration snapshots.

### 3. Manual recovery shell
Used when the system cannot boot normally or the UI cannot open. This mode gives access to a minimal shell for log inspection, file repair, configuration resets, and verification commands.

## Required Behaviors

- If the UI does not open, the system must not remain stuck in a dead boot loop.
- A failed repair attempt must trigger a known fallback path.
- Recovery actions must never permanently wipe the user data path without explicit confirmation.
- The system must record repair events in a log for troubleshooting.

## Example Recovery Flow

- Boot fails because Wayland or the Qt shell crashes.
- System validates the graphics stack and falls back to a minimal compositor-only mode.
- If compositor startup still fails, the device enters recovery mode.
- Recovery shell opens and presents a minimal command interface.
- User can repair files, restore a snapshot, or re-enable the default configuration.

## Final Rule

If the system does not open normally, it must repair itself first, then recover, then open the recovery shell only as a fallback.
