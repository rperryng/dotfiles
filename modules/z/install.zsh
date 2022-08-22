#!/usr/bin/env zsh

Z_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/z"
Z_GIT_URL="https://github.com/rupa/z"

install() {
  git clone \
    --depth 1 \
    "${Z_GIT_URL}" \
    "${Z_HOME}"
}

install
