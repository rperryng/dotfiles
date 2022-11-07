#!/usr/bin/env zsh

# stub file to invoke the real install.sh bash script
# the root install.sh could be executed from bash, so using a `.zsh` here
# at least ensures that the zsh environment variables/config etc are present
# before installing all the modules.
"${DOTFILES_DIR:-$HOME/.dotfiles}/modules/install.sh"
