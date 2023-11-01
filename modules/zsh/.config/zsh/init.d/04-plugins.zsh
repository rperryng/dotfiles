#
# Load any plugins
#

# Source common interactive shell scripts
source_files_in "$XDG_CONFIG_HOME"/shell.d/*.sh
source_files_in "$XDG_CONFIG_HOME"/shell.d/*.zsh

# TODO: pick one... shell? environment? zshrc?
source_files_in "$XDG_CONFIG_HOME"/zsh.d/*.zsh
source_files_in "$XDG_CONFIG_HOME"/zshrc.d/*.zsh

# TODO: fix this?
fpath=("${XDG_CONFIG_HOME}/zfunc.d" "${fpath[@]}")
for functions_file in ${XDG_CONFIG_HOME}/zfunc.d/*(N.); do
  eval "autoload -Uz $(basename $functions_file)"
done
