#!/usr/bin/env bash

set -e -o pipefail

EQMAC_APP_PATH='/Applications/eqMac.app/Contents/MacOS/eqMac'

if [[ -f $EQMAC_APP_PATH ]]; then
  restart_eqmac() {
    if ps aux | grep --quiet "$EQMAC_APP_PATH"; then
      pkill -f "$EQMAC_APP_PATH"
      sleep 1
    fi

    open -a eqMac
  }
fi
