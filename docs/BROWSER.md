# ABINSTEIN Browser

## Overview

ABINSTEIN Browser is a lightweight, privacy-focused mobile web browser built on **WPE WebKit**.

**KEY RULE**: **NO CHROMIUM** - We use pure WPE WebKit

## Architecture

```
Browser UI (Qt/QML)
    ↓
Browser Engine (WPE WebKit)
    ↓
Wayland Compositor
    ↓
Linux Kernel
```

## Features

### Navigation
- URL bar with suggestions
- Back/Forward buttons
- Reload and Stop
- Home button
- History tracking
- Bookmarks management

### Tabs
- Multiple tabs support
- Tab switching
- Tab close with confirmation
- Recent tabs recovery

### Content
- Full HTML5/CSS3 support (via WPE WebKit)
- JavaScript execution
- Image rendering
- Video playback (HTML5)
- Form handling

### Privacy
- Private browsing mode
- No history in private mode
- Cookie management
- Tracking prevention
- Cache clearing
- DNS privacy

### Security
- SSL/TLS certificate verification
- Password manager integration
- Popup blocking
- Phishing detection
- Malware warnings

### Network State Detection
**CRITICAL**: Browser integrates with `NetworkStateManager`

The browser MUST check actual network state:
1. Is radio enabled?
2. Is interface associated?
3. Has valid IP?
4. Has default route?
5. Can reach DNS servers?
6. Can reach actual internet server?

If any step fails, show appropriate error:
- "No Wi-Fi"
- "Connecting..."
- "Connected, no IP"
- "Connected, no Internet"
- "DNS error"
- "Server unreachable"

### Downloads
- Download manager integration
- Resume downloads
- Download history
- File organization

### Performance
- Efficient memory usage
- Tab isolation
- Background tab suspension
- Cache management

## Implementation Status

- [ ] WPE WebKit integration
- [ ] Basic navigation
- [ ] Tab management
- [ ] History & bookmarks
- [ ] Private mode
- [ ] Network state detection
- [ ] Download handling
- [ ] Settings UI
- [ ] Sync framework (optional)

## Dependencies

- Qt 6 (Core, Quick, DBus, Network)
- WPE WebKit 1.0+
- WPE Backend FDO
- OpenSSL
- Abinstein Network subsystem
- D-Bus (NetworkManager integration)

## Build

```bash
make -C apps/browser
```

## Run

```bash
./abinstein-browser
```

## Configuration

~/.config/abinstein-browser/
- settings.conf
- bookmarks.json
- history.db
- cache/ (cleared on exit if private mode)

## Known Issues

- WPE WebKit resource usage on ARM64 needs optimization
- Hardware video acceleration on QEMU not available
- Touch gesture support WIP

## Future Enhancements

- Sync with cloud services (own server)
- Web app installation
- Reader mode
- Tab groups
- Advanced privacy settings
