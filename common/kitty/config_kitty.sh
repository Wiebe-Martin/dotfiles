#!/usr/bin/env bash

set -euo pipefail

ARCH_PACKAGE_NAME="kitty"
APT_PACKAGE_NAME="kitty"
PORTAGE_PACKAGE_NAME="x11-terms/kitty"

install() {
    echo "Installing kitty..."

    if command -v apt >/dev/null 2>&1; then
        eval "$APT_COMMAND $APT_PACKAGE_NAME"
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

    echo "Linking $PACKAGE_PATH/kitty to $XDG_CONFIG_HOME/"
    ln -sf "$PACKAGE_PATH/kitty" "$XDG_CONFIG_HOME/"
}
