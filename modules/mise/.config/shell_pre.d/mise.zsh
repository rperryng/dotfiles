#!/usr/bin/env zsh

export CARGO_HOME="${XDG_CONFIG_HOME}/.cargo"
eval "$("${CARGO_HOME}/bin/mise" activate zsh)"
