#!/usr/bin/env zsh

export JJ_CONFIG="${XDG_CONFIG_HOME}/jj/config.toml"

# jj fuzzy bookmark picker
fzf-jj-bookmark-widget() {
  local bookmark
  bookmark=$(
    jj bookmark list \
      --template 'name ++ "\n"' \
      --sort author-date- \
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

alias jjst="jj status"
alias jjl="jj log"
alias jjlo="jj log -n 6"
alias jjloa="jj log -r '@ | root() | bookmarks()'"
alias jjew="jj new 'trunk()'"
alias jjps="jj git push"

jjpr() {
  local rev="${1:-@}"
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

# jj "bookmark update"
jjbu() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: jjbu <bookmark_revision> <destination_revision>" >&2
    return 1
  fi

  local bookmark_rev="${1}"
  local destination_rev="${2}"

  local bookmark_name
  bookmark_name=$(jj bookmark list --template "name" --revisions "${bookmark_rev}" | head -1)
  if [[ -z "$bookmark_name" ]]; then
    echo "Error: No bookmark found for revision ${bookmark_rev}" >&2
    return 1
  fi

  # Update bookmark
  jj bookmark set "${bookmark_name}" -r "${destination_rev}"
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
