#!/bin/bash
set -e

# Flatpak Build Script for Cockpit Tools

FLATPAK_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_ID="com.jlcodes.cockpit-tools"

echo "=== Cockpit Tools Flatpak Builder ==="

# Check dependencies
for cmd in flatpak flatpak-builder; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done

# Install runtime if needed
echo "=== Installing runtime ==="
flatpak install -y flathub org.gnome.Platform//46 org.gnome.Sdk//46 || true

# Install SDK extensions
echo "=== Installing SDK extensions ==="
flatpak install -y flathub org.freedesktop.Sdk.Extension.rust-stable//24.08 org.freedesktop.Sdk.Extension.node20//20.08 || true

# Build the flatpak
echo "=== Building Flatpak ==="
cd "$FLATPAK_DIR"

flatpak-builder --user --install-deps-from=flathub --force-clean build-dir com.jlcodes.cockpit-tools.json

# Create the bundle
echo "=== Creating bundle ==="
flatpak build-bundle ~/.local/share/flatpak/repo "${APP_ID}.flatpak" "$APP_ID" --runtime-repo=https://flathub.org/repo/flathub.flatpakrepo

echo "=== Done! ==="
echo "Flatpak bundle created: ${APP_ID}.flatpak"
echo "Install with: flatpak install ${APP_ID}.flatpak"
