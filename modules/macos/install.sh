#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
ADD_LOGIN_ITEMS_SCRIPT="${SCRIPT_DIR}/add-login-items.ts"

set_defaults() {
  # normal minimum is 15 (225 ms)
  defaults write -g InitialKeyRepeat -int 10

  # normal minimum is 2 (30 ms)
  defaults write -g KeyRepeat -int 1

  # By default, pressing and holding will present a popup for picking character
  # variants (e.g. accented e)
  defaults write -g ApplePressAndHoldEnabled -bool false
}

install() {
  if [[ "${DOTFILES_OS}" != 'macos' ]]; then
    return 0
  fi

  set_defaults

  brew install --cask \
    easy-move-plus-resize \
    rectangle \
    jordanbaird-ice \
    maccy \
    karabiner-elements

  "${ADD_LOGIN_ITEMS_SCRIPT}"
}

install
