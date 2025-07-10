#!/bin/bash

# VideoDownloaderApp DEB Package Build Script

set -e

VERSION=${1:-"1.0.0"}
ARCH=${2:-"amd64"}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build/deb"
PACKAGE_NAME="videodownloaderapp"

echo "Building DEB package for VideoDownloaderApp v$VERSION ($ARCH)..."

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Create package directory structure
PACKAGE_DIR="$BUILD_DIR/${PACKAGE_NAME}_${VERSION}_${ARCH}"
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/bin"
mkdir -p "$PACKAGE_DIR/usr/share/applications"
mkdir -p "$PACKAGE_DIR/usr/share/pixmaps"
mkdir -p "$PACKAGE_DIR/usr/share/doc/$PACKAGE_NAME"
mkdir -p "$PACKAGE_DIR/opt/$PACKAGE_NAME"

# Publish the application
echo "Publishing application..."
cd "$PROJECT_ROOT"
dotnet publish -c Release -r linux-x64 --self-contained -o "$PACKAGE_DIR/opt/$PACKAGE_NAME"

# Create control file
cat > "$PACKAGE_DIR/DEBIAN/control" << EOF
Package: $PACKAGE_NAME
Version: $VERSION
Section: multimedia
Priority: optional
Architecture: $ARCH
Depends: python3, python3-pip, ffmpeg
Maintainer: VideoDownloaderApp Team <team@videodownloaderapp.com>
Description: Cross-platform video downloader application
 VideoDownloaderApp is a modern desktop application for downloading videos
 and audio from popular platforms like YouTube, TikTok, Instagram, and more.
 Built with .NET and Avalonia UI for cross-platform compatibility.
Homepage: https://github.com/videodownloaderapp
EOF

# Create postinst script for dependency installation
cat > "$PACKAGE_DIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

echo "Installing VideoDownloaderApp dependencies..."

# Install yt-dlp via pip if not already installed
if ! command -v yt-dlp &> /dev/null; then
    echo "Installing yt-dlp..."
    pip3 install --break-system-packages yt-dlp || pip3 install yt-dlp
fi

# Verify ffmpeg installation
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg not found. Please install it manually:"
    echo "  Ubuntu/Debian: sudo apt install ffmpeg"
    echo "  Fedora: sudo dnf install ffmpeg"
    echo "  Arch: sudo pacman -S ffmpeg"
fi

# Create symlink for easy access
ln -sf /opt/videodownloaderapp/VideoDownloaderApp /usr/bin/videodownloaderapp

# Set executable permissions
chmod +x /opt/videodownloaderapp/VideoDownloaderApp

echo "VideoDownloaderApp installation completed!"
echo "You can now run it with: videodownloaderapp"
EOF

# Create prerm script for cleanup
cat > "$PACKAGE_DIR/DEBIAN/prerm" << 'EOF'
#!/bin/bash
set -e

# Remove symlink
rm -f /usr/bin/videodownloaderapp
EOF

# Make scripts executable
chmod 755 "$PACKAGE_DIR/DEBIAN/postinst"
chmod 755 "$PACKAGE_DIR/DEBIAN/prerm"

# Create desktop entry
cat > "$PACKAGE_DIR/usr/share/applications/$PACKAGE_NAME.desktop" << EOF
[Desktop Entry]
Name=VideoDownloaderApp
Comment=Cross-platform video downloader
Exec=/usr/bin/videodownloaderapp
Icon=videodownloaderapp
Terminal=false
Type=Application
Categories=AudioVideo;Network;
Keywords=video;download;youtube;tiktok;
EOF

# Copy icon (assuming you have one)
if [ -f "$PROJECT_ROOT/Resources/logo.png" ]; then
    cp "$PROJECT_ROOT/Resources/logo.png" "$PACKAGE_DIR/usr/share/pixmaps/videodownloaderapp.png"
fi

# Create copyright file
cat > "$PACKAGE_DIR/usr/share/doc/$PACKAGE_NAME/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: VideoDownloaderApp
Upstream-Contact: VideoDownloaderApp Team <team@videodownloaderapp.com>
Source: https://github.com/videodownloaderapp

Files: *
Copyright: $(date +%Y) VideoDownloaderApp Team
License: MIT
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 .
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
EOF

# Create changelog
cat > "$PACKAGE_DIR/usr/share/doc/$PACKAGE_NAME/changelog.Debian" << EOF
$PACKAGE_NAME ($VERSION) unstable; urgency=medium

  * Initial release
  * Cross-platform video downloader
  * Support for 1000+ websites via yt-dlp
  * Modern Avalonia UI interface

 -- VideoDownloaderApp Team <team@videodownloaderapp.com>  $(date -R)
EOF

# Compress changelog
gzip -9 "$PACKAGE_DIR/usr/share/doc/$PACKAGE_NAME/changelog.Debian"

# Build the package
echo "Building DEB package..."
dpkg-deb --build "$PACKAGE_DIR"

# Move to output directory
OUTPUT_DIR="$PROJECT_ROOT/dist"
mkdir -p "$OUTPUT_DIR"
mv "${PACKAGE_DIR}.deb" "$OUTPUT_DIR/"

echo "DEB package created: $OUTPUT_DIR/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

# Verify package
echo "Package information:"
dpkg-deb -I "$OUTPUT_DIR/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
