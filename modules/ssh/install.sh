#!/usr/bin/env bash

set -e

SSH_HOME="${HOME}/.ssh"

install() {
  if [[ ${DOTFILES_IS_WSL} == 1 ]]; then
    sudo apt install keychain
  fi
}

install
