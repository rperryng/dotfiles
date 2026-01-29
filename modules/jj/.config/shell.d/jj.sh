#!/usr/bin/env zsh

# jj fuzzy bookmark picker
fzf-jj-bookmark-widget() {
  local bookmark
  bookmark=$(
    jj bookmark list \
      --template 'name ++ "\n"' \
      --sort author-date- \
      | uniq \
      | fzf --height 40% --reverse --prompt="Select bookmark: "\
  )

  if [[ -n "$bookmark" ]]; then
    LBUFFER="${LBUFFER}${bookmark} "
  fi
  zle reset-prompt
}
zle -N fzf-jj-bookmark-widget
bindkey '^B' fzf-jj-bookmark-widget

# jj moves tracked bookmarks automatically when running fetch.
# in git, 'fetch' will only update remote references, not update local branch pointers.
alias jjgf="jj git fetch"

alias jjnew="jj new 'trunk()'"
alias jjl="jj log --limit 10 --revisions '..'"
# just more comfortable to press...
alias jjt="jjl"
alias jjlc="jj log --template builtin_log_compact"
alias jjic="jj git init --colocate"
alias jjlo="jj log --limit 10"
alias jjloa="jj log --revisions '@ | root() | bookmarks()'"
alias jjps="jj git push"
alias jjst="jj status"
alias jjtp="jj tug && jj git push"
alias jjdm="jj describe --message"
alias jjs="jj squash"

jjbm() {
  jj bookmark list \
    --revisions "closest_bookmark(@)" \
    --template "name "
}

jjpsu() {
  local bookmark
  bookmark=$(jjbm)

  if [[ -z "$bookmark" ]]; then
    echo "Error: Could not resolve closest bookmark"
    return 1
  fi

  jj bookmark track "${bookmark}" 2>/dev/null || true
  jj git push --bookmark "$bookmark"
}

jjpr() {
  local rev="${1:-"closest_bookmark(@)"}"
  local bookmark="$(
    jj bookmark list \
      --tracked \
      --template "if(tracking_present, name)" \
      --revisions "${rev}"\
  )"

  if gh pr view --json url "$bookmark" 1> /dev/null; then
    gh pr view --web "$bookmark"
  else
    gh pr create --web --head "$bookmark"
  fi
}

# "jj deref"
alias jjdr="get_tracking_branch"
get_tracking_branch() {
  local rev="${1:-@}"
  jj bookmark list --tracked --template "if(tracking_present, name)" --revisions "${rev}" \
    || die "Failed to get tracking branch"
}

jjlor() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: nlor <rev>"
    return 1
  fi

  local rev=$1
  local fork="fork_point(trunk() | $rev)"
  jj log --revisions "$fork::trunk() | $fork::$rev"
}

jjrun() {
  local bookmark
  bookmark=$(jjbm)

  if [[ -z "$bookmark" ]]; then
    echo "Error: Could not resolve closest bookmark"
    return 1
  fi

  gh run view --branch "$bookmark" "$@"
}
