#!/usr/bin/env bash

PACKAGE_NAME="tmux-sessionizer"

config() {
    if [[ -z "${PACKAGE_PATH:-}" ]]; then
        echo "Error: PACKAGE_PATH is not set" >&2
        exit 1
    fi

    echo "Linking $PACKAGE_PATH/$PACKAGE_NAME to $XDG_CONFIG_HOME/"
    ln -sf "$PACKAGE_PATH/$PACKAGE_NAME" "$XDG_CONFIG_HOME/"
}
