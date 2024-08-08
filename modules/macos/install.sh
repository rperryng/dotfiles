#!/usr/bin/env bash

set -e

set_defaults() {
  # normal minimum is 15 (225 ms)
  defaults write -g InitialKeyRepeat -int 10

  # normal minimum is 2 (30 ms)
  defaults write -g KeyRepeat -int 1
}

install() {
  if [[ "${DOTFILES_OS}" != 'macos' ]]; then
    return 0;
  fi

  set_defaults

  brew install --cask \
    easy-move-plus-resize \
    rectangle \
    jordanbaird-ice
}

install
