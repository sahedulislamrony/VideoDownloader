#!/bin/bash

# VideoDownloaderApp macOS Package Build Script

set -e

VERSION=${1:-"1.0.0"}
ARCH=${2:-"x64"}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build/macos"
PACKAGE_NAME="VideoDownloaderApp"

echo "Building macOS package for VideoDownloaderApp v$VERSION ($ARCH)..."

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Determine runtime identifier
if [ "$ARCH" = "arm64" ]; then
    RID="osx-arm64"
else
    RID="osx-x64"
fi

# Publish the application
echo "Publishing application for $RID..."
cd "$PROJECT_ROOT"
PUBLISH_DIR="$BUILD_DIR/publish"
dotnet publish -c Release -r "$RID" --self-contained -o "$PUBLISH_DIR"

# Create app bundle structure
APP_DIR="$BUILD_DIR/$PACKAGE_NAME.app"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copy application files
cp -r "$PUBLISH_DIR"/* "$APP_DIR/Contents/MacOS/"

# Create Info.plist
cat > "$APP_DIR/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>VideoDownloaderApp</string>
    <key>CFBundleIdentifier</key>
    <string>com.videodownloaderapp.VideoDownloaderApp</string>
    <key>CFBundleName</key>
    <string>VideoDownloaderApp</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © $(date +%Y) VideoDownloaderApp Team</string>
</dict>
</plist>
EOF

# Copy icon if available
if [ -f "$PROJECT_ROOT/Resources/logo.png" ]; then
    # Convert PNG to ICNS (requires iconutil)
    ICONSET_DIR="$BUILD_DIR/icon.iconset"
    mkdir -p "$ICONSET_DIR"
    
    # Create different sizes (simplified - you might want to use proper icon sizes)
    cp "$PROJECT_ROOT/Resources/logo.png" "$ICONSET_DIR/icon_512x512.png"
    
    iconutil -c icns "$ICONSET_DIR" -o "$APP_DIR/Contents/Resources/icon.icns"
    rm -rf "$ICONSET_DIR"
fi

# Make executable
chmod +x "$APP_DIR/Contents/MacOS/VideoDownloaderApp"

# Create dependency installer script
cat > "$BUILD_DIR/install-dependencies.sh" << 'EOF'
#!/bin/bash

echo "Installing VideoDownloaderApp dependencies..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install yt-dlp
if ! command -v yt-dlp &> /dev/null; then
    echo "Installing yt-dlp..."
    brew install yt-dlp
fi

# Install ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "Installing ffmpeg..."
    brew install ffmpeg
fi

echo "Dependencies installation completed!"
EOF

chmod +x "$BUILD_DIR/install-dependencies.sh"

# Create postinstall script for PKG
mkdir -p "$BUILD_DIR/scripts"
cat > "$BUILD_DIR/scripts/postinstall" << 'EOF'
#!/bin/bash

# Run dependency installer
/Applications/VideoDownloaderApp.app/Contents/Resources/install-dependencies.sh

# Create symlink for command line access
ln -sf "/Applications/VideoDownloaderApp.app/Contents/MacOS/VideoDownloaderApp" "/usr/local/bin/videodownloaderapp"

exit 0
EOF

chmod +x "$BUILD_DIR/scripts/postinstall"

# Copy dependency installer to app bundle
cp "$BUILD_DIR/install-dependencies.sh" "$APP_DIR/Contents/Resources/"

# Create PKG installer
echo "Creating PKG installer..."
pkgbuild --root "$BUILD_DIR" \
         --identifier "com.videodownloaderapp.VideoDownloaderApp" \
         --version "$VERSION" \
         --install-location "/Applications" \
         --scripts "$BUILD_DIR/scripts" \
         "$BUILD_DIR/$PACKAGE_NAME-$VERSION.pkg"

# Create DMG
echo "Creating DMG..."
if command -v create-dmg &> /dev/null; then
    create-dmg \
        --volname "VideoDownloaderApp $VERSION" \
        --volicon "$APP_DIR/Contents/Resources/icon.icns" \
        --window-pos 200 120 \
        --window-size 800 400 \
        --icon-size 100 \
        --icon "$PACKAGE_NAME.app" 200 190 \
        --hide-extension "$PACKAGE_NAME.app" \
        --app-drop-link 600 185 \
        "$BUILD_DIR/$PACKAGE_NAME-$VERSION.dmg" \
        "$BUILD_DIR/"
else
    # Fallback: create simple DMG
    hdiutil create -volname "VideoDownloaderApp $VERSION" \
                   -srcfolder "$APP_DIR" \
                   -ov -format UDZO \
                   "$BUILD_DIR/$PACKAGE_NAME-$VERSION.dmg"
fi

# Move to output directory
OUTPUT_DIR="$PROJECT_ROOT/dist"
mkdir -p "$OUTPUT_DIR"
cp "$BUILD_DIR/$PACKAGE_NAME-$VERSION.pkg" "$OUTPUT_DIR/"
cp "$BUILD_DIR/$PACKAGE_NAME-$VERSION.dmg" "$OUTPUT_DIR/"

echo "macOS packages created:"
echo "  PKG: $OUTPUT_DIR/$PACKAGE_NAME-$VERSION.pkg"
echo "  DMG: $OUTPUT_DIR/$PACKAGE_NAME-$VERSION.dmg"
