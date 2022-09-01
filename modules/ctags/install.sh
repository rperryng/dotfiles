#!/usr/bin/env bash

set -e -o pipefail

install() {
  case ${DOTFILES_OS} in
    "macos")
      brew install ctags
      ;;
    "debian")
      sudo apt install -y exuberant-ctags
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}
install
