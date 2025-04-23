#!/usr/bin/env bash

# jj installed with mise

install_lazyjj() {
  if [[ -x "$(command -v lazyjj)" ]]; then
    return 0;
  fi

  if [[ ! cargo_binstall_available ]]; then
    return 1;
  fi

  cargo binstall --no-confirm lazyjj
}

install
