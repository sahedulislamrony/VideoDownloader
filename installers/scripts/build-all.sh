#!/bin/bash

# VideoDownloaderApp Universal Build Script
# Builds installers for all supported platforms

set -e

VERSION=${1:-"1.0.0"}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DIST_DIR="$PROJECT_ROOT/dist"

echo "=========================================="
echo "VideoDownloaderApp Universal Build Script"
echo "Version: $VERSION"
echo "=========================================="

# Clean output directory
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Detect current platform
CURRENT_OS=""
case "$(uname -s)" in
    Linux*)     CURRENT_OS="Linux";;
    Darwin*)    CURRENT_OS="Mac";;
    CYGWIN*|MINGW*|MSYS*) CURRENT_OS="Windows";;
    *)          CURRENT_OS="Unknown";;
esac

echo "Current platform: $CURRENT_OS"
echo ""

# Build function for each platform
build_windows() {
    echo "Building Windows installers..."
    if [ "$CURRENT_OS" = "Windows" ] || command -v wine &> /dev/null; then
        cd "$PROJECT_ROOT/installers/scripts"
        if [ "$CURRENT_OS" = "Windows" ]; then
            powershell -ExecutionPolicy Bypass -File build-windows.ps1 -Version "$VERSION"
        else
            echo "Cross-compilation for Windows not fully supported on this platform"
            echo "Please run on Windows or use GitHub Actions for Windows builds"
        fi
    else
        echo "Skipping Windows build (not on Windows and Wine not available)"
    fi
    echo ""
}

build_linux() {
    echo "Building Linux packages..."
    if [ "$CURRENT_OS" = "Linux" ]; then
        # Build DEB package
        echo "Building DEB package..."
        cd "$PROJECT_ROOT/installers/linux"
        chmod +x build-deb.sh
        ./build-deb.sh "$VERSION"
        
        # Build RPM package (if rpmbuild is available)
        if command -v rpmbuild &> /dev/null; then
            echo "Building RPM package..."
            chmod +x build-rpm.sh
            ./build-rpm.sh "$VERSION"
        else
            echo "rpmbuild not found, skipping RPM build"
        fi
        
        # Build AppImage
        echo "Building AppImage..."
        chmod +x build-appimage.sh
        ./build-appimage.sh "$VERSION"
    else
        echo "Skipping Linux build (not on Linux)"
    fi
    echo ""
}

build_macos() {
    echo "Building macOS packages..."
    if [ "$CURRENT_OS" = "Mac" ]; then
        cd "$PROJECT_ROOT/installers/macos"
        chmod +x build-pkg.sh
        
        # Build for Intel Macs
        ./build-pkg.sh "$VERSION" "x64"
        
        # Build for Apple Silicon Macs
        ./build-pkg.sh "$VERSION" "arm64"
    else
        echo "Skipping macOS build (not on macOS)"
    fi
    echo ""
}

# Build for current platform or all platforms
case "${2:-all}" in
    "windows")
        build_windows
        ;;
    "linux")
        build_linux
        ;;
    "macos")
        build_macos
        ;;
    "all")
        build_windows
        build_linux
        build_macos
        ;;
    *)
        echo "Usage: $0 <version> [windows|linux|macos|all]"
        exit 1
        ;;
esac

# Summary
echo "=========================================="
echo "Build Summary"
echo "=========================================="
echo "Output directory: $DIST_DIR"
echo ""
echo "Generated files:"
if [ -d "$DIST_DIR" ]; then
    find "$DIST_DIR" -type f -exec basename {} \; | sort
else
    echo "No files generated"
fi
echo ""
echo "Build completed!"
