#
# FZF Configuration
#
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse"

prepend_path "${XDG_OPT_HOME}/fzf/bin"
