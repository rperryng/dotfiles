#!/usr/bin/env bash

export NNN_OPTS="AH"
export NNN_BMS='d:~/Downloads;w:~/code/ws;c:~/code;h:~'
export NNN_NO_AUTOSELECT=1
export NNN_COLORS=4321

if is_wsl; then
  export NNN_BMS="a:$(wslpath 'C:\Users\ryanp\home');${NNN_BMS}"
fi
