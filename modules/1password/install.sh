#!/usr/bin/env bash


# https://developer.1password.com/docs/cli/get-started/

set -e

function install() {
  if [[ -x "$(command -v op)" ]]; then
    echo "1password installed"
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install --cask 1password/tap/1password-cli
      ;;
    "debian")
      # Add the key for the 1Password Apt repository:
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

      # Add the 1Password Apt repository:
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
       sudo tee /etc/apt/sources.list.d/1password.list

      # Add the debsig-verify policy:
      sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
      curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
        sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

      sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

      # Install CLI
      sudo apt update && sudo apt install 1password-cli

      op --version
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install
