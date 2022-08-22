#!/usr/bin/env bash

alias dk="docker"

function dlogs() {
  local container_id=$(select_docker_container_id)
  if [[ -n "${container_id}" ]]; then
    echo "container_id is '${container_id}'"
    docker container logs --follow "${container_id}"
    return
  fi

  false
