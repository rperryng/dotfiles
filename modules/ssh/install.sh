#!/usr/bin/env bash

SSH_HOME="${HOME}/.ssh"

install() {
  if is_wsl; then
    sudo apt install keychain
  fi
}

install
