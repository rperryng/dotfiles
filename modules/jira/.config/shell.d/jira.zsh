#!/usr/bin/env zsh

# Jira integration for zsh
# Provides fuzzy finder widget for Jira issues

# jira fuzzy issue picker
fzf-jira-issue-widget() {
  local issue_key
  issue_key=$(
    ,jira-list-issues \
      | fzf \
        --reverse \
        --header-lines=1 \
        --prompt="Select Jira issue: " \
        --header="Press CTRL-R to reload issues" \
        --bind 'ctrl-r:reload:
          ,jira-list-issues --no-cache
        ' \
      | awk '{print $2}'
  )

  if [[ -n "$issue_key" ]]; then
    LBUFFER="${LBUFFER}${issue_key}-"
  fi
  zle reset-prompt
}
zle -N fzf-jira-issue-widget
bindkey '^X^J' fzf-jira-issue-widget
