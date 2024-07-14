#!/usr/bin/env bash

n_legacy() {
  NVIM_APPNAME="" nvim
}

# nstart() {
#   if [[ -n $DOTFILES_NVIM_LISTEN_ADDRESS ]]; then
#     echo 'Already in a neovim session'
#     return 1
#   fi
#
#   # ensure the neovim server starts at a specified address so ':terminal'
#   # commands can communicate with the host 'nvim' process.
#   local rand=$(echo $((1 + $RANDOM % 100000000)))
#   local socket_name="/tmp/nvimsocket.${rand}"
#
#   clear
#
#   ( \
#     DOTFILES_NVIM_LISTEN_ADDRESS="$socket_name" \
#     nvim \
#       --listen "$socket_name" \
#       +'call NStart()' \
#   )
# }
#
# n() {
#   if [[ -n "$DOTFILES_NVIM_LISTEN_ADDRESS" ]]; then
#     nvr $@
#   else
#     nvim $@
#   fi
# }
#
# if [[ -n "$DOTFILES_NVIM_LISTEN_ADDRESS" ]]; then
#   # Set $EDITOR to the host neovim process if this terminal session was started
#   # from a neovim ':terminal' session.
#   export NVIM_LISTEN_ADDRESS=$DOTFILES_NVIM_LISTEN_ADDRESS
#   export VISUAL="nvr --remote-wait +'setlocal bufhidden=wipe'"
#   alias nvim="nvr"
# else
#   # Otherwise, just point to regular ol' nvim
#   export VISUAL=nvim
# fi
#
# export EDITOR="$VISUAL"
