#!/usr/bin/env bash

set -eo pipefail

install_jj() {
  if [[ -x "$(command -v jj)" ]]; then
    return 0;
  fi

  if ! cargo_binstall_available; then
    return 1;
  fi

  cargo binstall --strategies crate-meta-data jj-cli
}

install_jj
