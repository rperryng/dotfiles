#!/usr/bin/env bash

export NNN_OPTS="AH"
export NNN_BMS='d:~/Downloads;c:~/code;h:~'
export NNN_NO_AUTOSELECT=1
export NNN_COLORS=4321

if is_wsl; then
  wsl_home_path="$(wslpath 'D:\wsl-home')" 2>/dev/null

  if [[ $? -eq 0 ]]; then
    export NNN_BMS="w:${wsl_home_path};${NNN_BMS}"
  fi
fi
