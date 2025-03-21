#!/usr/bin/env bash

set -e -o pipefail

SPOONS_INSTALL_DIR="$HOME/.config/hammerspoon/Spoons"

install_spoons() {
  if [[ -d "$SPOONS_INSTALL_DIR" ]]; then
    return 0;
  fi

  mkdir "$SPOONS_INSTALL_DIR"

  echo "Installing SpoonInstall..."
  curl -L0 \
    https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip |
    tar -zx -C "$SPOONS_INSTALL_DIR"
}

configire_hammerspoon() {
  echo "Configuring Hammerspoon..."
  defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"
}

install() {
  if [[ "${DOTFILES_OS}" != "macos" ]]; then
    return 0;
  fi

  if [[ -d "/Applications/Hammerspoon.app" ]]; then
    return 0;
  fi

  brew install --cask hammerspoon

  install_spoons
  configure_hammerspoon
}

install
