#!/bin/bash
# ============================================================================
# PAIN x tkietn - Build Script for Theos (iOS arm64 / arm64e)
# ============================================================================

set -e

export THEOS="${THEOS:-$HOME/theos}"
if [ ! -d "$THEOS" ]; then
    echo "[!] Error: THEOS is not found at $THEOS"
    echo "[i] Please install Theos: bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)\""
    exit 1
fi

echo "[*] Cleaning old build artifacts..."
make clean

echo "[*] Compiling PAIN x tkietn (Metal backend + Dear ImGui)..."
make package FINALPACKAGE=1

echo "[+] Build complete! Output located in ./packages/"
ls -lh packages/*.deb 2>/dev/null || true

