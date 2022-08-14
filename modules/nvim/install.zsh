#!/usr/bin/env zsh

install() {
  if command -v nvim; then
    echo "neovim already installed"
    return
  fi

  case ${os_family} in
    "macos")
      install_packages \
        'ninja libtool automake cmake pkg-config gettext curl'
      ;;
    "debian")
      install_packages \
        'ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen'
      ;;
    *)
      echo "OS family: '${os_family}' not supported"
      exit 1
      ;;
  esac

  if [[ ! -d "$HOME/.neovim" ]]; then
    git clone https://github.com/neovim/neovim.git ${HOME}/.neovim
  fi

  pushd $(HOME)/.neovim >/dev/null
  make CMAKE_BUILD_TYPE=Release
  $sudo_cmd make install
  popd >/dev/null
}

install()
