#!/bin/bash

set -e

KEEP_TEMP=false
API_URL="https://cursor.com/api/download?platform=linux-x64&releaseTrack=stable"

print_usage() {
    echo "Usage: $0 [-k] [-h]"
    echo "  -k  Keep temporary files"
    echo "  -h  Show help"
}

while getopts "kh" opt; do
    case $opt in
        k) KEEP_TEMP=true ;;
        h) print_usage; exit 0 ;;
        *) print_usage; exit 1 ;;
    esac
done

check_dependencies() {
    for cmd in curl jq dpkg-deb; do
        command -v $cmd >/dev/null || { echo "Error: $cmd not found"; exit 1; }
    done
}

cleanup() {
    [ "$KEEP_TEMP" = true ] && echo "Temp files kept at: $TEMP_DIR" || rm -rf "$TEMP_DIR"
}

setup_directories() {
    TEMP_DIR="$(pwd)/cursor_temp_$(date +%s)"
    EXTRACT_DIR="$TEMP_DIR/extract"
    DEB_DIR="$TEMP_DIR/deb"
    mkdir -p "$EXTRACT_DIR" "$DEB_DIR"/{DEBIAN,usr/{bin,share/{applications,icons/hicolor/512x512/apps}},opt/cursor}
}

download_appimage() {
    echo "Fetching version info..."
    local response=$(curl -s "$API_URL")
    DOWNLOAD_URL=$(echo "$response" | jq -r '.downloadUrl')
    VERSION=$(echo "$response" | jq -r '.version')    
    APPIMAGE_PATH="$TEMP_DIR/cursor.AppImage"
    echo "Downloading Cursor v$VERSION..."
    curl -sL -o "$APPIMAGE_PATH" "$DOWNLOAD_URL"
    chmod +x "$APPIMAGE_PATH"
}

extract_appimage() {
    echo "Extracting AppImage..."
    cd "$EXTRACT_DIR"
    "$APPIMAGE_PATH" --appimage-extract >/dev/null
    [ ! -d "squashfs-root" ] && { echo "Extraction failed"; exit 1; }
    cd - >/dev/null
}

setup_package() {
    echo "Setting up package..."
    cp -r "$EXTRACT_DIR/squashfs-root/"* "$DEB_DIR/opt/cursor/"
    
    cat > "$DEB_DIR/usr/bin/cursor" << 'EOF'
#!/bin/bash
exec /opt/cursor/AppRun --no-sandbox "$@"
EOF
    chmod +x "$DEB_DIR/usr/bin/cursor"
    
    find_and_copy_icon
    create_desktop_file
    create_control_file
    create_scripts
}

find_and_copy_icon() {
    local icon_src icon_dest="$DEB_DIR/usr/share/icons/hicolor/512x512/apps/cursor.png"
    
    for icon in code.png co.anysphere.cursor.png; do
        if [ -f "$EXTRACT_DIR/squashfs-root/$icon" ]; then
            cp "$EXTRACT_DIR/squashfs-root/$icon" "$icon_dest"
            return
        fi
    done
    
    icon_src=$(find "$EXTRACT_DIR/squashfs-root" -name "*.png" -type f 2>/dev/null | head -1)
    [ -n "$icon_src" ] && cp "$icon_src" "$icon_dest"
}

create_desktop_file() {
    cat > "$DEB_DIR/usr/share/applications/cursor.desktop" << 'EOF'
[Desktop Entry]
Name=Cursor IDE
Comment=AI-first code editor
Exec=/usr/bin/cursor %U
Terminal=false
Type=Application
Icon=cursor
Categories=Development;IDE;
StartupWMClass=Cursor
EOF
}

create_control_file() {
    local size=$(du -sk "$DEB_DIR/opt/cursor" | cut -f1)
    cat > "$DEB_DIR/DEBIAN/control" << EOF
Package: cursor-ide
Version: $VERSION
Section: development
Priority: optional
Architecture: amd64
Installed-Size: $size
Maintainer: Cursor DEB Packager <github@cursor-deb.pkg>
Description: Cursor IDE
 AI-first code editor based on VSCode.
 Created from official AppImage.
EOF
}

create_scripts() {
    cat > "$DEB_DIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e
chmod +x /opt/cursor/AppRun
update-desktop-database -q 2>/dev/null || true
EOF

    cat > "$DEB_DIR/DEBIAN/postrm" << 'EOF'
#!/bin/bash
set -e
[ "$1" = "purge" ] && rm -rf /opt/cursor
update-desktop-database -q 2>/dev/null || true
EOF

    chmod 755 "$DEB_DIR/DEBIAN/postinst" "$DEB_DIR/DEBIAN/postrm"
}

build_package() {
    echo "Building package..."
    DEB_NAME="cursor-ide_${VERSION}_amd64.deb"
    dpkg-deb --build "$DEB_DIR" "$DEB_NAME" >/dev/null
    echo "Created: $DEB_NAME"
}

trap cleanup EXIT

check_dependencies
setup_directories
download_appimage
extract_appimage
setup_package
build_package