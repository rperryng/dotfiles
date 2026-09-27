#!/usr/bin/env bash

install() {
  local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
  local settings_dir="${dotfiles_dir}/modules/claude/.claude"
  local merge_jsonc="${dotfiles_dir}/modules/merge-jsonc/.local/bin/merge-jsonc"

  # Modules install alphabetically, so make sure merge-jsonc is built first
  source "${dotfiles_dir}/modules/merge-jsonc/install.sh"

  local tmp
  tmp="$(mktemp)"
  "${merge_jsonc}" "${settings_dir}/rpn-settings" > "${tmp}"
  mv "${tmp}" "${settings_dir}/settings.json"
}

install
