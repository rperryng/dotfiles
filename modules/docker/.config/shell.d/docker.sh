#!/usr/bin/env bash

alias dk="docker"

function select_docker_container_id() {
  local docker_container_ls_output=$(
    docker container ls \
      --format 'table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}' \
  )

  echo $docker_container_ls_output \
    | tail -n+2 \
    | fzf --header="$(echo $docker_container_ls_output | head -1)" \
    | grep -oE '\s([a-zA-Z0-9]+)' \
    | head -1 \
    | grep -oE '([a-zA-Z0-9]+)'
}

function dlogs() {
  local container_id=$(select_docker_container_id)
  if [[ -n "${container_id}" ]]; then
    echo "container_id is '${container_id}'"
    docker container logs --follow "${container_id}"
    return
  fi

  false
}

# Docker container id fuzzy
function docker-container-widget() {
  LBUFFER="${LBUFFER}$(select_docker_container_id)"
  local rcode=$?
  zle reset-prompt
  return $rcode
}
zle -N docker-container-widget
bindkey '^X^D' docker-container-widget
