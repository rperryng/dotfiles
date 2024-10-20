#!/usr/bin/env bash

set -e

install() {
  if [[ -x "$(command -v sd)" ]]; then
    return 0;
  fi

  if [[ ! cargo_binstall_available ]]; then
    return 1;
  fi

  cargo binstall --no-confirm sd
}

install
