#!/usr/bin/env bash

install() {
  if [[ -x "$(command -v jira)" ]]; then
    return;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew tap ankitpokhrel/jira-cli
      brew install jira-cli
      ;;
    *)
      echo "OS family: '${DOTFILES_OS}' not supported; skipping install of jira cli"
      ;;
  esac
}

install
