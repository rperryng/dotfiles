#!/usr/bin/env bash

# Also see: modules/rust/install.sh
export RUSTUP_HOME="${XDG_CONFIG_HOME}/.rustup"
export CARGO_HOME="${XDG_CONFIG_HOME}/.cargo"

if [[ -d "${CARGO_HOME}/bin" ]]; then
  prepend_path "${CARGO_HOME}/bin"
fi

cargo_binstall_available() {
  if [[ ! -x "$(command -v cargo)" ]]; then
    echo "cargo not installed - cannot install 'cargo-binstall'" 1>&2
    return 1;
  fi

  cargo binstall --help &> /dev/null
}
