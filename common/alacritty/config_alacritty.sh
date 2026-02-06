#!/usr/bin/env bash

set -euo pipefail

ARCH_PACKAGE_NAME="alacritty"
APT_PACKAGE_NAME="cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3"
PORTAGE_PACKAGE_NAME="x11-terms/alacritty"

install() {
    echo "Installing alacritty..."

    if command -v apt >/dev/null 2>&1; then
        echo "Installing dependencies..."
        eval "$APT_COMMAND $APT_PACKAGE_NAME"

        if command -v cargo >/dev/null 2>&1; then
            sudo cargo install alacritty
        else
            echo "Error: Cargo not installed."
            exit 1
        fi
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

    echo "Linking $PACKAGE_PATH/alacritty to $XDG_CONFIG_HOME/"
    ln -sf "$PACKAGE_PATH/alacritty" "$XDG_CONFIG_HOME/"
}
