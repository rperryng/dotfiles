#!/usr/bin/env bash
# https://github.com/dmarcotte/easy-move-resize

set -e

install() {
  if [[ "${DOTFILES_OS}" != 'macos' ]]; then
    return 0;
  fi

  brew install --cask easy-move-plus-resize
  brew install --cask hammerspoon
}

install
