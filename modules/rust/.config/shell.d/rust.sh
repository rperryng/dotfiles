#!/usr/bin/env bash

# Also see: modules/rust/install.sh
# Ensure rust (particularly `cargo`) is already setup,
# since mise is installed with cargo
export RUSTUP_HOME="${XDG_CONFIG_HOME}/.rustup"
export CARGO_HOME="${XDG_CONFIG_HOME}/.cargo"

if [[ -d "${CARGO_HOME}/bin" ]]; then
  prepend_path "${CARGO_HOME}/bin"
fi

cargo_binstall_available() {
  if [[ ! -x "$(command -v cargo)" ]]; then
    return 1;
  fi

  cargo binstall --help &> /dev/null
}
