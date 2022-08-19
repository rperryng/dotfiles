#!/usr/bin/env zsh

export ASDF_DIR="${XDG_OPT_HOME:-$HOME/.local/opt}/asdf"

# XDG Specification
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME}/asdf/tool-versions"

# Load ASDF
. "${XDG_OPT_HOME:-$HOME/.local/opt}/asdf/asdf.sh"

# add completions
fpath=(${ASDF_DIR}/completions $fpath)
