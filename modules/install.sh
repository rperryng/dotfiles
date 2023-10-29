#!/usr/bin/env bash

set -e -o pipefail

install() {
  pushd "${DOTFILES_DIR:-$HOME/.dotfiles}/modules"

  local packages
  packages=$(git ls-files | grep "./*/install.sh")

  # Install ASDF first
  source ./asdf/install.sh

  if [[ ! -x $(command -v asdf) ]]; then
    echo "[modules/install.sh]: ASDF still not installed.  Aborting"

    source ./asdf/debug.sh
    exit 1;
  fi

  while IFS= read -r package; do
    local name=$(basename $(dirname ${package}))

    echo "==================================================="
    echo "           Installing module '$name'"
    echo "==================================================="

    source "$package"

    echo "==================================================="
    echo "           done installing '$name'"
    echo "==================================================="
    echo "..."
  done <<< "$packages"

  popd
}

install
