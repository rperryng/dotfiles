#!/usr/bin/env bash

set -e

NVIM_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/nvim"

install_neovim() {
  if [[ -x $(command -v nvim) ]]; then
    return 0
  else
    echo "nvim not available; should have been installed by asdf?"
    return 1
  fi
}

install_vim_virtual_environments() {
  if [[ ! -x "$(command -v asdf)" ]]; then
    echo "asdf not installed - cannot setup virtual vim environments"
    return 1
  fi

  mkdir -p "${XDG_OPT_HOME}/nvim/virtualenvs"
  pushd "${XDG_OPT_HOME}/nvim/virtualenvs"

  if [[ ! -d './neovim3' ]]; then
    export ASDF_PYTHON_VERSION=${DOTFILES_PYTHON3_VERSION}
    virtualenv neovim3
    source neovim3/bin/activate
    pip install neovim neovim-remote
    deactivate
    asdf reshim python
  fi

  popd
}

install_neovim
install_vim_virtual_environments

echo "installed neovim successfully"
