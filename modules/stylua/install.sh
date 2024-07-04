#!/usr/bin/env bash

install() {
  if [[ -x "$(command -v stylua)" ]]; then
    return 0
  fi

  if [[ -x $(command -v cargo) ]]; then
    cargo install stylua
    return 0
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install stylua 
      ;;
    "debian")
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install
