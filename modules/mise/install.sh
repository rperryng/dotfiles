#!/usr/bin/env bash

set -eo pipefail

install_mise() {
  if [[ -x $(command -v mise) ]]; then
    return 0
  fi

  if [[ ! cargo_binstall_available ]]; then
    return 1;
  fi

  # prerequisites for ruby-build
  if [[ $DOTFILES_OS == 'debian' ]]; then
    sudo apt install -y autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
  elif [[ $DOTFILES_OS == 'macos' ]]; then
    brew install libyaml
  fi

  cargo binstall --no-confirm mise
  mise --yes install
  . "${DOTFILES_DIR}/modules/mise/.config/shell.d/mise.sh"
}

install() {
  install_mise
}

install
