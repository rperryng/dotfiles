#!/usr/bin/env bash

DEBIAN_RELEASE_URL='https://github.com/jarun/nnn/releases/download/v4.6/nnn-static-4.6.x86_64.tar.gz'
NNN_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/nnn"

function install() {
  if [[ -x "$(command -v nnn)" ]]; then
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install nnn
      ;;
    "apt")
      mkdir -p "${NNN_HOME}"
      curl -fsSL "${DEBIAN_RELEASE_URL}" > /tmp/nnn-static.tar.gz
      tar -xf /tmp/nnn-static.tar.gz --directory="${NNN_HOME}"
      mv "${NNN_HOME}/nnn-static" "${XDG_BIN_HOME}/nnn"
      ;;
    *)
      install_packages "nnn"
      ;;
  esac
}

install
