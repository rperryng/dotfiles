#!/usr/bin/env bash

set -eo pipefail

# qmk is not installed globally: qmk_userspace's mise.toml provides the qmk CLI,
# the ARM toolchain and QMK_HOME/QMK_USERSPACE, scoped to that repo.
QMK_HOME="${QMK_HOME:-${HOME}/code/rperryng/qmk_firmware}"
QMK_USERSPACE_PATH="${HOME}/code/rperryng/qmk_userspace"

clone_qmk_firmware() {
  if [[ -d "${QMK_HOME}" ]]; then
    return 0
  fi

  echo "Cloning qmk_firmware repo"
  mkdir -p "${QMK_HOME}"
  git clone git@github.com:rperryng/qmk_firmware.git "${QMK_HOME}"
  git -C "$QMK_HOME" remote add upstream git@github.com:qmk/qmk_firmware.git
}

init_qmk_firmware_submodules() {
  # Checked by qmk_userspace's `mise run doctor`
  if [[ -d "${QMK_HOME}/lib/chibios/os" ]]; then
    return 0
  fi

  echo "Initialising qmk_firmware submodules"
  git -C "${QMK_HOME}" submodule update --init --recursive
}

clone_qmk_userspace() {
  if [[ -d "${QMK_USERSPACE_PATH}" ]]; then
    return 0
  fi

  echo "Cloning qmk_userspace repo"
  mkdir -p "${QMK_USERSPACE_PATH}"
  git clone git@github.com:rperryng/qmk_userspace.git "${QMK_USERSPACE_PATH}"
}

install_qmk_userspace_tools() {
  mise trust "${QMK_USERSPACE_PATH}/mise.toml"
  mise --cd "${QMK_USERSPACE_PATH}" --yes install
}

clone_qmk_firmware
init_qmk_firmware_submodules
clone_qmk_userspace
install_qmk_userspace_tools
