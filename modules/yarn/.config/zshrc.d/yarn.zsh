#!/usr/bin/env zsh

function yarnWorkspaceFuzzy() {
  local workspaces
  local rcode
  local workspace

  workspaces=$(yarn --json workspaces info)
  rcode=$?
  if [[ ! $rcode -eq 0 ]]; then
    return $rcode
  fi

  workspace=$(
    yarn --json workspaces info \
      | jq '.data' --raw-output \
      | jq 'keys | .[]' --raw-output \
      | fzf --reverse --height '40%'
  )
  rcode=$?
  if [[ ! $rcode -eq 0 ]]; then
    return $rcode
  fi

  echo $workspace
  return $rcode
}

function yarn-workspace-widget() {
  local workspace
  workspace=$(yarnWorkspaceFuzzy)
  local return_code=$?

  if [[ $return_code -eq 0 ]]; then
    BUFFER="yarn workspace '$(yarnWorkspaceFuzzy)' "
    zle end-of-line
  fi
  zle reset-prompt

  return $return_code
}

zle -N yarn-workspace-widget
bindkey '^X^Y' yarn-workspace-widget
