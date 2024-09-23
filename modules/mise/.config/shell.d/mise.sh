#!/usr/bin/env bash

CARGO_HOME="${XDG_CONFIG_HOME}/.cargo"
MISE_CONFIG_FILE="${XDG_CONFIG_HOME}/mise/config.toml"

if [[ -d "${CARGO_HOME}/bin" ]]; then
  prepend_path "${CARGO_HOME}/bin"
fi

eval "$("${CARGO_HOME}/bin/mise" activate)"

mise_tool_version() {
  local tool_name
  tool_name=$1
  yq ".tools.${tool_name}" "${MISE_CONFIG_FILE}"
}

mise_python3_version() {
  mise_tool_version "python"
}
