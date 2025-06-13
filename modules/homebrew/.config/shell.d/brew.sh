#!/usr/bin/env bash

if [[ ${DOTFILES_OS} == "macos" ]]; then
  PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ ${DOTFILES_OS} == "debian" ]]; then
  PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
