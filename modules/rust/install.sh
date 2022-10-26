#!/usr/bin/env bash

set -e

install_rustup() {
  if [[ -x "$(command -v rustup)" ]]; then
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install rustup
      ;;
    "debian")
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --no-modify-path

      export PATH="${XDG_CONFIG_HOME}/.cargo/bin:${PATH}"
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported"
      exit 1
      ;;
  esac

  rustup toolchain install beta
}

install_rust() {
  if [[ ! -x "$(command -v rustup)" ]]; then
    return 1;
  fi
}

install() {
  install_rustup
  install_rust
}

install
