#
# FZF Configuration
#
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
export FZF_DEFAULT_OPTS="--height 70% --layout=reverse"
export FZF_ALT_C_COMMAND='rg --files --hidden --follow --glob "!.git" | xargs dirname | sort -u'

prepend_path "${XDG_OPT_HOME}/fzf/bin"
