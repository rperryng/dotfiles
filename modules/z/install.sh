#!/usr/bin/env bash

set -e

Z_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/z"
Z_GIT_URL="https://github.com/rupa/z"

install() {
  if [[ -x "$(command -v z)" ]]; then
    return 0;
  fi

  if [[ ! -d ${Z_HOME} ]]; then
    git clone \
      --depth 1 \
      "${Z_GIT_URL}" \
      "${Z_HOME}"
  fi
}

install
