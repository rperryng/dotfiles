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

function gh_rate_limit() {
  # Set timezone to EST for Toronto
  TZ="America/Toronto"

  # Get the rate limit information from GitHub
  json_output=$(
    gh api \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      /rate_limit
    )

  # Use jq to parse the JSON and extract the required information
  echo "GraphQL Rate Limit Information:"
  echo "$json_output" | jq '.resources.graphql'

  echo "Core (REST API) Rate Limit Information:"
  echo "$json_output" | jq '.resources.core'

  echo "Current Time:                 $(date)"
  echo "GraphQL Rate Limit Resets At: $(date -r $(echo "$json_output" | jq '.resources.graphql.reset'))"
  echo "Core Rate Limit Resets At:    $(date -r $(echo "$json_output" | jq '.resources.core.reset'))"
}

gh_rate_limit_watch() {
  while true; do
    echo "-----"
    gh_rate_limit
    sleep 10
  done
}

alias open-pr="gh_openpr"

alias ghrw="gh run watch -i1"
alias ghrvw="gh run view --web"
alias ghprvw="gh pr view --web"

ghrwn() {
  gh run watch -i1
  say "done $(basename $(git rev-parse --show-toplevel))"
}
