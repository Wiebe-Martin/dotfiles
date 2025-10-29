# Created by newuser for 5.9
# # Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

export PATH=/home/martin/.local/bin:$PATH

export LC_ALL=en_US.utf8

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# zinit light jeffreytse/zsh-vi-mode
zinit ice depth=1

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
# zinit snippet OMZP::sudo
zinit snippet OMZP::ubuntu
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# eval "$(oh-my-posh init zsh --config /home/martin/Downloads/tiwahu.omp.json)"
eval "$(starship init zsh)"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color -A'
alias ll='ls -lh --color -A'
alias vim='nvim'
alias c='clear'
alias sf='nvim $(fzf)'
alias tm='tmux attach || tmux new'
alias ts='tmux-sessionizer'
alias tsn='tmux-sessionizer && nvim .'
alias rel="xrdb merge $HOME/.config/st/xresources && kill -USR1 $(pidof st)"

# Set up fzf key bindings and fuzzy completion
eval "$(zoxide init --cmd cd zsh)"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

bindkey '^Y' forward-char
bindkey -r '^F'

bindkey -s ^f "tmux-sessionizer\n"

# source "$HOME/key-bindings.zsh"
# export FZF_TMUX_OPTS='-d 40%'
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude mnt --search-path / --follow'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export EDITOR=nvim

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/martin/go/bin
export PATH=$PATH:/snap/bin
export PATH=$PATH:$HOME/scripts

export PATH="$PATH:/home/martin/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin"

export ZEPHYR_BASE=~/zephyrproject/zephyr

export PATH="$HOME/neovim/bin:$PATH"

export EXTRA_ZEPHYR_MODULES="/home/martin/dev/slio-test"

export PATH="$PATH:$HOME/t32/bin/pc_linux64"
export T32SYS="$HOME/t32"
export T32TMP=/tmp
export T32ID=T32
