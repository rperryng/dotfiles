#!/usr/bin/env bash

#
# Yarn Configuration
#

alias ydd="yarn-deduplicate yarn.lock"

if [[ -x "$(command -v yarn)" ]]; then
  prepend_path "$(yarn global bin)"
fi
