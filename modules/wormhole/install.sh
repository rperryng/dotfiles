#!/usr/bin/env bash

set -e

install() {
  if [[ -x "$(command -v wormhole)" ]]; then
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install magic-wormhole
      ;;
    "debian")
      sudo apt install -y magic-wormhole
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install
