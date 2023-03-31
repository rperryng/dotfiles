#!/usr/bin/env bash

# https://kubernetes.io/docs/reference/kubectl/cheatsheet

alias k="kubectl"
alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'
alias kna='kubectl get namespace --all-namespaces'

#!/bin/bash

function split_double_spaces() {
    local input="$1"
    local result="$(echo "$input" | sd '  +' '|' | tr '|' '\n')"
    echo "$result"
}

# This function extracts a specified column from an input table, where columns are separated by two or more spaces.
# The function takes one argument: the column name (case-insensitive).
# The input table should be provided through STDIN, and the output will be printed to STDOUT.
# Usage example:
#  k get pods | extract_column "name"
extract_column() {
  col_name="$1"

  # Read the header and find the starting index of the column
  read -r header
  start_index=$(echo "$header" | awk -v name="$col_name" -F "  +" '{ for (i = 1; i <= NF; i++) { if (tolower($i) == tolower(name)) { print index($0, $i); exit; } } }')

  # Calculate the ending index of the column using heredoc
  end_index=$(echo "$header" | awk -v start="$start_index" -v name="$col_name" -F "  +" "$(cat << 'EOF'
BEGIN { FS="  +" }
{
  for (i = 1; i <= NF; i++) {
    if (tolower($i) == tolower(name)) {
      if (i < NF) { # If the column is not the last one
        next_col_start = index($0, $(i+1)); # Find the starting index of the next column
        print next_col_start - 2; # Set the end_index to the next column's starting index minus 2
      } else { # If the column is the last one
        print length($0); # Set the end_index to the length of the header
      }
      exit;
    }
  }
}
EOF
)")

  # Extract the specified column from each row
  while read -r line; do
    echo "$line" | cut -c "${start_index}-${end_index}"
  done
}

# Example usage:
# cat /tmp/k_pods_sample.json | ./script.sh extract_column_data "NAME"
# cat /tmp/k_pods_sample.json | ./script.sh extract_column_data "STATUS"

# Example usage:
# echo "$table_data" | extract_column_data "NAME"
# echo "$table_data" | extract_column_data "STATUS"

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
