#!/usr/bin/env bash

set -e

function install() {
  if ! [[ -x "$(command -v brew)" ]]; then
    echo "brew not found - can't verify git installation"
    return 1
  fi

  if brew list --versions git > /dev/null 2>&1; then
    return 0
  fi

  brew install git
}

install
