#
# Load any plugins
#

# Source common interactive shell scripts
source_files_in "$XDG_CONFIG_HOME"/shell.d/*.sh

# TODO: pick one... shell? environment? zshrc?
source_files_in "$XDG_CONFIG_HOME"/zsh.d/*.zsh
source_files_in "$XDG_CONFIG_HOME"/zshrc.d/*.zsh
