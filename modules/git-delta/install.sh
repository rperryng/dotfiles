#!/usr/bin/env bash

set -eo pipefail

install() {
  if [[ -x $(command -v delta) ]]; then
    return 0;
  fi

  if [[ -x $(command -v brew) ]];then
    brew install git-delta
  else
    echo "Don't know how to install 'git-delta'"
    return 1
  fi
}

install
