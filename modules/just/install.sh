#!/usr/bin/env bash

set -e -o pipefail

function install() {
  if [[ -x "$(command -v just)" ]]; then
    return 0;
  fi

  if [[ ! -x "$(command -v asdf)" ]]; then
    echo "command 'asdf' not available. can't install 'just'"
    return 1;
  fi

  asdf plugin add just
  asdf install just
}

install
