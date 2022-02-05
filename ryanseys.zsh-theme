if [ -z "$SPIN" ]
then
  RYANSEYS_ENV_CHAR="⌘"
else
  RYANSEYS_ENV_CHAR="꩜"
fi

PROMPT="%(?:%{$fg_bold[green]%}${RYANSEYS_ENV_CHAR} :%{$fg_bold[red]%}${RYANSEYS_ENV_CHAR} )"
PROMPT+='%{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
