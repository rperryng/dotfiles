#
# ZSH Prompt
#

# Disable auto correct
unsetopt CORRECT
unsetopt CORRECT_ALL
DISABLE_CORRECTION=true

# Initialize prompt
autoload -U promptinit
promptinit

# Use starship prompt
eval "$(starship init zsh)"
