# VideoDownloaderApp Installers

This directory contains all the necessary scripts and configurations to build installer packages for VideoDownloaderApp across Windows, Linux, and macOS platforms with automatic dependency installation.

## 📁 Directory Structure

```
installers/
├── README.md                          # This file
├── windows/                           # Windows installer files
│   ├── VideoDownloaderApp.wxs         # WiX MSI configuration
│   ├── DependencyInstaller.cs         # Dependency installer helper
│   └── installer.nsi                  # NSIS installer script (generated)
├── linux/                            # Linux package files
│   ├── build-deb.sh                  # Debian package builder
│   ├── build-rpm.sh                  # RPM package builder
│   └── build-appimage.sh             # AppImage builder
├── macos/                            # macOS package files
│   └── build-pkg.sh                  # PKG/DMG builder
└── scripts/                          # Cross-platform scripts
    ├── build-all.sh                  # Universal build script
    └── build-windows.ps1             # Windows build script
```

## 🚀 Quick Start

### Build All Platforms
```bash
# From project root
./installers/scripts/build-all.sh 1.0.0 all
```

### Build Specific Platform
```bash
# Windows (run on Windows or with Wine)
./installers/scripts/build-all.sh 1.0.0 windows

# Linux (run on Linux)
./installers/scripts/build-all.sh 1.0.0 linux

# macOS (run on macOS)
./installers/scripts/build-all.sh 1.0.0 macos
```

## 🔧 Platform-Specific Instructions

### Windows Installers

#### Prerequisites
- Visual Studio 2022 or Build Tools
- .NET 8.0 SDK
- WiX Toolset v4 (for MSI)
- NSIS (for EXE)

#### Build Commands
```powershell
# Navigate to scripts directory
cd installers/scripts

# Build both MSI and EXE installers
powershell -ExecutionPolicy Bypass -File build-windows.ps1 -Version "1.0.0"
```

#### Output Files
- `VideoDownloaderApp-1.0.0.msi` - Windows Installer package
- `VideoDownloaderApp-1.0.0-Setup.exe` - NSIS executable installer

#### Features
- ✅ Automatic .NET 8.0 Runtime installation
- ✅ Automatic yt-dlp download and installation
- ✅ Automatic FFmpeg download and installation
- ✅ Start Menu and Desktop shortcuts
- ✅ Add to Windows PATH
- ✅ Uninstaller creation

### Linux Packages

#### Prerequisites
```bash
# Ubuntu/Debian
sudo apt-get install dpkg-dev rpm build-essential

# Fedora/CentOS
sudo dnf install rpm-build dpkg-dev

# For AppImage
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
sudo mv appimagetool-x86_64.AppImage /usr/local/bin/appimagetool
```

#### Build Commands
```bash
cd installers/linux

# Build DEB package
./build-deb.sh 1.0.0

# Build RPM package
./build-rpm.sh 1.0.0

# Build AppImage
./build-appimage.sh 1.0.0
```

#### Output Files
- `videodownloaderapp_1.0.0_amd64.deb` - Debian package
- `videodownloaderapp-1.0.0-1.x86_64.rpm` - RPM package
- `VideoDownloaderApp-1.0.0-x86_64.AppImage` - Portable AppImage

#### Features
- ✅ Automatic yt-dlp installation via pip3
- ✅ FFmpeg dependency declaration
- ✅ Desktop integration (.desktop file)
- ✅ Command-line symlink creation
- ✅ Proper package metadata

### macOS Packages

#### Prerequisites
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install create-dmg via Homebrew
brew install create-dmg

# Install Packages app for PKG creation
# Download from: http://s.sudre.free.fr/Software/Packages/about.html
```

#### Build Commands
```bash
cd installers/macos

# Build for Intel Macs
./build-pkg.sh 1.0.0 x64

# Build for Apple Silicon Macs
./build-pkg.sh 1.0.0 arm64
```

#### Output Files
- `VideoDownloaderApp-1.0.0-x64.pkg` - Intel Mac installer
- `VideoDownloaderApp-1.0.0-arm64.pkg` - Apple Silicon installer
- `VideoDownloaderApp-1.0.0-x64.dmg` - Intel Mac disk image
- `VideoDownloaderApp-1.0.0-arm64.dmg` - Apple Silicon disk image

#### Features
- ✅ Automatic Homebrew installation
- ✅ Automatic yt-dlp installation via Homebrew
- ✅ Automatic FFmpeg installation via Homebrew
- ✅ Proper app bundle creation
- ✅ Command-line symlink creation

## 🔄 Automated Building (CI/CD)

### GitHub Actions
The project includes automated building via GitHub Actions in `.github/workflows/build-installers.yml`.

**Triggers:**
- Push to tags matching `v*` (e.g., v1.0.0)
- Pull requests to main branch
- Manual workflow dispatch

**Platforms:**
- Windows (latest)
- Ubuntu (latest)
- macOS (latest) - both Intel and Apple Silicon

### Local Testing
Test installers locally before releasing:

```bash
# Test on virtual machines
# - Windows 10/11 (clean install)
# - Ubuntu 20.04/22.04 LTS
# - Fedora (latest)
# - macOS Monterey/Ventura/Sonoma

