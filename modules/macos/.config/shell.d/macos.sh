#!/usr/bin/env bash

set -e

if [[ "${DOTFILES_OS}" != 'macos' ]]; then
  return 0;
fi

osx-notify() {
  if [ $# -ne 2 ]; then
    echo "Usage: osx-notify <title> <message>"
    return 1
  fi

  local title="$1"
  local message="$2"
  osascript -e "display notification \"${message}\" with title \"${title}\""
}
