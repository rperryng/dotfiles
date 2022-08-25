#!/usr/bin/env bash
# https://github.com/dmarcotte/easy-move-resize

install() {
  if [[ "${DOTFILES_OS}" != 'macos' ]]; then
    return 0;
  fi

  brew install --cask easy-move-plus-resize
}

install
