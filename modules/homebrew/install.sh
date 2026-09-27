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

  if [[ "${DOTFILES_OS}" == 'debian' ]]; then
    sudo apt-get install build-essential procps curl file git
  fi

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # The installer runs in a subprocess, so brew isn't on PATH in this shell yet.
  local brew_bin
  if [[ "${DOTFILES_OS}" == 'debian' ]]; then
    brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
  elif [[ "$(uname -m)" == "arm64" ]]; then
    brew_bin="/opt/homebrew/bin/brew"
  else
    brew_bin="/usr/local/bin/brew"
  fi
  eval "$("${brew_bin}" shellenv)"
  echo "Successfully installed brew"
}

install
