#!/bin/zsh

# Spin related configs
if [[ -v SPIN ]]; then
  # Source zsh config in Spin if it exists
  [[ -f /etc/zsh/zshrc.default.inc.zsh ]] && source /etc/zsh/zshrc.default.inc.zsh
else
  #export DISABLE_SPRING=1
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

source ~/.aliases

ZSH_THEME="ryanseys"
EDITOR="vim"

DISABLE_UPDATE_PROMPT="true"

plugins=(git history-substring-search zsh-autosuggestions zsh-completions ruby zsh-syntax-highlighting)

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'

source $ZSH/oh-my-zsh.sh

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
