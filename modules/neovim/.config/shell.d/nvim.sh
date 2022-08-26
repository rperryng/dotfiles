#!/usr/bin/env bash

random_number() {
  echo $((1 + $RANDOM % 10))
}

nstart() {
  # ensure the neovim server starts at a specified address so ':termina'
  # commands can communicate with the host `nvim` process.
  local rand=$(echo $((1 + $RANDOM % 100000000)))
  local socket_name="/tmp/nvimsocket.${rand}"

  export DOTFILES_NVIM_LISTEN_ADDRESS=$socket_name
  nvim --listen $socket_name "$@"
}

# Set $EDITOR to the host neovim process if this terminal session was started
# from a neovim ':terminal' session.
if [ -n "$DOTFILES_NVIM_LISTEN_ADDRESS" ]; then
  export VISUAL="nvr --remote-wait +'setlocal bufhidden=wipe'"
  export NVIM_LISTEN_ADDRESS=$DOTFILES_NVIM_LISTEN_ADDRESS
  alias nvim="nvr"
  alias n="nvr"
  alias nstart="echo 'Already in a neovim session'"
else
  export VISUAL=nvim
  alias nv="nvim"
  alias n="nvim"
  alias nstart="clear; nvim +'call NNStart()'"
fi

export EDITOR="$VISUAL"
