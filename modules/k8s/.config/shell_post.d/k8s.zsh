#!/usr/bin/env zsh

if [[ -x $(command -v kubectl) ]]; then
  source <(kubectl completion zsh)
fi
