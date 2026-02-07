#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="mango"
ARCH_PACKAGE_NAME="mangowc-git"
APT_PACKAGE_NAME="wayland wayland-protocols ninja meson glibc"
PORTAGE_PACKAGE_NAME="gui-wm/mangowc"

install() {
    echo "Installing $PACKAGE_NAME..."

    if command -v apt >/dev/null 2>&1; then
        echo "Building mangowc and dependecies from source"
        eval "$APT_COMMAND $APT_PACKAGE_NAME"

        echo "Building wlroots"
        git clone -b 1.19.2 https://gitlab.freedesktop.org/wlroots/wlroots.git /tmp/wlroots
        cd /tmp/wlroots
        meson build -Dprefix=/usr
        sudo ninja -C build install

        echo "Building scenefx"
        git clone -b 0.5.1 https://github.com/wlrfx/scenefx.git /tmp/scenefx
        cd /tmp/scenefx
        meson build -Dprefix=/usr
        sudo ninja -C build install

        echo "Building mangowc"
        git clone https://github.com/DreamMaoMao/mangowc.git /tmp/mangowc
        cd /tmp/mangosc
        meson build -Dprefix=/usr
        sudo ninja -C build install
    elif command -v yay >/dev/null 2>&1; then
        eval "$YAY_COMMAND $ARCH_PACKAGE_NAME"
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
