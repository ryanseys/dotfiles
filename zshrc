#!/bin/zsh

# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"

source ~/.aliases

ZSH_THEME="robbyrussell"
DISABLE_UPDATE_PROMPT="true"

plugins=(git history-substring-search zsh-autosuggestions zsh-completions ruby zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'

source $ZSH/oh-my-zsh.sh
