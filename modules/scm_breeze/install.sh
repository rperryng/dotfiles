#!/usr/bin/env bash

SCM_BREEZE_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}/scm_breeze"
CLONE_URL="https://github.com/scmbreeze/scm_breeze.git"

install() {
  git clone "${CLONE_URL}" "${SCM_BREEZE_HOME}"

  pushd "${SCM_BREEZE_HOME}"
  ./install.sh
  popd
}

install
