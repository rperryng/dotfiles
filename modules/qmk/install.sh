#!/usr/bin/env bash

set -eo pipefail

QMK_FIRMWARE_REPO_PATH="${HOME}/code/qmk/qmk_firmware"

clone_qmk() {
  if [[ -d "${QMK_FIRMWARE_REPO_PATH}" ]]; then
    return 1
  fi

  echo "Cloning qmk_firmware repo"
  mkdir -p "${QMK_FIRMWARE_REPO_PATH}"
  git clone git@github.com:qmk/qmk_firmware.git "${QMK_FIRMWARE_REPO_PATH}"
}

install() {
  if [[ -x $(command -v "qmk") ]]; then
    return 0
  fi

  if [[ $DOTFILES_OS == 'debian' ]]; then
    python3 -m pip install --user qmk
  elif [[ $DOTFILES_OS == 'macos' ]]; then
    brew install qmk/qmk/qmk
  else
    echo "Don't know how to install qmk for ${DOTFILES_OS}"
    return 1
  fi

  qmk setup --yes
}

install
clone_qmk
