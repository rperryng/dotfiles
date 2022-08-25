#!/usr/bin/env bash

set -e

BAT_LATEST_RELEASE_URL="https://api.github.com/repos/sharkdp/bat/releases/latest"
ASSET_NAME="bat-v0.21.0-x86_64-unknown-linux-gnu.tar.gz"

install() {
  if [[ -x "$(command -v bat)" ]]; then
    return;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install bat
      ;;
    "debian")
      download_url=$( \
        curl -sSL \
          -H "Accept: application/vnd.github+json" \
          "${BAT_LATEST_RELEASE_URL}" \
          | jq ".assets[] | select(.name == \""${ASSET_NAME}"\") " \
          | jq '.browser_download_url' --raw-output
      )

      curl -sSL "${download_url}" > /tmp/bat.tar.gz
      mkdir -p /tmp/bat
      tar xf /tmp/bat.tar.gz --directory=/tmp/bat
      extract_dir_name=$(ls /tmp/bat)
      mv "/tmp/bat/${extract_dir_name}/bat" "${XDG_BIN_HOME:-$HOME/.local/bin}"
      chmod +x "${XDG_BIN_HOME:-$HOME/.local/bin}/bat"
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install_gruvbox_bat_theme() {
  mkdir -p "$(bat --config-dir)/themes"
  cp "${DOTFILES_DIR:-$HOME/.dotfiles}/data/gruvbox-dark-hard.tmTheme" "$(bat --config-dir)/themes"
  bat cache --build
}

install
install_gruvbox_bat_theme
