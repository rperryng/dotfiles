#!/usr/bin/env zsh

function install() {
  case ${os_family} in
    "macos")
      brew install ripgrep
      ;;
    "debian")
      sudo apt install ripgrep
      ;;
    *)
      echo "OS family: '${os_family}' not supported"
      exit 1
      ;;
  esac
}

install
