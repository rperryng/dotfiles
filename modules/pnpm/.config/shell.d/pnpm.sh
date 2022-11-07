#!/usr/bin/env bash

if [[ -x "$(command -v pnpm)" ]]; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
  export PATH="$PNPM_HOME:$PATH"
fi
