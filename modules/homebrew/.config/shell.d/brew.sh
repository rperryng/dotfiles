#!/usr/bin/env bash

if [[ ${DOTFILES_OS} == "macos" ]]; then
  export PATH="/opt/homebrew/bin:${PATH}"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ ${DOTFILES_OS} == "debian" ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
