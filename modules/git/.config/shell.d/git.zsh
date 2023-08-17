#!/usr/bin/env zsh

set +e

git_push_and_open_pr() {
  local branch_name
  branch_name=$(git symbolic-ref --short -q HEAD)
  git push --set-upstream origin "${branch_name}"
  gh pr create --web
}
alias rnti="git_push_and_open_pr"
