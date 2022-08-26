#
# ZSH Prompt
#

# Disable auto correct
unsetopt CORRECT
unsetopt CORRECT_ALL
DISABLE_CORRECTION=true

# Load functions, store the cache file somewhere transient
autoload -Uz compinit
compinit -d "${XDG_OPT_HOME}/.zcompdump"

# Initialize prompt
autoload -Uz promptinit
promptinit

# Use starship prompt
eval "$(starship init zsh)"
