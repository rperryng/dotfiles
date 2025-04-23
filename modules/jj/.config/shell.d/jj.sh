#!/usr/bin/env zsh

export JJ_CONFIG="${XDG_CONFIG_HOME}/jj/config.toml"

# n on colemak matches where j is on qwerty
alias nn="jj"
alias nlo="nn log"

fzf-jj-bookmark-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local bookmark
  bookmark=$(jj bookmark list --template 'name ++ "\n"' | fzf --height 40% --reverse --prompt="Select bookmark: ")
  if [[ -n "$bookmark" ]]; then
    LBUFFER="${LBUFFER}${bookmark} "
  fi
  zle reset-prompt
}

# Bind the function to ctrl-b
zle -N fzf-jj-bookmark-widget
bindkey '^B' fzf-jj-bookmark-widget

# jj moves tracked bookmarks automatically when running fetch.
# in git, 'fetch' will only update remote references, not update local branch pointers.
alias npl="jj git fetch"
alias ngf="jj git fetch"
alias nlo="jj log -n 6"
alias nloa="jj log -r '@ | root() | bookmarks()'"
alias nnew="jj new 'trunk()'"

get_tracking_branch() {
  local rev="${1:-@}"
  jj bookmark list --tracked --template "if(tracking_present, name)" --revisions "${rev}" \
    || die "Failed to get tracking branch"
}

nlor() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: nlor <rev>"
    return 1
  fi

  local rev=$1
  local fork="fork_point(trunk() | $rev)"
  jj log --revisions "$fork::trunk() | $fork::$rev"
}

open_pr() {
  # TODO...
  revision="@"
  jj git push --change "${revision}" || die "Failed to push changes"

  local branch
  branch=$(get_tracking_branch "${revision}") || die "Failed to get branch after push"
  [ -z "${branch}" ] && die "No branch created after push"

  gh pr create --web "${branch}" \
    || die "Failed to create PR for branch '${branch}'"

  echo "Successfully created$([ "${draft}" = "true" ] && echo " draft") PR for branch '${branch}'"
}
