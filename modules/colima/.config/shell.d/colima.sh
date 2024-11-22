#!/usr/bin/env bash

set -eo pipefail

export COLIMA_HOME="${COLIMA_HOME:-"${HOME}/.colima"}"
export DOCKER_HOST="unix://${COLIMA_HOME}/default/docker.sock"
