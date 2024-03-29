#!/usr/bin/env bash

set -e

BAT_LATEST_RELEASE_URL="https://api.github.com/repos/sharkdp/bat/releases/latest"

install() {
  if [[ -x "$(command -v bat)" ]]; then
    return;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install bat
      ;;
    "debian")
      release_version="$(uname -m)-unknown-linux-musl"
      download_url=$( \
        curl -sSL \
          -H "Accept: application/vnd.github+json" \
          "${BAT_LATEST_RELEASE_URL}" \
          | jq ".assets[] | select(.name | contains(\"${release_version}\")) | .browser_download_url" --raw-output
      )

      echo "download URL for latest bats ${release_version}: ${download_url}"

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
  local bat_theme_path src_path des_path
  bat_theme_path="$(bat --config-dir)/themes"
  src_path="${DOTFILES_DIR:-$HOME/.dotfiles}/data/gruvbox-dark-hard.tmTheme"
  dest_path="${bat_theme_path}/gruvbox-dark-hard.tmTheme"

  if [[ -f "${dest_path}" || -h "${dest_path}" ]]; then
    return 0;
  fi

  mkdir -p $bat_theme_path
  echo "copying from $src_path to $dest_path"
  cp ${src_path} ${dest_path}
  bat cache --build
}

install
install_gruvbox_bat_theme
