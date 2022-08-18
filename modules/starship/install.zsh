#!/usr/bin/env zsh

function install() {
  case ${DOTFILES_OS} in
    "debian") curl -sS https://starship.rs/install.sh | sh -s -- -y ;;
    "macos") brew install "starship" ;;
    *)
      echo "unsupported os ${DOTFILES_OS}"
      exit 1
      ;;
  esac
}

install
