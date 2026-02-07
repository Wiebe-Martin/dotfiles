#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="spotify-player"
ARCH_PACKAGE_NAME="spotify-player"
APT_PACKAGE_NAME=""
PORTAGE_PACKAGE_NAME=""

install() {
    echo "Installing $PACKAGE_NAME..."

    if command -v $PACKAGE_NAME >/dev/null 2>&1; then
        echo "$PACKAGE_NAME already installed!"
        exit 0
    fi

    if command -v apt >/dev/null 2>&1; then
        # eval "$APT_COMMAND $APT_PACKAGE_NAME"
        echo "Error: Unsupported system" >&2
        exit 1
    elif command -v pacman >/dev/null 2>&1; then
        eval "$PACMAN_COMMAND $ARCH_PACKAGE_NAME"
    elif command -v emerge >/dev/null 2>&1; then
        # eval "$PORTAGE_COMMAND $PORTAGE_PACKAGE_NAME"
        echo "Error: Unsupported system" >&2
        exit 1
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

    echo "Linking $PACKAGE_PATH/$PACKAGE_NAME to $XDG_CONFIG_HOME/"
    ln -sf "$PACKAGE_PATH/$PACKAGE_NAME" "$XDG_CONFIG_HOME/"
}
