#!/usr/bin/env bash
set -e

FONT_BREW_NAME='font-meslo-lg-nerd-font'
# FONT_BREW_NAME='font-inconsolata-lgc-nerd-font'

install_nerd_fonts_macos() {
  if [[ $(brew list) =~ "$FONT_BREW_NAME" ]]; then
    return 0
  fi

  echo "Installing font ${FONT_BREW_NAME}"
  brew install "$FONT_BREW_NAME"
}

install() {
  if [[ "${DOTFILES_OS}" == "macos" ]]; then
    # install_powerline_fonts_macos
    install_nerd_fonts_macos
  fi
}

install
