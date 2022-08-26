#!/usr/bin/env bash

set -e

WIN32YANK_LATEST_RELEASE_URL="https://api.github.com/repos/equalsraf/win32yank/releases/latest"

install() {
  if ! is_wsl; then
    return 0;
  fi

  if [[ -x "$(command -v win32yank.exe)" ]]; then
    return 0;
  fi

  MACHINE_TYPE=$(uname -m)
  if [ ${MACHINE_TYPE} = 'x86_64' ]; then
    ASSET_NAME="win32yank-x64.zip"
  else
    ASSET_NAME="win32yank-x86.zip"
    # 32-bit stuff here
  fi

  download_url=$( \
    curl -sSL \
      -H "Accept: application/vnd.github+json" \
      "${WIN32YANK_LATEST_RELEASE_URL}" \
      | jq ".assets[] | select(.name == \""${ASSET_NAME}"\") " \
      | jq '.browser_download_url' --raw-output
  )

  curl -sSL "${download_url}" > /tmp/win32yank.zip
  unzip -q /tmp/win32yank.zip -d /tmp/win32yank
  mv /tmp/win32yank/win32yank.exe "${XDG_BIN_HOME}"
  chmod +x "${XDG_BIN_HOME}/win32yank.exe"
}

install
