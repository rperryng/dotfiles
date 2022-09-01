#
# FZF Configuration
#
export FZF_DEFAULT_OPTS="--height 70% --layout=reverse"

if [ -x "$(command -v rg)" ]; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  export FZF_ALT_C_COMMAND='rg --files --hidden --follow --glob "!.git" | xargs dirname | sort -u'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

prepend_path "${XDG_OPT_HOME}/fzf/bin"
