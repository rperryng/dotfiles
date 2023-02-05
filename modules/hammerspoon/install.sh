#!/usr/bin/env bash

set -e -o pipefail

install() {
  if [[ "${DOTFILES_OS}" != "macos" ]]; then
    return 0;
  fi

  if [[ -d "/Applications/Hammerspoon.app" ]]; then
    return 0;
  fi

  # TODO: install SpoonInstall

  echo "Hammerspoon not installed (https://github.com/Hammerspoon/hammerspoon/releases/latest)"
}

install
