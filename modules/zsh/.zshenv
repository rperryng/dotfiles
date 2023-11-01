#!/usr/bin/env zsh
#
# Bootstrap ~/.zshenv file to xdg config
#

# XDG configuration
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Non-standard
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_LIB_HOME="${XDG_LIB_HOME:-$HOME/.local/lib}"
export XDG_OPT_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}"

# Zsh home directory
ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Load the zshenv
source "${ZDOTDIR}/.zshenv"
