#!/usr/bin/env bash

# Also see: modules/rust/install.sh
export RUSTUP_HOME="${XDG_CONFIG_HOME}/.rustup"
export CARGO_HOME="${XDG_CONFIG_HOME}/.cargo"

if [[ -d "${CARGO_HOME}/bin" ]]; then
  prepend_path "${CARGO_HOME}/bin"
fi
