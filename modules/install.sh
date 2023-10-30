#!/usr/bin/env bash

set -e -o pipefail

install() {
  pushd "${DOTFILES_DIR:-$HOME/.dotfiles}/modules"

  # Install ASDF first
  source ./asdf/install.sh

  local packages
  readarray -t packages_array < <(git ls-files | grep "./*/install.sh" | grep -v "asdf")
  # packages=$(git ls-files | grep "./*/install.sh" | grep -v "asdf")
  

  echo "============================"
  echo "Installing modules:"
  echo "$packages"
  echo "============================"
  echo "..."

  # while IFS= read -r package; do
  for package in "${packages_array[@]}"
    local name=$(basename $(dirname ${package}))

    echo "==================================================="
    echo "           Installing module '$name'"
    echo "==================================================="

    source "$package"

    echo "==================================================="
    echo "           Done installing '$name'"
    echo "==================================================="
    echo "..."
    echo "Remaining packages:"
    echo "$packages"
  done <<< "$packages"

  echo "============================"
  echo "Done installing modules"
  echo "============================"
  echo "..."

  popd
}

install
