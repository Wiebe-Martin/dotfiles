#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="nvim"
ARCH_PACKAGE_NAME="neovim ripgrep nodejs npm"
APT_PACKAGE_NAME="neovim rust-ripgrep"
PORTAGE_PACKAGE_NAME="app-editors/neovim sys-apps/ripgrep"

install() {
    echo "Installing $PACKAGE_NAME..."

    if command -v $PACKAGE_NAME >/dev/null 2>&1; then
        echo "$PACKAGE_NAME already installed!"
        exit 0
    fi

    if command -v apt >/dev/null 2>&1; then
        eval "$APT_COMMAND $APT_PACKAGE_NAME"

        echo "Downloading latest release"
        wget -qO /tmp/nvim-linux-x86_64.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz

        echo "Installing $PACKAGE_NAME"
        sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
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

    echo "Linking $PACKAGE_PATH/$PACKAGE_NAME to $XDG_CONFIG_HOME/"
    ln -sf "$PACKAGE_PATH/$PACKAGE_NAME" "$XDG_CONFIG_HOME/"
}
