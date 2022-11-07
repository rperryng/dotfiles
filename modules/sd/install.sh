#!/usr/bin/env bash

set -e

install() {
  if [[ -x "$(command -v sd)" ]]; then
    return 0;
  fi

  if [[ ! -x "$(command -v cargo)" ]]; then
    echo "cargo not installed; can't install sd"
    exit 1
  fi

  cargo install sd
}

install
