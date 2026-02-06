#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="fastfetch"
ARCH_PACKAGE_NAME="fastfetch"
APT_PACKAGE_NAME="fastfetch"
PORTAGE_PACKAGE_NAME="fastfetch"

install() {
    echo "Installing $PACKAGE_NAME..."

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

    echo "Linking $PACKAGE_PATH/$PACKAGE_NAME to $XDG_CONFIG_HOME"
    ln -sf "$PACKAGE_PATH/$PACKAGE_NAME" "$XDG_CONFIG_HOME"
}
