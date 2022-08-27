#!/usr/bin/env bash

# Avoid having to enter a password _every_ time an interaction with ssh happens
if [[ ${DOTFILES_IS_WSL} == 1 ]]; then
  keychain --nogui --quiet $HOME/.ssh/id_ed25519
  source "${HOME}/.keychain/$(hostname)-sh"
fi
