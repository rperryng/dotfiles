#!/usr/bin/env bash

set -e

install() {
  if [[ -x "$(command -v lazygit)" ]]; then
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install jesseduffield/lazygit/lazygit
      ;;
    "debian")
      release_version="Linux_$(uname -m)"
      lazygit_download_url=$( \
        curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | jq --raw-output ".assets[] | select(.name | contains(\"${release_version}\")) | .browser_download_url" \
      )

      curl -Lo \
        /tmp/lazygit.tar.gz \
        "${lazygit_download_url}"

      sudo tar xf /tmp/lazygit.tar.gz -C ${XDG_BIN_HOME:-$HOME/.local/bin} lazygit
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac
}

install
