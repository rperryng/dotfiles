#!/usr/bin/env bash
#
# Setup homebrew
#

set -e

BREWFILE="${DOTFILES_DIR:-$HOME/.dotfiles}/modules/homebrew/.config/homebrew/Brewfile"

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

# Install everything in the Brewfile. macOS only: it's mostly casks.
bundle() {
  if [[ "${DOTFILES_OS}" != 'macos' ]]; then
    return 0
  fi

  # This file is sourced by both the root install.sh and modules/install.sh;
  # only bundle once per run.
  if [[ -n "${DOTFILES_BREW_BUNDLED}" ]]; then
    return 0
  fi

  # --no-upgrade: install what's missing without upgrading everything else.
  # Don't abort the whole dotfiles install on one failed package (e.g. an app
  # that was installed outside of brew); brew bundle reports each failure.
  if ! brew bundle install --no-upgrade --file="${BREWFILE}"; then
    echo "WARNING: brew bundle had failures (see above). Check with:" >&2
    echo "  brew bundle check --verbose --file=${BREWFILE}" >&2
  fi

  export DOTFILES_BREW_BUNDLED=1
}

install
bundle
