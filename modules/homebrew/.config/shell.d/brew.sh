#!/usr/bin/env bash

if [[ ${DOTFILES_OS} == "debian" ]]; then
  PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
