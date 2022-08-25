#!/usr/bin/env bash

install() {
  case ${DOTFILES_OS} in
    "macos")
      brew install jesseduffield/lazygit/lazygit
      ;;
    "debian")
      LAZYGIT_VERSION=$( \
        curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep -Po '"tag_name": "v\K[0-35.]+' \
      )

      curl -Lo \
        /tmp/lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

      sudo tar xf lazygit.tar.gz -C ${XDG_BIN_HOME} lazygit
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install
