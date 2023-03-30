#!/usr/bin/env bash

#
# FZF Configuration
#
export FZF_DEFAULT_OPTS="--height 70%"

if [ -x "$(command -v rg)" ]; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  export FZF_ALT_C_COMMAND='rg --files --hidden --follow --glob "!.git" | xargs dirname | sort -u'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

prepend_path "${XDG_OPT_HOME}/fzf/bin"

fzf_with_header() {
  local input="$(< /dev/stdin)"
  local header=$(echo $input | head -1)
  local contents=$(echo $input | tail -n+2)
  local pattern=$1

  echo $contents \
    | fzf --header="${header}" \
    | grep -oE "\\s${pattern}" \
    | head -1 \
    | grep -oE $pattern
}
