#!/usr/bin/env bash

set -e

export NVIM_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/nvim"

install_luajit() {
  if [[ -x $(command -v luajit) ]]; then
    return 0
  fi

  case ${DOTFILES_OS} in
    "macos") ;; # installed via the Brewfile (modules/homebrew)
    "debian") sudo apt install liblua5.1-0-dev ;;
    *) ;;
  esac
}

install_neovim() {
  if [[ -x $(command -v nvim) ]]; then
    return 0
  else
    echo "nvim not available; should have been installed by mise?"
    return 1
  fi
}

install_vim_virtual_environments() {
  if [[ ! -x "$(command -v mise)" ]]; then
    echo "mise not installed - cannot setup virtual vim environments"
    return 1
  fi

  mkdir -p "${XDG_OPT_HOME}/nvim/virtualenvs"
  pushd "${XDG_OPT_HOME}/nvim/virtualenvs"

  if [[ ! -d './neovim3' ]]; then
    export MISE_PYTHON_VERSION=${DOTFILES_PYTHON3_VERSION}
    virtualenv neovim3
    source neovim3/bin/activate
    pip install neovim neovim-remote
    deactivate
    mise reshim python

    unset MISE_PYTHON_VERSION
  fi

  popd
}

install_plugins() {
  # Install plugins at the versions pinned in lazy-lock.json, so the first
  # interactive launch doesn't run config against half-installed plugins.
  nvim --headless "+Lazy! restore" +qa
}

install_luajit
install_neovim
install_vim_virtual_environments
install_plugins

echo "installed neovim successfully"
