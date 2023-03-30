#!/usr/bin/env bash

set -e

function install() {
  if [[ -x $(command -v "starship") ]]; then
    return 0
  fi

  case ${DOTFILES_OS} in
    "debian") curl -sS https://starship.rs/install.sh | sh -s -- -y ;;
    "macos") brew install "starship" ;;
    *)
      echo "unsupported os '${DOTFILES_OS}'"
      exit 1
      ;;
  esac
}

install
