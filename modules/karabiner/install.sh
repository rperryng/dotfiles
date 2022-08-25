#!/usr/bin/env bash

set -e

install() {
  if [[ "${DOTFILES_OS}" != "macos" ]]; then
    return 0
  fi

  # TODO: Install Karabiner??
}

install
