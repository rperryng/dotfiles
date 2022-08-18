#!/usr/bin/env zsh

echo "Installing neovim"

NVIM_HOME="${XDG_OPT_HOME}/nvim"

install_neovim() {
  if command -v nvim; then
    echo "neovim already installed"
    return
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install \
        ninja libtool automake cmake pkg-config gettext curl
      ;;
    "debian")
      sudo apt install \
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
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  # TODO: markdown-preview, firenvim, nvim-treesitter installation errors
  nvim +PlugInstall +qAll
}

install_neovim
install_vim_plug
