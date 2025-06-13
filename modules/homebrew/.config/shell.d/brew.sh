#!/usr/bin/env bash

if [[ ${DOTFILES_OS} == "macos" ]]; then
  echo "loading brew shell scripts for macos"
  export PATH="/opt/homebrew/bin:${PATH}"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ ${DOTFILES_OS} == "debian" ]]; then
  echo "loading brew shell scripts for debian"
  export PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
