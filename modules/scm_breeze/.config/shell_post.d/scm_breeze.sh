#!/usr/bin/env bash

export SCM_BREEZE_DISABLE_ASSETS_MANAGEMENT=true

# load scm_breeze
SCM_BREEZE_PATH="${XDG_OPT_HOME}/scm_breeze/scm_breeze.sh"
[ -s "${SCM_BREEZE_PATH}" ] && source "${SCM_BREEZE_PATH}"

[ -s "/Users/rperrynguyen/.scm_breeze/scm_breeze.sh" ] && source "/Users/rperrynguyen/.scm_breeze/scm_breeze.sh"
