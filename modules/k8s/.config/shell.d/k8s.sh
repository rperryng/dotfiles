#!/usr/bin/env bash

# https://kubernetes.io/docs/reference/kubectl/cheatsheet

alias k="kubectl"
alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'
alias kna='kubectl get namespace --all-namespaces'

select_pod_name() {
  kubectl get pods --all-namespaces | fzf_with_header '([a-zA-Z0-9-]+)'
}

kubectl-pod-name-widget() {
  LBUFFER="${LBUFFER}$(select_pod_name)"
  local rcode=$?
  zle reset-prompt
  return $rcode
}
zle -N kubectl-pod-name-widget
bindkey '^X^K' kubectl-pod-name-widget
