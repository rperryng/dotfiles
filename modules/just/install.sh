#!/usr/bin/env bash

set -e -o pipefail

function install() {
  if [[ -x "$(command -v nnn)" ]]; then
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos"|"debian")
      brew install just
      ;;
    *)
      echo "don't know how to install 'just' on ${DOTFILES_OS}"
      ;;
  esac
}

install
