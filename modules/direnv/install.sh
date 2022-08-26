#!/usr/bin/env bash

DIRENV_INSTALL_URL="https://direnv.net/install.sh"

set -e

install() {
  if [[ -x $(command -v direnv) ]]; then
    echo "dirnev already installed"
    return 0
  fi

  export bin_path=$XDG_BIN_HOME
  curl -sfL $DIRENV_INSTALL_URL | bash
}

install
