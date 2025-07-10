#!/bin/bash

# VideoDownloaderApp AppImage Build Script

set -e

VERSION=${1:-"1.0.0"}
ARCH=${2:-"x86_64"}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build/appimage"
PACKAGE_NAME="VideoDownloaderApp"

echo "Building AppImage for VideoDownloaderApp v$VERSION ($ARCH)..."

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Download AppImageTool if not available
APPIMAGE_TOOL="$BUILD_DIR/appimagetool"
if [ ! -f "$APPIMAGE_TOOL" ]; then
    echo "Downloading AppImageTool..."
    wget -O "$APPIMAGE_TOOL" "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$ARCH.AppImage"
    chmod +x "$APPIMAGE_TOOL"
fi

# Create AppDir structure
APPDIR="$BUILD_DIR/$PACKAGE_NAME.AppDir"
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/lib"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/256x256/apps"

# Publish the application
echo "Publishing application..."
cd "$PROJECT_ROOT"
PUBLISH_DIR="$BUILD_DIR/publish"
dotnet publish -c Release -r linux-x64 --self-contained -o "$PUBLISH_DIR"

# Copy application files
cp -r "$PUBLISH_DIR"/* "$APPDIR/usr/bin/"

# Create AppRun script
cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/bash

# Get the directory where this script is located
HERE="$(dirname "$(readlink -f "${0}")")"

# Check and install dependencies if needed
install_dependencies() {
    echo "Checking dependencies..."
    
    # Check for yt-dlp
    if ! command -v yt-dlp &> /dev/null; then
        echo "Installing yt-dlp..."
        if command -v pip3 &> /dev/null; then
            pip3 install --user yt-dlp
        elif command -v pip &> /dev/null; then
            pip install --user yt-dlp
        else
            echo "Warning: pip not found. Please install yt-dlp manually."
        fi
    fi
    
    # Check for ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        echo "Warning: ffmpeg not found. Please install it for full functionality:"
        echo "  Ubuntu/Debian: sudo apt install ffmpeg"
        echo "  Fedora: sudo dnf install ffmpeg"
        echo "  Arch: sudo pacman -S ffmpeg"
    fi
}

# Install dependencies on first run
FIRST_RUN_FLAG="$HOME/.config/videodownloaderapp/first_run"
if [ ! -f "$FIRST_RUN_FLAG" ]; then
    mkdir -p "$(dirname "$FIRST_RUN_FLAG")"
    install_dependencies
    touch "$FIRST_RUN_FLAG"
fi

# Set up environment
export PATH="$HERE/usr/bin:$PATH"
export LD_LIBRARY_PATH="$HERE/usr/lib:$LD_LIBRARY_PATH"

# Run the application
exec "$HERE/usr/bin/VideoDownloaderApp" "$@"
EOF

chmod +x "$APPDIR/AppRun"

# Create desktop entry
cat > "$APPDIR/$PACKAGE_NAME.desktop" << EOF
[Desktop Entry]
Name=VideoDownloaderApp
Comment=Cross-platform video downloader
Exec=AppRun
Icon=videodownloaderapp
Type=Application
Categories=AudioVideo;Network;
Keywords=video;download;youtube;tiktok;
Terminal=false
EOF

# Copy desktop entry to standard location
cp "$APPDIR/$PACKAGE_NAME.desktop" "$APPDIR/usr/share/applications/"

# Copy and prepare icon
if [ -f "$PROJECT_ROOT/Resources/logo.png" ]; then
    cp "$PROJECT_ROOT/Resources/logo.png" "$APPDIR/videodownloaderapp.png"
    cp "$PROJECT_ROOT/Resources/logo.png" "$APPDIR/usr/share/icons/hicolor/256x256/apps/videodownloaderapp.png"
else
    # Create a simple placeholder icon
    echo "Creating placeholder icon..."
    convert -size 256x256 xc:blue -fill white -gravity center -pointsize 24 -annotate +0+0 "VDA" "$APPDIR/videodownloaderapp.png"
    cp "$APPDIR/videodownloaderapp.png" "$APPDIR/usr/share/icons/hicolor/256x256/apps/videodownloaderapp.png"
fi

# Create dependency installer script
cat > "$APPDIR/usr/bin/install-dependencies.sh" << 'EOF'
#!/bin/bash

echo "Installing VideoDownloaderApp dependencies..."

# Function to detect package manager and install packages
install_with_package_manager() {
    if command -v apt &> /dev/null; then
        echo "Detected APT package manager (Debian/Ubuntu)"
        sudo apt update
        sudo apt install -y python3-pip ffmpeg
    elif command -v dnf &> /dev/null; then
        echo "Detected DNF package manager (Fedora)"
        sudo dnf install -y python3-pip ffmpeg
    elif command -v yum &> /dev/null; then
        echo "Detected YUM package manager (CentOS/RHEL)"
        sudo yum install -y python3-pip ffmpeg
    elif command -v pacman &> /dev/null; then
        echo "Detected Pacman package manager (Arch Linux)"
        sudo pacman -S --noconfirm python-pip ffmpeg
    elif command -v zypper &> /dev/null; then
        echo "Detected Zypper package manager (openSUSE)"
        sudo zypper install -y python3-pip ffmpeg
    else
        echo "No supported package manager found. Please install python3-pip and ffmpeg manually."
        return 1
    fi
}

# Install system packages
install_with_package_manager

# Install yt-dlp via pip
if command -v pip3 &> /dev/null; then
    pip3 install --user yt-dlp
elif command -v pip &> /dev/null; then
    pip install --user yt-dlp
else
    echo "Error: pip not found after installation attempt."
    exit 1
fi

echo "Dependencies installation completed!"
EOF

chmod +x "$APPDIR/usr/bin/install-dependencies.sh"

# Build AppImage
echo "Building AppImage..."
cd "$BUILD_DIR"
ARCH=$ARCH "$APPIMAGE_TOOL" "$APPDIR" "$PACKAGE_NAME-$VERSION-$ARCH.AppImage"

# Move to output directory
OUTPUT_DIR="$PROJECT_ROOT/dist"
mkdir -p "$OUTPUT_DIR"
mv "$BUILD_DIR/$PACKAGE_NAME-$VERSION-$ARCH.AppImage" "$OUTPUT_DIR/"

echo "AppImage created: $OUTPUT_DIR/$PACKAGE_NAME-$VERSION-$ARCH.AppImage"

# Make it executable
chmod +x "$OUTPUT_DIR/$PACKAGE_NAME-$VERSION-$ARCH.AppImage"

echo "AppImage build completed!"
