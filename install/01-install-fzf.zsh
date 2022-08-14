#!/usr/bin/env zsh

FZF_HOME="${XDG_OPT_HOME}/.fzf"

# Install fzf
git clone \
  --depth 1 \
  https://github.com/junegunn/fzf.git \
  "$FZF_HOME"

pushd $FZF_HOME
./install
popd
