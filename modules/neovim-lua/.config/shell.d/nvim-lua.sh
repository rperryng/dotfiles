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

  # ensure the neovim server starts at a specified address so ':terminal'
  # commands can communicate with the host 'nvim' process.
  local rand=$(echo $((1 + $RANDOM % 100000000)))
  local socket_name="/tmp/nvimsocket.${rand}"

  local args="+NStart"
  if [ $# -gt 0 ]; then
    args="$@"
  fi

  ( \
    DOTFILES_NVIM_LISTEN_ADDRESS="$socket_name" \
    nvim \
      --listen "$socket_name" \
      $args \
  )
}

# use as pager
nman() {
  if [[ -z $@ ]]; then
    echo 'usage: nman [man options] [[section] page ...] ...' 1>&2
    return 1
  fi

  local tmp_dir
  tmp_dir=$(mktemp "/tmp/man.$1.tmp.XXXXXXXXXX")
  man "$@" | cat > "$tmp_dir"

  if [[ -n "$DOTFILES_NVIM_LISTEN_ADDRESS" ]]; then
    local editor_no_wait
    editor_no_wait=$(echo "$EDITOR" | sd '(.+) --remote-wait (.+)' '$1 $2')
    eval $editor_no_wait -cc split "+'setlocal nomodifiable nonumber'" "$tmp_dir"
  else
    eval $EDITOR "+'setlocal nomodifiable nonumber'" "$tmp_dir"
  fi
}

# Setup $EDITOR / $VISUAL
if [[ -n "$DOTFILES_NVIM_LISTEN_ADDRESS" ]]; then
  # Set $EDITOR to the host neovim process if this terminal session was started
  # from a neovim ':terminal' session.
  export NVIM_LISTEN_ADDRESS=$DOTFILES_NVIM_LISTEN_ADDRESS
  export VISUAL="nvr --remote-wait +'setlocal bufhidden=wipe'"
  alias nvim="nvr"
else
  # Otherwise, just point to regular ol' nvim
  export VISUAL=nvim
fi

export EDITOR="$VISUAL"
