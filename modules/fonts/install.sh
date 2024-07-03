#!/usr/bin/env bash
set -e

POWERLINE_FONTS_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/powerline-fonts"
POWERLINE_FONTS_GIT_URL="https://github.com/powerline/fonts.git"
POWERLINE_FONTS_INSTALLED_MARKER="${XDG_OPT_HOME:-$HOME/.local/opt}/powerline-fonts-marker"

install_powerline_fonts_macos() {
  # use a file to mark installed since using "system_profiler" to inspect
  # installed fonts takes a long time
  if [[ -f "${POWERLINE_FONTS_INSTALLED_MARKER}" ]]; then
    return 0;
  fi

  echo "Installing powerline-fonts"

  git clone "${POWERLINE_FONTS_GIT_URL}" --depth=1 "${POWERLINE_FONTS_HOME}"
  cd "${POWERLINE_FONTS_HOME}"
  ./install.sh

  touch "${POWERLINE_FONTS_INSTALLED_MARKER}"
}

install() {
  if [[ "${DOTFILES_OS}" == "macos" ]]; then
    install_powerline_fonts_macos
  fi
}

install
