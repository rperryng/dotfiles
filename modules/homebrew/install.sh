#!/usr/bin/env bash
#
# Setup homebrew
#

set -e

# Check if homebrew is installed
if [[ ! -x "$(command -v brew)" ]]; then
  sudo -v

  if [[ "${DOTFILES_OS}" == 'macos' ]]; then
    # Install standard homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  elif [[ "${DOTFILES_OS}" == linux* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    source "${DOTFILES_DIR}/modules/homebrew/.config/shell.d/brew.sh"
  fi
else
  echo "brew already installed."
fi
