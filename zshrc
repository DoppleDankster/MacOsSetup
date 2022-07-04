export ZSH="$HOME/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

ZSH_THEME="ys"

# Shell Configuration
HISTFILE=~/.histfile
HISTSIZE=10000
HISTTIMEFORMAT="%d/%m/%y %T "
SAVEHIST=10000
setopt append_history
setopt hist_ignore_all_dups
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt hist_reduce_blanks
setopt hist_verify
#unsetopt hist_ignore_space      # ignore space prefixed commands
setopt inc_append_history
setopt share_history
setopt bang_hist
setopt extendedglob
setopt nocaseglob
setopt nomatch
setopt nobeep
setopt autocd
setopt correct
setopt hash_list_all

# Navigation
setopt autocd autopushd
autoload -U compinit
compinit
autoload -U promptinit
promptinit

# To source
source $HOME/.profile

# Plugins
plugins=(docker fzf aws poetry zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# SSH KEYS BASTIOn
eval `ssh-agent` &>/dev/null
