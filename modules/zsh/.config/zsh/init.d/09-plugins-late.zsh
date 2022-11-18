#!/usr/bin/env zsh
#
# ZSH Prompt
#
# Some plugins need to be loaded _after_ compinit has been called
#

source_files_in "$XDG_CONFIG_HOME"/shell_post.d/*.sh

# These are being set... somewhere
set +e +o pipefail
