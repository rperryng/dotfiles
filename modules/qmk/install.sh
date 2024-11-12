#!/usr/bin/env bash

set -eo pipefail

QMK_HOME="${QMK_HOME:-${HOME}/code/qmk/qmk_firmware}"
QMK_USERSPACE_PATH="${HOME}/code/rperryng/qmk_userspace"

clone_qmk_firmware() {
  if [[ -d "${QMK_HOME}" ]]; then
    return 0
  fi

  echo "Cloning qmk_firmware repo"
  mkdir -p "${QMK_HOME}"
  git clone git@github.com:qmk/qmk_firmware.git "${QMK_HOME}"
}

clone_qmk_userspace() {
  if [[ -d "${QMK_USERSPACE_PATH}" ]]; then
    return 0
  fi

  echo "Cloning qmk_userspace repo"
  mkdir -p "${QMK_USERSPACE_PATH}"
  git clone git@github.com:rperryng/qmk_userspace.git "${QMK_USERSPACE_PATH}"
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

  # Codify the config generation since the file itself cannot resolve env vars
  # (e.g. setting the overlay dir which is machine-specific), so symlinking the
  # config file is not viable.
  qmk config \
    user.overlay_dir="$(realpath "${QMK_USERSPACE_PATH}")" \
    user.keyboard='zsa/moonlander' \
    user.keymap='rperryng'
}

clone_qmk_firmware
clone_qmk_userspace
install
