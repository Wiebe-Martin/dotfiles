#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="hyprland"
ARCH_PACKAGE_NAME="hyprland hyprpaper hypridle xdg-desktop-portal-hyprland"
APT_PACKAGE_NAME=""
PORTAGE_PACKAGE_NAME="gui-wm/hyprland gui-apps/hypridle gui-apps/hyprpaper gui-libs/xdg-desktop-portal-hyprland"

install() {
    echo "Installing $PACKAGE_NAME..."

    if command -v apt >/dev/null 2>&1; then
        echo "Hyprland not supported on Ubuntu. Install it from source!"
        # TODO: Build Hyprland, latest wayland, wayland-protocols, and libdisplay-info tagged releases from source

        exit 1
    elif command -v pacman >/dev/null 2>&1; then
        eval "$PACMAN_COMMAND $ARCH_PACKAGE_NAME"
    elif command -v emerge >/dev/null 2>&1; then
        eval "$PORTAGE_COMMAND $PORTAGE_PACKAGE_NAME"
    else
        echo "Error: Unsupported system" >&2
        exit 1
    fi
}

config() {
    # Linking
    if [[ -z "${PACKAGE_PATH:-}" ]]; then
        echo "Error: PACKAGE_PATH is not set" >&2
        exit 1
    fi

    echo "Linking $PACKAGE_PATH/$PACKAGE_NAME to $XDG_CONFIG_HOME/hypr"
    ln -sf "$PACKAGE_PATH/$PACKAGE_NAME" "$XDG_CONFIG_HOME/hypr"
}
