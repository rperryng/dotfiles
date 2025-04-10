#!/usr/bin/env zsh

export JJ_CONFIG="${XDG_CONFIG_HOME}/jj/config.toml"

# n on colemak matches where j is on qwerty
alias nn="jj"
alias nlo="nn log"

fzf-jj-bookmark-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local bookmark
  bookmark=$(jj bookmark list --template '{name()}' | fzf --height 40% --reverse --prompt="Select bookmark: ")
  if [[ -n "$bookmark" ]]; then
    LBUFFER="${LBUFFER}${bookmark} "
  fi
  zle reset-prompt
}

# Bind the function to ctrl-b
zle -N fzf-jj-bookmark-widget
bindkey '^B' fzf-jj-bookmark-widget
