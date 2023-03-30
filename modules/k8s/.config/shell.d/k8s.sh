#!/usr/bin/env bash

# https://kubernetes.io/docs/reference/kubectl/cheatsheet

alias k="kubectl"
alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'
alias kna='kubectl get namespace --all-namespaces'

kn_() {

}

function get_column_data() {
    # Read the first line of STDIN as the header
    read -r header
    
    # Split the header into an array based on whitespace
    read -ra columns <<< "$header"
    
    # Find the index of the matching column name
    for i in "${!columns[@]}"; do
        if [[ "${columns[$i]}" == "$1" ]]; then
            index=$i
            break
        fi
    done
    
    # Extract the data for the matching column and print it to STDOUT
    awk "{print \$${index+1}}" 
}

# Example usage:
# echo -e "Name\tAge\tCity\nAlice\t25\tNew York\nBob\t30\tSan Francisco\nCharlie\t40\tSeattle" | get_column_data "Age"

select_kube_pod_name() {
  kubectl get pods --all-namespaces | fzf_with_header '([a-zA-Z0-9-]+)'
}

select_kube_namespace() {
  # TODO: fix
  kubectl get namespace | fzf_with_header '^([a-zA-Z0-9-]+)'
}

function klogs() {
  local pod_name=$(select_kube_pod_name)
  if [[ -n "${pod_name}" ]]; then
    echo "pod_name is '${pod_name}'"
    kubectl logs $pod_name
    return
  fi

  false
}

kubectl-pod-name-widget() {
  LBUFFER="${LBUFFER}$(select_kube_pod_name)"
  local rcode=$?
  zle reset-prompt
  return $rcode
}
zle -N kubectl-pod-name-widget
bindkey '^X^K^P' kubectl-pod-name-widget

kubectl-namespace-widget() {
  LBUFFER="${LBUFFER}$(select_kube_namespace)"
  local rcode=$?
  zle reset-prompt
  return $rcode
}
zle -N kubectl-namespace-widget
bindkey '^X^K^N' kubectl-namespace-widget
