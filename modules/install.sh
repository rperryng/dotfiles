#!/usr/bin/env bash

set -e -o pipefail

install() {
  pushd "${DOTFILES_DIR:-$HOME/.dotfiles}/modules"

  echo "Installing Modules ..."

  # Install cargo (rust) and mise first
  source ./rust/install.sh
  source ./mise/install.sh

  local packages
  packages=$(git ls-files | grep "./*/install.sh" | grep -v "mise" | grep -v "rust")

  echo "============================"
  echo "Installing modules:"
  echo "$packages"
  echo "============================"
  echo "..."

  # Use a custom file descriptor instead of STDIN in case any scripts
  # consume the STDIN contents
  while IFS= read -r package <&3; do
    local name=$(basename $(dirname ${package}))

    echo "==================================================="
    echo "           Installing module '$name'"
    echo "==================================================="

    source "$package"

    echo "==================================================="
    echo "           Done installing '$name'"
    echo "==================================================="
    echo "..."
  done 3< <(echo "$packages")

  echo "============================"
  echo "Done installing modules"
  echo "============================"
  echo "..."

  popd
}

install
