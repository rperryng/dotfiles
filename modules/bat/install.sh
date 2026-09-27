#!/usr/bin/env bash

set -e

# bat itself is installed via mise (modules/mise/.config/mise/config.toml)

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

install_gruvbox_bat_theme
