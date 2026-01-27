# ~/.zshrc
# Interactive shell configuration

### Zinit ###########################################################

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

### Plugins ########################################################

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# zinit light jeffreytse/zsh-vi-mode

zinit ice depth=1

### Oh-My-Zsh snippets ############################################

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

### Completion ####################################################

autoload -Uz compinit
compinit

zinit cdreplay -q

### Prompt ########################################################

eval "$(starship init zsh)"

### History #######################################################

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="$HOME/.zsh_history"

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

### Completion styling ############################################

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

### Aliases #######################################################

alias ls='ls --color=auto -A'
alias ll='ls -lh --color=auto -A'
alias vim='nvim'
alias c='clear'
alias sf='nvim $(fzf)'
alias tm='tmux attach || tmux new'
alias ts='tmux-sessionizer'
alias tsn='tmux-sessionizer && nvim .'
alias rel='xrdb merge ~/.config/st/xresources && kill -USR1 $(pidof st)'

alias update='sudo emaint --auto sync'
alias upgrade='sudo emerge --ask --quiet --update --deep --newuse @world'

### Functions #####################################################

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

### Tools #########################################################

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

### Keybindings ###################################################

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^Y' forward-char
bindkey -r '^F'
bindkey -s '^f' 'tmux-sessionizer\n'

