# VideoDownloaderApp - Ubuntu Setup Guide

## 🚀 Quick Start for Ubuntu

Since you have .NET already installed, here's how to get started:

### 1. Build and Run the Application
```bash
# Navigate to project directory
cd VideoDownloaderApp

# Restore dependencies
dotnet restore

# Build the application
dotnet build

# Run the application
dotnet run
```

### 2. Build Linux Installers
```bash
# Make scripts executable (already done)
chmod +x installers/linux/*.sh

# Build DEB package
./installers/linux/build-deb.sh 1.0.0

# Build AppImage (portable)
./installers/linux/build-appimage.sh 1.0.0

# Build all Linux packages
./installers/scripts/build-all.sh 1.0.0 linux
```

### 3. Install Dependencies (if needed)
```bash
# Install yt-dlp
pip3 install yt-dlp

# Install ffmpeg
sudo apt install ffmpeg

# Install additional build tools (for packaging)
sudo apt install dpkg-dev rpm build-essential
```

### 4. Project Structure
```
VideoDownloaderApp/
├── 📁 Models/              # Data models
├── 📁 ViewModels/          # MVVM view models  
├── 📁 Views/               # UI views (AXAML)
├── 📁 Services/            # Business logic
├── 📁 Resources/           # Images, assets
├── 📁 docs/                # Complete documentation
├── 📁 installers/          # All installer scripts
│   ├── 📁 linux/           # Linux packages (.deb, .rpm, .AppImage)
│   ├── 📁 windows/         # Windows installers (.msi, .exe)
│   ├── 📁 macos/           # macOS packages (.pkg, .dmg)
│   └── 📁 scripts/         # Build automation
├── 📁 .github/workflows/   # CI/CD automation
├── 📄 VideoDownloaderApp.csproj
├── 📄 Program.cs
└── 📄 README.md
```

### 5. Development Commands
```bash
# Run in development mode
dotnet run

# Build for release
dotnet build -c Release

# Publish for Linux
dotnet publish -c Release -r linux-x64 --self-contained

# Run tests (when added)
dotnet test
```

### 6. Installer Outputs
After building, installers will be in the `dist/` directory:
- `videodownloaderapp_1.0.0_amd64.deb` - Debian package
- `VideoDownloaderApp-1.0.0-x86_64.AppImage` - Portable AppImage
- `videodownloaderapp-1.0.0-1.x86_64.rpm` - RPM package (if rpmbuild available)

## 📚 Documentation
- **[README.md](README.md)** - Main project overview
- **[docs/User_Guide.md](docs/User_Guide.md)** - User installation guide
- **[docs/Developer_Guide.md](docs/Developer_Guide.md)** - Development setup
- **[installers/README.md](installers/README.md)** - Installer creation guide

## 🔧 Troubleshooting
- Ensure .NET 8.0 SDK is installed: `dotnet --version`
- Install missing dependencies as shown above
- Check build logs for specific errors
- See documentation for detailed troubleshooting

Ready to build! 🎉
