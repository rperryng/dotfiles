#!/usr/bin/env bash

set -eo pipefail

install() {
  if [[ -x $(command -v fd) ]]; then
    return 0
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install "fd"
      ;;
    "debian")
      sudo apt install --yes fd-find
      ;;
    *)
      echo "don't know how to install 'fd' on ${DOTFILES_OS}" 1>&2
      return 1
      ;;
  esac
}

install
