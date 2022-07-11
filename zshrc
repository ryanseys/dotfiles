#!/bin/zsh

# Set editor and visual if code command exists.
if command -v code &> /dev/null; then
  export {EDITOR,VISUAL}="code"
else
  export {EDITOR,VISUAL}="vim"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ryanseys"
DISABLE_UPDATE_PROMPT="true"

plugins=(git history-substring-search zsh-autosuggestions zsh-completions ruby zsh-syntax-highlighting)

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'

source $ZSH/oh-my-zsh.sh

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

# git fuzzy - https://github.com/bigH/git-fuzzy
[ -d "/Users/ryanseys/code/git-fuzzy/bin" ] && export PATH="/Users/ryanseys/code/git-fuzzy/bin:$PATH"

source ~/.aliases
source ~/.aliases_local
source ~/.zshrc_local
