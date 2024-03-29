#!/usr/bin/env bash

set -e

PLUGIN_CLONE_URL="https://github.com/zsh-users/zsh-syntax-highlighting.git" 
PLUGIN_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/zsh-syntax-highlighting"

install() {
  if [[ ! -d "${PLUGIN_HOME}" ]]; then
    git clone \
      $PLUGIN_CLONE_URL \
      $PLUGIN_HOME
  fi
}

install
