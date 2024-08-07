#!/usr/bin/env bash

set -e

install_wezterm() {
  if [[ -x $(command -v wezterm) ]]; then
    return 0
  fi

  case "${DOTFILES_OS}" in
    "macos")
      brew install --cask wezterm
      ;;
    "debian")
      curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
      echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
      sudo apt install wezterm
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install_wezterm
