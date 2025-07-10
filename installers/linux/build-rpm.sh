#!/bin/bash

# VideoDownloaderApp RPM Package Build Script

set -e

VERSION=${1:-"1.0.0"}
ARCH=${2:-"x86_64"}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build/rpm"
PACKAGE_NAME="videodownloaderapp"

echo "Building RPM package for VideoDownloaderApp v$VERSION ($ARCH)..."

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Create RPM spec file
cat > "$BUILD_DIR/SPECS/$PACKAGE_NAME.spec" << EOF
Name:           $PACKAGE_NAME
Version:        $VERSION
Release:        1%{?dist}
Summary:        Cross-platform video downloader application
License:        MIT
URL:            https://github.com/videodownloaderapp
Source0:        %{name}-%{version}.tar.gz
BuildArch:      $ARCH

Requires:       python3, python3-pip, ffmpeg

%description
VideoDownloaderApp is a modern desktop application for downloading videos
and audio from popular platforms like YouTube, TikTok, Instagram, and more.
Built with .NET and Avalonia UI for cross-platform compatibility.

%prep
%setup -q

%build
# No build needed for pre-compiled application

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/opt/%{name}
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/pixmaps

# Copy application files
cp -r * %{buildroot}/opt/%{name}/

# Create wrapper script
cat > %{buildroot}/usr/bin/%{name} << 'WRAPPER_EOF'
#!/bin/bash
exec /opt/videodownloaderapp/VideoDownloaderApp "\$@"
WRAPPER_EOF

chmod +x %{buildroot}/usr/bin/%{name}

# Create desktop entry
cat > %{buildroot}/usr/share/applications/%{name}.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Name=VideoDownloaderApp
Comment=Cross-platform video downloader
Exec=/usr/bin/videodownloaderapp
Icon=videodownloaderapp
Terminal=false
Type=Application
Categories=AudioVideo;Network;
Keywords=video;download;youtube;tiktok;
DESKTOP_EOF

# Copy icon if available
if [ -f Resources/logo.png ]; then
    cp Resources/logo.png %{buildroot}/usr/share/pixmaps/%{name}.png
fi

%post
echo "Installing VideoDownloaderApp dependencies..."

# Install yt-dlp via pip if not already installed
if ! command -v yt-dlp &> /dev/null; then
    echo "Installing yt-dlp..."
    pip3 install --break-system-packages yt-dlp 2>/dev/null || pip3 install yt-dlp
fi

# Verify ffmpeg installation
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg not found. Please install it manually:"
    echo "  Fedora/RHEL: sudo dnf install ffmpeg"
    echo "  CentOS: sudo yum install epel-release && sudo yum install ffmpeg"
fi

echo "VideoDownloaderApp installation completed!"
echo "You can now run it with: videodownloaderapp"

%preun
# Cleanup on uninstall

%files
%defattr(-,root,root,-)
/opt/%{name}/*
/usr/bin/%{name}
/usr/share/applications/%{name}.desktop
/usr/share/pixmaps/%{name}.png

%changelog
* $(date "+%a %b %d %Y") VideoDownloaderApp Team <team@videodownloaderapp.com> - $VERSION-1
- Initial RPM release
- Cross-platform video downloader
- Support for 1000+ websites via yt-dlp
- Modern Avalonia UI interface
EOF

# Publish the application
echo "Publishing application..."
cd "$PROJECT_ROOT"
PUBLISH_DIR="$BUILD_DIR/SOURCES/$PACKAGE_NAME-$VERSION"
dotnet publish -c Release -r linux-x64 --self-contained -o "$PUBLISH_DIR"

# Create source tarball
cd "$BUILD_DIR/SOURCES"
tar -czf "$PACKAGE_NAME-$VERSION.tar.gz" "$PACKAGE_NAME-$VERSION"

# Build RPM
echo "Building RPM package..."
rpmbuild --define "_topdir $BUILD_DIR" -ba "$BUILD_DIR/SPECS/$PACKAGE_NAME.spec"

# Move to output directory
OUTPUT_DIR="$PROJECT_ROOT/dist"
mkdir -p "$OUTPUT_DIR"
cp "$BUILD_DIR/RPMS/$ARCH/$PACKAGE_NAME-$VERSION-1."*".rpm" "$OUTPUT_DIR/"

echo "RPM package created: $OUTPUT_DIR/$PACKAGE_NAME-$VERSION-1.*.rpm"

# Verify package
echo "Package information:"
rpm -qip "$OUTPUT_DIR/$PACKAGE_NAME-$VERSION-1."*".rpm"
