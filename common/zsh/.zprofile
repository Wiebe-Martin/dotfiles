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

export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa" 

# Ensure XDG base dirs exist (optional but sane)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