# Verify functionality
# 1. Clean installation
# 2. Dependency installation
# 3. Application launch
# 4. Basic functionality
# 5. Uninstallation
```

## 📦 Dependency Management

### Automatic Installation Strategy

Each installer automatically handles the following dependencies:

#### Core Dependencies
- **.NET 8.0 Runtime** (Windows only - Linux/macOS use self-contained)
- **yt-dlp** - Video download engine
- **FFmpeg** - Media processing (optional but recommended)

#### Installation Methods
- **Windows**: Direct download from official sources
- **Linux**: Package manager + pip3 for yt-dlp
- **macOS**: Homebrew for all dependencies

### Verification Process
All installers verify dependency installation:

```bash
# Check yt-dlp
yt-dlp --version

# Check FFmpeg
ffmpeg -version

# Check .NET (Windows)
dotnet --list-runtimes
```

## 🧪 Testing Guidelines

### Pre-Release Testing
Before releasing new installers:

1. **Clean Environment Testing**
   - Test on fresh virtual machines
   - Verify all dependencies install correctly
   - Test application functionality

2. **Upgrade Testing**
   - Test upgrading from previous versions
   - Verify settings and data preservation
   - Test downgrade scenarios

3. **Edge Case Testing**
   - Test with existing conflicting software
   - Test with limited user permissions
   - Test offline installation scenarios

### Test Checklist
- [ ] Installer downloads and runs without errors
- [ ] All dependencies are installed automatically
- [ ] Application launches successfully
- [ ] Basic download functionality works
- [ ] Desktop integration works (shortcuts, file associations)
- [ ] Uninstaller removes all components cleanly
- [ ] No leftover files or registry entries

## 🔒 Security Considerations

### Code Signing
- **Windows**: Use Authenticode certificate for signing
- **macOS**: Use Developer ID certificate and notarization
- **Linux**: GPG signing for repository distribution

### Checksum Generation
Generate checksums for all installers:

```bash
# Generate SHA256 checksums
cd dist/
sha256sum * > checksums.txt

# Verify checksums
sha256sum -c checksums.txt
```

### Dependency Security
- Download dependencies only from official sources
- Verify checksums when possible
- Use specific versions to avoid supply chain attacks

## 🐛 Troubleshooting

### Common Build Issues

#### Windows
```powershell
# WiX not found
# Solution: Install WiX Toolset v4 from https://wixtoolset.org/

# NSIS not found
# Solution: Install NSIS from https://nsis.sourceforge.io/

# PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Linux
```bash
# dpkg-deb not found
sudo apt-get install dpkg-dev

# rpmbuild not found
sudo dnf install rpm-build  # Fedora
sudo yum install rpm-build  # CentOS

# AppImageTool not found
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
sudo mv appimagetool-x86_64.AppImage /usr/local/bin/appimagetool
```

#### macOS
```bash
# create-dmg not found
brew install create-dmg

# Code signing issues
# Ensure you have a valid Developer ID certificate
security find-identity -v -p codesigning

# Notarization issues
# Check Apple Developer account status
```

### Installation Issues

#### Dependency Installation Failures
```bash
# Manual yt-dlp installation
pip3 install --user yt-dlp

# Manual FFmpeg installation
# Windows: Download from https://ffmpeg.org/
# Linux: sudo apt install ffmpeg (Ubuntu) or sudo dnf install ffmpeg (Fedora)
# macOS: brew install ffmpeg
```

#### Permission Issues
```bash
# Linux: Fix application permissions
sudo chown -R $USER:$USER /opt/videodownloaderapp
chmod +x /opt/videodownloaderapp/VideoDownloaderApp

# macOS: Fix Gatekeeper issues
xattr -rd com.apple.quarantine VideoDownloaderApp.app
```

## 📚 Additional Documentation

For more detailed information, see:

- **[docs/Installer_Guide.md](../docs/Installer_Guide.md)** - Comprehensive installer creation guide
- **[docs/Installation_Summary.md](../docs/Installation_Summary.md)** - Quick reference guide
- **[docs/User_Guide.md](../docs/User_Guide.md)** - End-user installation instructions
- **[docs/Developer_Guide.md](../docs/Developer_Guide.md)** - Development environment setup

## 🤝 Contributing

When contributing installer improvements:

1. **Test Thoroughly**: Test on multiple platforms and configurations
2. **Update Documentation**: Update relevant documentation files
3. **Follow Conventions**: Maintain consistent naming and structure
4. **Security First**: Ensure all changes maintain security standards

### Contribution Areas
- **New Package Formats**: Snap, Flatpak, Windows Store
- **Improved Automation**: Enhanced CI/CD workflows
- **Better Error Handling**: More robust error detection and recovery
- **Documentation**: Improved guides and troubleshooting

---

This installer system provides comprehensive, automated installation across all major platforms with automatic dependency management, ensuring users can easily install and run VideoDownloaderApp regardless of their technical expertise.
