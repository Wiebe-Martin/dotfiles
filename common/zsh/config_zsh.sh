#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="zsh"
ARCH_PACKAGE_NAME="zsh"
APT_PACKAGE_NAME="zsh"
PORTAGE_PACKAGE_NAME="app-shells/zsh"

install() {
    echo "Installing $PACKAGE_NAME..."

    if command -v $PACKAGE_NAME >/dev/null 2>&1; then
        echo "$PACKAGE_NAME already installed!"
        exit 0
    fi

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

    if [[ ! -f "$PACKAGE_PATH/.zshrc" ]]; then
        echo "Error: .zshrc not found at $PACKAGE_PATH/.zshrc" >&2
        exit 1
    fi

    if [[ ! -f "$PACKAGE_PATH/.zprofile" ]]; then
        echo "Error: .zprofile not found at $PACKAGE_PATH/.zprofile" >&2
        exit 1
    fi

    if [[ -f "$HOME/.zshrc" ]] && [[ ! -L "$HOME/.zshrc" ]]; then
        echo "Backing up existing .zshrc to .zshrc.backup"
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi

    if [[ -f "$HOME/.zprofile" ]] && [[ ! -L "$HOME/.zprofile" ]]; then
        echo "Backing up existing .zprofile to .zprofile.backup"
        cp "$HOME/.zprofile" "$HOME/.zprofile.backup"
    fi

    echo "Linking $PACKAGE_PATH/.zshrc to $HOME/"
    ln -sf "$PACKAGE_PATH/.zshrc" "$HOME/"

    echo "Linking $PACKAGE_PATH/.zprofile to $HOME/"
    ln -sf "$PACKAGE_PATH/.zprofile" "$HOME/"

    # Changing default shell to zsh
    current_shell=$(basename "$SHELL")

    if [[ "$current_shell" == "zsh" ]]; then
        echo "You are already using zsh as your default shell."
        return 0
    fi

    if ! command -v zsh >/dev/null 2>&1; then
        echo "Error: zsh is not installed. Please install zsh first." >&2
        exit 1
    fi

    zsh_path=$(command -v zsh)

    if ! grep -q "^${zsh_path}$" /etc/shells; then
        echo "Warning: $zsh_path is not in /etc/shells" >&2
        echo "You may need to add it manually or with sudo privileges" >&2
        exit 1
    fi

    echo "Your current shell is '$current_shell'."
    read -r -p "Do you want to change your default shell to zsh? (y/n): " answer
    answer=${answer,,} # convert to lowercase

    if [[ "$answer" != "y" ]]; then
        echo "Default shell not changed."
        return 0
    fi

    if chsh -s "$zsh_path"; then
        echo "Default shell changed to zsh. Please log out and log back in to apply the change."
    else
        echo "Error: Failed to change the default shell. You might need to run this script with sudo." >&2
        exit 1
    fi
}
