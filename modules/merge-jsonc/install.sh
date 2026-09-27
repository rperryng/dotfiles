#!/usr/bin/env bash

install() {
  local module_dir="${DOTFILES_DIR:-$HOME/.dotfiles}/modules/merge-jsonc"

  if [[ -x "${module_dir}/.local/bin/merge-jsonc" ]]; then
    return;
  fi

  (cd "${module_dir}/unstowed" && deno task compile)
}

install
