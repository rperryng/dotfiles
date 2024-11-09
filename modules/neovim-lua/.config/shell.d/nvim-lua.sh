#!/usr/bin/env bash

# Use the config in ~/.config/nvim/nvim-lua
export NVIM_APPNAME='nvim-lua'

n() {
  if [[ -n "$DOTFILES_NVIM_LISTEN_ADDRESS" ]]; then
    if [ $# -eq 0 ]; then
      echo "Already in a neovim terminal; can't run 'n' without an argument"
    else
      nvr $@
    fi

    return
  fi

  local args=""
  if [[ $# -gt 0 ]]; then
    args="$@"
  elif [[ "$(pwd)" == "$HOME" || "$(pwd)" == "$DOTFILES_DIR" ]]; then
    args="+NStart"
  fi

  # ensure the neovim server starts at a specified address so ':terminal'
  # commands can communicate with the host 'nvim' process.
  local rand=$(echo $((1 + $RANDOM % 100000000)))
  local socket_name="/tmp/nvimsocket.${rand}"

  (
    DOTFILES_NVIM_LISTEN_ADDRESS="$socket_name" \
      nvim \
      --listen "$socket_name" \
      $args
  )
}

# Setup $EDITOR / $VISUAL / $MANPAGER
if [[ -n "$DOTFILES_NVIM_LISTEN_ADDRESS" ]]; then
  # If running within a neovim `:terminal` process, open things in the
  # host neovim process rather than a nested neovim session
  export NVIM_LISTEN_ADDRESS=$DOTFILES_NVIM_LISTEN_ADDRESS
  export MANPAGER="nvr -c 'Man!' -o -"
  export VISUAL="nvr --remote-wait +'setlocal bufhidden=wipe'"
  alias nvim="nvr"
else
  # Otherwise, just point to regular ol' nvim
  export MANPAGER='nvim +Man!'
  export VISUAL=nvim
fi

export EDITOR="$VISUAL"

# `man` will pre-format manpage using `groff`.
# We want line-wraps to be handled by neovim, so "disable" hard-wraps.
# see: ':h Man'
export MANWIDTH=999
