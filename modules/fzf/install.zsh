#!/usr/bin/env zsh

FZF_HOME="${XDG_OPT_HOME}/fzf"

install() {
  if command -v fzf; then
    echo "'fzf' command already available; skipping"
    return
  fi

  # Install fzf
  git clone \
    --depth 1 \
    https://github.com/junegunn/fzf.git \
    "$FZF_HOME"

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
