#!/usr/bin/env bash

# see: ../shell_pre.d/mise.sh for config related
# to "loading" mise

mise_tool_version() {
  local tool_name
  tool_name=$1
  mise current "${tool_name}"
}

mise_python3_version() {
  mise_tool_version "python"
}

export DOTFILES_PYTHON3_VERSION=$(mise_python3_version)
