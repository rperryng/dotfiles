#!/usr/bin/env zsh

function install() {
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
