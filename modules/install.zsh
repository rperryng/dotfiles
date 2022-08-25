#!/usr/bin/env zsh

# stub file to invoke the real install.sh bash script
# the root install.sh starts "zsh" in order to load all the expected environment
# variables when installing the modules.
"${DOTFILES_DIR:-$HOME/.dotfiles}/modules/install.sh"
