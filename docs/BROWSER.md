# ABINSTEIN BROWSER - Technical Deep Dive

## Overview

ABINSTEIN Browser is a **lightweight, privacy-focused mobile web browser** built on **WPE WebKit**.

🚫 **KEY RULE**: **NO CHROMIUM** - We use pure WPE (Web Platform for Embedded) WebKit

## Why WPE WebKit?

| Aspect | Chromium | WPE WebKit | ABINSTEIN Choice |
|--------|----------|-----------|------------------|
| **Size** | ~1.5 GB | ~150 MB | WPE (lightweight) |
| **Dependencies** | Google Play Services, Android Runtime | Linux libraries | WPE (pure Linux) |
| **ARM64 Support** | Requires Android | Full native support | WPE |
| **Performance** | High (but heavy) | Good (lightweight) | WPE |
| **Privacy** | Google telemetry | No tracking | WPE |
| **Updates** | Requires Google Play | Direct updates | WPE |
| **License** | Proprietary | LGPL/open source | WPE |

## Architecture

```
┌─────────────────────────────────────────┐
│     Qt 6 QML User Interface Layer      │
│  (Status bar, URL bar, tabs, menus)    │
├─────────────────────────────────────────┤
│      ABINSTEIN Browser Engine            │
│   (Tab management, history, security)  │
├─────────────────────────────────────────┤
│        WPE WebKit Rendering             │
│  (HTML5, CSS3, JavaScript, Media)      │
├─────────────────────────────────────────┤
│      Wayland Compositor Interface       │
│   (Display, input, surface management) │
├─────────────────────────────────────────┤
│         D-Bus IPC (NetworkManager)      │
│     (Network state, connectivity checks)│
├─────────────────────────────────────────┤
│       Linux Kernel (ARM64)              │
│   (Graphics: DRM/KMS, Input: evdev)   │
└─────────────────────────────────────────┘
```

## Features

### Navigation
- **URL Bar**: Type URLs with auto-complete
- **Back/Forward**: History navigation
- **Reload/Stop**: Content loading control
- **Home Button**: Configurable homepage
- **Refresh**: Pull-to-refresh gesture

### Tabs
- **Multiple Tabs**: Handle several sites simultaneously
- **Tab Switching**: Swipe between tabs
- **Tab Close**: Close individual tabs
- **New Tab**: Blank tab or with home page
- **Tab Recovery**: Restore recently closed tabs

### Content Support
- **HTML5/CSS3**: Full support via WPE WebKit
- **JavaScript**: ECMAScript 2020+ support
- **Video**: HTML5 `<video>` tag with H.264/WebM
- **Audio**: HTML5 `<audio>` tag
- **Images**: JPEG, PNG, WebP, GIF
- **Responsive Design**: Mobile-optimized layouts
- **Geolocation**: Permission-based location access

### Privacy Features
- **Private Browsing Mode**: No history, cookies, cache
- **Cookie Management**: Accept/reject/block per-site
- **Tracking Prevention**: Block known tracking domains
- **DNSoH (DNS over HTTPS)**: Encrypted DNS queries
- **Clear Cache**: One-tap cache clearing
- **Clear History**: Batch history deletion
- **Certificate Pinning**: Enhanced security for critical sites

### Security
- **SSL/TLS Verification**: Mandatory certificate validation
- **HTTPS Enforcement**: Warn on insecure connections
- **Mixed Content Blocking**: No HTTP in HTTPS pages
- **XSS Protection**: JavaScript sandbox isolation
- **CSP Support**: Content Security Policy headers
- **Popup Blocking**: No unwanted popups
- **Phishing Detection**: Warning on suspicious sites
- **Password Manager**: Secure credential storage (optional)

### Network Detection (CRITICAL)

**ABINSTEIN Browser includes intelligent network state detection**:

