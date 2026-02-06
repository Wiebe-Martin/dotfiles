#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="noctalia"
ARCH_PACKAGE_NAME="noctalia-shell cava"
APT_PACKAGE_NAME="quickshell brightnessctl git imagemagick python cava"
PORTAGE_PACKAGE_NAME="gui-apps/noctalia-shell cava"

install() {
    echo "Installing $PACKAGE_NAME..."

    if command -v apt >/dev/null 2>&1; then
        eval "$APT_COMMAND $APT_PACKAGE_NAME"

        mkdir -p ~/.config/quickshell/noctalia-shell && curl -sL https://github.com/noctalia-dev/noctalia-shell/releases/latest/download/noctalia-latest.tar.gz | tar -xz --strip-components=1 -C ~/.config/quickshell/noctalia-shell
    elif command -v pacman >/dev/null 2>&1; then
        eval "$YAY_COMMAND $ARCH_PACKAGE_NAME"
    elif command -v emerge >/dev/null 2>&1; then
        echo "gui-apps/noctalia-shell ~amd64" | sudo tee /etc/portage/package.accept_keyword/noctalia-shell >/dev/null

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
