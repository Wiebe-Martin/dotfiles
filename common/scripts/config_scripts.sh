#!/usr/bin/env bash

config() {
    if [[ -z "${PACKAGE_PATH:-}" ]]; then
        echo "Error: PACKAGE_PATH is not set" >&2
        exit 1
    fi

    SCRIPTS_PATH="$PACKAGE_PATH/scripts"
    echo "Linking $SCRIPTS_PATH to $HOME/"
    ln -sf "$SCRIPTS_PATH" "$HOME/"
}