```cpp
network_state.cpp:
  1. Check radio enabled? → WiFi on/off
  2. Check interface associated? → Connected to AP?
  3. Check has valid IP? → DHCP assigned?
  4. Check default route? → Can reach gateway?
  5. Check DNS resolvers? → DNS working?
  6. Check internet connectivity? → Can reach actual servers?
```

**Shows accurate errors**:
- "No Wi-Fi" - Radio off or no nearby networks
- "Connecting..." - Associated but waiting for IP
- "Connected, no IP" - Associated but DHCP failed
- "Connected, no Internet" - IP valid but no routes
- "DNS error" - DNS servers unreachable
- "Server unreachable" - Can resolve but can't reach
- "Internet available" - Full connectivity

### Downloads
- **Download Manager**: Track active downloads
- **Pause/Resume**: Interrupt and resume transfers
- **Background Downloads**: Continue while browsing
- **Storage Integration**: Save to device storage
- **Download History**: List of all downloads
- **Auto-retry**: Recover from interrupted downloads

### Settings
- **Search Engine**: Google, DuckDuckGo, etc.
- **Homepage**: Customizable start page
- **Font Size**: Adjust text size
- **Zoom Level**: Page zoom preferences
- **JavaScript**: Enable/disable per-site
- **Plugins**: Plugin management
- **Notifications**: Permission prompts
- **Data Saver**: Reduce data usage mode

## Implementation Status

### Phase 1 (Foundation)
- [x] Project structure
- [x] WPE WebKit integration plan
- [ ] Basic window management
- [ ] URL bar implementation
- [ ] Simple page loading
- [ ] Back/forward buttons

### Phase 2 (Core Features)
- [ ] Tab management system
- [ ] History database
- [ ] Bookmark system
- [ ] Cookie handling
- [ ] Cache management
- [ ] Form submission

### Phase 3 (Advanced)
- [ ] Private browsing mode
- [ ] Download manager
- [ ] Extension system (optional)
- [ ] Sync (optional)
- [ ] Reader mode

### Phase 4 (Optimization)
- [ ] Performance tuning
- [ ] Memory optimization
- [ ] Battery optimization
- [ ] Hardware acceleration

## Development Building

### Dependencies

```bash
sudo apt-get install -y \
  qt6-base-dev qt6-declarative-dev \
  libwpe-1.0-dev libwpebackend-fdo-1.0-dev \
  libssl-dev libcurl4-openssl-dev \
  libsqlite3-dev
```

### Build

```bash
mkdir build
cd build
cmake ..
make -j$(nproc)
```

### Run

```bash
./abinstein-browser
```

## File Structure

```
apps/browser/
├── CMakeLists.txt          # Build configuration
├── src/
│   ├── main.cpp            # Application entry point
│   ├── browser_window.cpp  # Main window implementation
│   ├── browser_engine.cpp  # WPE WebKit integration
│   ├── tab_manager.cpp     # Tab system
│   ├── url_bar.cpp         # URL input bar
│   ├── history_manager.cpp # History database
│   ├── bookmark_manager.cpp# Bookmarks system
│   ├── download_manager.cpp# Download handling
│   ├── privacy_mode.cpp    # Private browsing
│   └── network_state_observer.cpp  # Network detection
├── include/
│   ├── browser_window.h
│   ├── browser_engine.h
│   ├── tab_manager.h
│   ├── history_manager.h
│   └── ...
├── qml/
│   ├── main.qml            # Root UI
│   ├── BrowserWindow.qml   # Main window UI
│   ├── URLBar.qml          # URL input UI
│   ├── TabBar.qml          # Tab switcher UI
│   ├── Menu.qml            # Hamburger menu
│   ├── Settings.qml        # Settings UI
│   └── ...
└── docs/
    └── BROWSER.md          # This file
```

## Key Classes

### BrowserWindow

```cpp
class BrowserWindow : public QMainWindow {
    // Navigation
    void navigateToUrl(const QString &url);
    void goBack();
    void goForward();
    void reload();
    
    // Tabs
    void newTab(const QString &url = "");
    void closeTab(int index);
    void switchToTab(int index);
    
    // Privacy
    void setPrivateBrowsingMode(bool enabled);
    
    // Network
    void onNetworkStateChanged(const QString &state);
};
```

