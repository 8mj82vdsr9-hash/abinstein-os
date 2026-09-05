# ABINSTEIN App Store

## Overview

The ABINSTEIN App Store is an independent app distribution platform.

**PURPOSE**: Provide Google Play-like functionality WITHOUT Google services

## Key Differences from Google Play

| Feature | Google Play | ABINSTEIN Store |
|---------|-------------|------------------|
| Owner | Google | Community/User |
| Dependency | Google Account | Optional Account |
| Tracking | Yes (Google) | No (privacy-focused) |
| Open Source | No | Yes |
| App Format | APK | AAPK (Abinstein App Package) |
| Updates | Automatic | User-controlled |
| Payment | Google Play Billing | Future: Direct payment |

## App Store Features

### Browsing
- App grid view with screenshots
- Search by name/keyword/category
- Category browsing
- Featured apps section
- Popular apps (by downloads)
- New releases
- Updates available

### App Details
- Full app description
- Screenshots (multiple)
- Version history
- Change log
- Permissions declared
- User reviews & ratings
- Download count
- File size
- Last updated date

### Installation & Management
- One-tap install
- One-tap uninstall
- Update management
- Installation progress indicator
- Pause/resume downloads
- Installation error handling
- Automatic signature verification
- Rollback capability

### User Ratings & Reviews
- 1-5 star rating system
- Text reviews with screenshots
- Helpful votes (like/dislike)
- Official developer responses
- Spam/abuse reporting
- Verified purchase badges

### Account System
- Optional user accounts
- Wishlist/favorites
- Download history
- Installed apps list
- Update preferences
- Privacy settings

### Security
- **App Signing**: All apps must be signed with valid certificates
- **Verification**: Signature verified before installation
- **Revocation**: Ability to revoke compromised app certificates
- **Permissions**: Declared permissions shown to user
- **Sandboxing**: Apps run in isolated D-Bus namespaces
- **Update Verification**: Updates checked for integrity

## App Package Format (AAPK)

```
app-name-1.0.0.aapk
├── META-INF/
│   ├── MANIFEST.json (app metadata)
│   └── CERT.pk7 (signature)
├── bin/
│   └── app-executable
├── lib/
│   ├── libfoo.so
│   └── libbar.so
├── share/
│   ├── icons/
│   ├── config/
│   └── data/
├── data/
│   └── permissions.json
└── [compressed with signature]
```

## Metadata Format

```json
{
  "name": "Abinstein Browser",
  "package": "com.abinstein.browser",
  "version": "1.0.0",
  "version_code": 1,
  "description": "Privacy-focused web browser",
  "author": "Abinstein Team",
  "author_url": "https://abinstein.org",
  "icon": "share/icons/app.png",
  "screenshots": ["share/screenshots/1.png"],
  "category": "Productivity",
  "license": "GPL-3.0",
  "permissions": [
    "internet",
    "storage-read",
    "storage-write",
    "network-state"
  ],
  "min_version": "0.1.0",
  "target_version": "1.0.0",
  "size_bytes": 5242880,
  "download_count": 1234,
  "rating": 4.5,
  "last_updated": "2026-09-05"
}
```

## Permissions System

### Available Permissions
```
Internet Access
  - network (send/receive data)
  - audio-call (make calls if modem present)
  - sms (send SMS if modem present)

Storage
  - storage-read (read files in app directory)
  - storage-write (write files in app directory)
  - storage-public (read/write public storage)
  - camera (access camera)
  - microphone (access microphone)

System
  - location (GPS/location services)
  - contacts (address book access)
  - calendar (calendar access)
  - settings-read (read system settings)
  - settings-write (write system settings)
  - power-management (control display, etc)
  - bluetooth (Bluetooth operations)
  - nfc (NFC operations)

Security
  - clipboard-read
  - clipboard-write
```

### Permission Request Flow
1. App declares permissions in manifest
2. User sees permissions before installation
3. At runtime, app requests permission
4. User grants/denies permission
5. App respects denial gracefully

## Repository Management

### Official Repository
- Curated apps
- Moderated for quality
- Verified developer signatures
- Regular security audits

### Community Repositories (Future)
- User-hosted repositories
- Experimental apps
- Private repositories

## Implementation Status

### Phase 1 (Current)
- [ ] App Store UI foundation
- [ ] App catalog browsing
- [ ] Search functionality
- [ ] App installation framework
- [ ] Signature verification
- [ ] Download management

### Phase 2
- [ ] User accounts
- [ ] Rating & review system
- [ ] Download history
- [ ] Update management
- [ ] Settings UI

### Phase 3
- [ ] Developer portal
- [ ] App submission system
- [ ] Revenue sharing (optional)
- [ ] Analytics
- [ ] Community features

## Running App Store

```bash
./abinstein-appstore
```

## Configuration

~/.config/abinstein-appstore/
- settings.conf
- repositories.json
- installed-apps.db
- app-cache/

## Security Considerations

1. **Never auto-install** without user confirmation
2. **Always verify signatures** before installation
3. **Sandbox apps** properly
4. **Check permissions** before granting
5. **Warn about** beta/experimental apps
6. **Maintain audit log** of all installations
7. **Provide rollback** if needed

## API for App Developers

Apps can query app store:

```cpp
// Check if app is available
bool isAppAvailable(const QString &package_name);

// Open app store to app page
void openAppPage(const QString &package_name);

// Check for updates
bool hasUpdate(const QString &package_name);

// Get app info
QJsonObject getAppInfo(const QString &package_name);
```

## Future Enhancements

- In-app purchases
- Subscription management
- Parental controls
- App backup & restore
- Beta testing programs
- Crash reporting integration
- Analytics dashboard for developers
