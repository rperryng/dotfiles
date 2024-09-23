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

  cargo binstall -y mise
  mise --yes install
}

install() {
  install_mise
}

install
