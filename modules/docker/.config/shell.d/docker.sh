#!/usr/bin/env bash

alias d="docker"

function select_docker_container_id() {
  docker container ls \
    --format 'table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.RunningFor}}\t{{.Image}}' \
    | fzf_with_header '([a-zA-Z0-9]+)'
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
