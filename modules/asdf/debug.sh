#!/usr/bin/env bash

set -e

if [[ ! -x $(command -v asdf) ]]; then
  echo "[asdf/debug.sh]: asdf not found"
fi

echo "[asdf/debug.sh]: ASDF_DIR: ${ASDF_DIR}"
source "${ASDF_DIR:-$HOME/.local/opt/asdf/asdf.sh}

if [[ ! -x $(command -v asdf) ]]; then
  echo "[asdf/debug.sh]: asdf STILL not found"
fi