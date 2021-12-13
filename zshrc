#!/bin/zsh

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

source ~/.aliases

ZSH_THEME="ryanseys"

DISABLE_UPDATE_PROMPT="true"

plugins=(git history-substring-search zsh-autosuggestions zsh-completions ruby zsh-syntax-highlighting)

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'

source $ZSH/oh-my-zsh.sh

# Reload completions
autoload -U compinit && compinit

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
