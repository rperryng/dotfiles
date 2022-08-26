#!/usr/bin/env bash

set -e

FZF_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/fzf"

install() {
  if [[ -x $(command -v fzf) && "${INSTALL_FORCE_FZF:-0}" != 0 ]]; then
    return 0
  fi

  if [[ ! -d ${FZF_HOME} ]]; then
    # Install fzf
    git clone \
      --depth 1 \
      https://github.com/junegunn/fzf.git \
      "$FZF_HOME"
  fi

  pushd $FZF_HOME
  ./install \
    --key-bindings \
    --completion \
    --no-bash \
    --no-zsh \
    --no-fish
  popd
}

install
