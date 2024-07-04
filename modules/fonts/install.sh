#!/usr/bin/env bash
set -e

install_nerd_fonts_macos() {
  if [[ $(brew list) =~ "font-meslo-lg-nerd-font" ]]; then
    return 0
  fi

  brew install font-meslo-lg-nerd-font
}

install() {
  if [[ "${DOTFILES_OS}" == "macos" ]]; then
    # install_powerline_fonts_macos
    install_nerd_fonts_macos
  fi
}

install
