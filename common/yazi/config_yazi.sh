#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="yazi"
ARCH_PACKAGE_NAME="yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick"
APT_PACKAGE_NAME="ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick"
PORTAGE_PACKAGE_NAME="app-misc/yazi"

install() {
    echo "Installing $PACKAGE_NAME..."

    if command -v $PACKAGE_NAME >/dev/null 2>&1; then
        echo "$PACKAGE_NAME already installed!"
        exit 0
    fi

    if command -v apt >/dev/null 2>&1; then
        eval "$APT_COMMAND $APT_PACKAGE_NAME"

        echo "Downloading latest release"
        wget -qO /tmp/yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip

        tmp="$(mktemp -d)"
        unzip -q /tmp/yazi.zip -d $tmp

        echo "Moving binaries to /usr/local/bin"
        sudo mv $tmp/*/{ya,yazi} /usr/local/bin
    elif command -v pacman >/dev/null 2>&1; then
        eval "$PACMAN_COMMAND $ARCH_PACKAGE_NAME"
    elif command -v emerge >/dev/null 2>&1; then
        echo "app-misc/yazi ~amd64" | sudo tee /etc/portage/package.accept_keyword/yazi >/dev/null

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

    echo "Linking $PACKAGE_PATH/$PACKAGE_NAME to $XDG_CONFIG_HOME/"
    ln -sf "$PACKAGE_PATH/$PACKAGE_NAME" "$XDG_CONFIG_HOME/"
}
