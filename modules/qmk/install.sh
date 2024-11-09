#!/usr/bin/env bash

set -eo pipefail

install() {
  if [[ -x $(command -v "qmk") ]]; then
    return 0
  fi

  if [[ $DOTFILES_OS == 'debian' ]]; then
    python3 -m pip install --user qmk
  elif [[ $DOTFILES_OS == 'macos' ]]; then
    brew install qmk/qmk/qmk
  else
    echo "Don't know how to install qmk for ${DOTFILES_OS}"
    return 1
  fi
}

install
