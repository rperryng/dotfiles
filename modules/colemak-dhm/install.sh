#!/usr/bin/env bash

CLONE_URL="git@github.com:ColemakMods/mod-dh.git"
CLONE_DIR="$HOME/code/ColemakMods/mod-dh"
SYSTEM_LAYOUTS_DIR="/Library/Keyboard Layouts"
COLEMAK_LAYOUTS_DIR="${SYSTEM_LAYOUTS_DIR}/Colemak DH.bundle"

NO_COLOR='\033[0m'
YELLOW='\033[0;33m'

install_macos() {
  if [[ ! -d "$CLONE_DIR" ]]; then
    mkdir -p "$CLONE_DIR"
    git clone "${CLONE_URL}" "${CLONE_DIR}"
  fi

  if [[ ! -f "$COLEMAK_LAYOUTS_DIR" ]]; then
    echo "copying 'Colemak DH.bundle' to system layouts directory"
    sudo cp -r "${CLONE_DIR}/macOS/Colemak DH.bundle" "${COLEMAK_LAYOUTS_DIR}"
    echo -e "${YELLOW}Colemak DHm installed - this won't be available until logged out / in."
  fi
}

install() {
  case ${DOTFILES_OS} in
    "macos")
      install_macos
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install
