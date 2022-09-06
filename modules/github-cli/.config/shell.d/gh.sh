#!/usr/bin/env sh

if command -v gh &> /dev/null; then
  clone() {
    cat "${HOME}/.cache/clone_urls.txt" | \
      fzf --multi | \
      xargs -I{} git -C "$HOME/code" clone {}

    gh api /user/repos --paginate | \
      jq -r '.[] | .ssh_url' > \
      "${HOME}/.cache/clone_urls.txt" &
  }
fi

# Open the PR page for the current branch.
function gh_openpr() {
  if gh pr view --json url 1> /dev/null; then
    gh pr view --web
  else
    gh pr create --web
  fi
}

alias open-pr="gh_openpr"

alias ghrw="gh run watch -i1"
alias ghrvw="gh run view --web"
alias ghprvw="gh pr view --web"
