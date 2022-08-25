#!/usr/bin/env bash

set -e

NVIM_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/nvim"

install_neovim() {
  if [[ -x $(command -v nvim) ]]; then
    return 0
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install \
        ninja libtool automake cmake pkg-config gettext curl
      ;;
    "debian")
      sudo apt install --yes \
        ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac

  if [[ ! -d "${NVIM_HOME}" ]]; then
    git clone https://github.com/neovim/neovim.git "${NVIM_HOME}"
  fi

  pushd ${NVIM_HOME} >/dev/null
  make CMAKE_BUILD_TYPE=Release
  sudo make install
  popd >/dev/null
}

install_vim_plug() {
  VIM_PLUG_DEST="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"

  if [[ ! -f $VIM_PLUG_DEST ]]; then
    sh -c "curl -fLo ${VIM_PLUG_DEST} --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

    nvim "+source ${XDG_CONFIG_HOME}/nvim/.vim_plug_snapshot" "+qall!" || true
  fi
}

install_vim_virtual_environments() {
  if [[ ! -x "$(command -v asdf)" ]]; then
    echo "asdf not installed - cannot setup virtual vim environments"
    return 1
  fi

  mkdir -p "${XDG_OPT_HOME}/nvim/virtualenvs"
  pushd "${XDG_OPT_HOME}/nvim/virtualenvs"

  # Python2
  if [[ ! -d './neovim2' ]]; then
    export ASDF_PYTHON_VERSION=$(asdf_python2_version)
    virtualenv neovim2
    source neovim2/bin/activate
    pip install neovim neovim-remote
    deactivate
    asdf reshim python
  fi

  if [[ ! -d './neovim3' ]]; then
    export ASDF_PYTHON_VERSION=$(asdf_python3_version)
    virtualenv neovim3
    source neovim3/bin/activate
    pip install neovim neovim-remote
    deactivate
    asdf reshim python
  fi

  popd
}

install_neovim
install_vim_plug
install_vim_virtual_environments
