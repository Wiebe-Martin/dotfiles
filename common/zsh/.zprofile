# ~/.zsh_profile
# Login shell configuration

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Editor
export EDITOR=nvim

# PATH (ordered: user → system → language/toolchains)
path=(
  "$HOME/.local/bin"
  "$HOME/scripts"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  "$HOME/.spicetify"
  /usr/local/go/bin
  /snap/bin
  $path
)

export PATH

# Ensure XDG base dirs exist (optional but sane)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
