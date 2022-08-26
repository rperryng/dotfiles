#!/usr/bin/env bash

set -e

SSH_HOME="${HOME}/.ssh"

install() {
  if is_wsl; then
    sudo apt install keychain
  fi
}

install
