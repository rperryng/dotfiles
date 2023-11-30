#!/usr/bin/env bash

export ASDF_DIR="${XDG_OPT_HOME:-$HOME/.local/opt}/asdf"

# XDG Specification
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME}/asdf/tool-versions"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/asdf/default-python-packages"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/asdf/default-npm-packages"
export ASDF_GEM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/asdf/default-gem-packages"

# Load ASDF
. "${XDG_OPT_HOME:-$HOME/.local/opt}/asdf/asdf.sh"

# add completions
fpath=(${ASDF_DIR}/completions $fpath)

asdf_tool_version() {
  local tool_name
  tool_name=$1
  cat $ASDF_DEFAULT_TOOL_VERSIONS_FILENAME | rg "^${tool_name}" | rg --only-matching '\d+\.\d+\.\d+$'
}

asdf_python3_version() {
  cat $ASDF_DEFAULT_TOOL_VERSIONS_FILENAME | rg '^python' | rg --only-matching '3\.\d+\.\d+'
}
export DOTFILES_PYTHON3_VERSION=$(asdf_python3_version)
