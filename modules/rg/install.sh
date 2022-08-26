#!/usr/bin/env bash

set -e

function install() {
  if [[ -x $(command -v rg) ]]; then
    return 0
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install ripgrep
      ;;
    "debian")
      sudo apt install ripgrep
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install
