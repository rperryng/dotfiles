#
# FZF Configuration
#

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --inline-info --preview 'preview {} | head -n 500'"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --hidden --follow --no-messages"

# gruvbox-dark
export FZF_DEFAULT_OPTS='
  --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
  --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
'

export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} | sed -E 's#/[^/]+\$##' | sort -u"
