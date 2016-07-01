#!/usr/bin/env zsh

setopt promptsubst
autoload -U add-zsh-hook


PROMPT='%{$fg_bold[cyan]%}%n%{$reset_color%} %{$fg_bold[green]%}%~%{$reset_color%}%{$reset_color%} %{$fg_bold[magenta]%}►%{$reset_color%} '
RPROMPT='$(git_remote_status)$(git_prompt_info)$(git_prompt_status)'

PROMPT2='%{$fg_bold[magenta]%}►%{$reset_color%} '
RPROMPT2='%{$fg_bold[red]%}↵%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg_bold[white]%}[%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[white]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[green]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%} ✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%} ⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%} ✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[cyan]%} ➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ♒%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%} ✭%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[green]%}↑ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[green]%}↓ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[yellow]%}↯ %{$reset_color%}"