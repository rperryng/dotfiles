#!/usr/bin/env bash
#
# Setup homebrew
#

set -e

install() {
  if [[ -x "$(command -v brew)" ]]; then
    return 0
  fi

  if [[ "${DOTFILES_OS}" != 'macos' && "${DOTFILES_OS}" != 'debian' ]]; then
    echo "unsupported OS for homebrew: ${DOTFILES_OS}"
    return 0
  fi

  sudo -v
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  source "${DOTFILES_DIR}/modules/homebrew/.config/shell.d/brew.sh"
}

install
