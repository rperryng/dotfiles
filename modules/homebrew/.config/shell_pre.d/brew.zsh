#!/usr/bin/env zsh
#
# Initialize homebrew BEFORE mise captures PATH in __MISE_ORIG_PATH
# This ensures homebrew paths are at the front when mise's precmd hook runs
#

if [[ ${DOTFILES_OS} == "macos" ]]; then
  if [[ $(uname -m) == "x86_64" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
elif [[ ${DOTFILES_OS} == "debian" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
