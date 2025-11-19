#!/usr/bin/env bash

if [[ ${DOTFILES_OS} == "macos" ]]; then
  if [[ $(uname -m) == "x86_64" ]]; then
    export PATH="/usr/local/bin:${PATH}"
    eval "$(/usr/local/bin/brew shellenv)"
  elif [[ $(uname -m) == "arm64" ]]; then
    export PATH="/opt/homebrew/bin:${PATH}"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "Don't know how to setup brew for macos with architecture '$(uname -m)'" 1>&2
  fi
fi

if [[ ${DOTFILES_OS} == "debian" ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
