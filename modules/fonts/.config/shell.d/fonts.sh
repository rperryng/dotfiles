#!/usr/bin/env bash

list-fonts() {
  if [[ "${DOTFILES_OS}" != "macos" ]]; then
    echo "command not yet implemented for os '${DOTFILES_OS}'" 1>&2
    return 1
  fi

  system_profiler -json SPFontsDataType | grep \"family | sort | uniq
}
