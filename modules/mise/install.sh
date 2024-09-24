#!/usr/bin/env bash

set -eo pipefail

install_mise() {
  if [[ -x $(command -v mise) ]]; then
    return 0
  fi

  if ! cargo_binstall_available; then
    echo "cargo binstall not available; "
    return 1
  fi

  # prerequisites for ruby-build
  if [[ $DOTFILES_OS == 'debian' ]]; then
    sudo apt install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
  fi

  cargo binstall -y mise
  mise --yes install
}

install() {
  install_mise
}

install
