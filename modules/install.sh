#!/usr/bin/env bash

set -e -o pipefail

install() {
  pushd "${DOTFILES_DIR:-$HOME/.dotfiles}/modules"

  local packages
  packages=$(git ls-files | grep "./*/install.sh")
  while IFS= read -r package; do
    echo "==================================="
    echo "===========  DOTFILES  ============"
    echo "Installing module '$(basename $(dirname ${package}))'"

    "$package"
  done <<< "$packages"

  popd
}

install