### BrowserEngine

```cpp
class BrowserEngine {
    // WPE WebKit integration
    bool initialize();
    
    // Navigation
    void loadUrl(const QUrl &url);
    void executeScript(const QString &script);
    
    // Content
    QString getTitle() const;
    QString getUrl() const;
    double getLoadProgress() const;
};
```

### NetworkStateObserver

```cpp
class NetworkStateObserver : public QObject {
    enum NetworkState {
        Unknown,
        Disabled,
        Disconnected,
        Connecting,
        ConnectedNoIP,
        ConnectedNoInternet,
        Internet
    };
    
    NetworkState currentState() const;
    bool hasInternetConnectivity() const;
    void checkInternetConnectivity();
};
```

## Configuration Files

### ~/.config/abinstein-browser/settings.conf

```ini
[General]
search_engine=https://www.google.com/search?q=%s
homepage=about:home
font_size=12
zoom_level=100

[Privacy]
private_mode=false
clear_cache_on_exit=true
block_third_party_cookies=true
track_prevention=true

[Network]
proxy_enabled=false
dns_over_https=true

[Security]
ssl_warnings=true
mixed_content_block=true
```

### ~/.config/abinstein-browser/bookmarks.json

```json
{
  "bookmarks": [
    {
      "title": "ABINSTEIN OS",
      "url": "https://abinstein.org",
      "category": "Projects",
      "date_added": "2026-09-05T07:00:00Z"
    }
  ]
}
```

## Performance Optimization

### Memory Management
- Background tabs: Suspended to reduce memory
- Disk cache: Limited size (50-100 MB)
- Memory cache: Adaptive based on RAM available
- JavaScript heap: Garbage collection optimized

### CPU Usage
- Hardware acceleration: GPU rendering when available
- V-Sync: Synchronized with display refresh (60 Hz)
- Event batching: Reduce event processing overhead

### Battery
- Aggressive idle: Reduce CPU when inactive
- Partial rendering: Skip off-screen content
- Network optimization: Combine requests

## Testing

### Unit Tests
```bash
make test
```

### Manual Testing
1. Boot ABINSTEIN in QEMU
2. Launch browser: `abinstein-browser`
3. Navigate to: `https://example.com`
4. Test features:
   - Back/forward
   - Tab switching
   - Network detection
   - Private mode
   - Downloads

## Troubleshooting

### Browser won't launch
```bash
# Check dependencies
pkg-config --list-all | grep -i wpe

# Check Qt6
qt6-cmake --version

# Verbose output
QT_DEBUG_PLUGINS=1 ./abinstein-browser
```

### Blank page after navigation
- Check network connectivity
- Check DNS resolution: `nslookup example.com`
- Check browser console for JavaScript errors

### Slow page loading
- Close background tabs
- Clear cache: Settings → Privacy → Clear Cache
- Check network speed: `speedtest.net`

## Security Considerations

1. **Never store passwords in plain text** - Use secure storage
2. **Validate all user input** - Prevent injection attacks
3. **Verify SSL certificates** - No self-signed exceptions
4. **Isolate execution contexts** - One JS context per tab
5. **Sandboxed plugins** - No direct hardware access
6. **Regular updates** - Keep WPE WebKit current

## Future Enhancements

- [ ] Web app installation (PWA)
- [ ] Sync across devices
- [ ] Reader mode (simplified text view)
- [ ] Screenshot tool
- [ ] Tab grouping
- [ ] Voice search
- [ ] Gesture support
- [ ] Built-in VPN
- [ ] Dark mode

## Links

- WPE WebKit: https://wpewebkit.org/
- Qt 6: https://doc.qt.io/qt-6/
- WebKit: https://webkit.org/
- MDN Web Docs: https://developer.mozilla.org/
