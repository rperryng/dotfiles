#!/usr/bin/env bash

set -eo pipefail

QMK_HOME="${QMK_HOME:-${HOME}/code/qmk/qmk_firmware}"

clone_qmk() {
  if [[ -d "${QMK_HOME}" ]]; then
    return 0
  fi

  echo "Cloning qmk_firmware repo"
  mkdir -p "${QMK_HOME}"
  git clone git@github.com:qmk/qmk_firmware.git "${QMK_HOME}"
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

clone_qmk
install
