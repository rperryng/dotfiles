#!/usr/bin/env zsh

function install() {
  case ${pkg_mgr} in
    "apt") curl -sS https://starship.rs/install.sh | sh -s -- -y ;;
    *) install_packages "starship" ;;
}

install
