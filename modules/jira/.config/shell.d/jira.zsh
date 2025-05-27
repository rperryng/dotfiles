#!/usr/bin/env zsh

# Jira integration for zsh
# Provides fuzzy finder widget for Jira issues

JIRA_CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/jira/issues.txt"

# Populate cache file with jira issues
jira_populate_cache() {
  local temp_file="${JIRA_CACHE_FILE}.tmp"
  mkdir -p "$(dirname "$JIRA_CACHE_FILE")"

  if jira issues list --plain > "$temp_file"; then
    mv "$temp_file" "$JIRA_CACHE_FILE"
  else
    # Clean up temp file if API call failed
    rm -f "$temp_file"
    return 1
  fi
}

jira_read_cache() {
  if [[ -f "$JIRA_CACHE_FILE" ]]; then
    cat "$JIRA_CACHE_FILE"
  else
    jira_populate_cache
    cat "$JIRA_CACHE_FILE"
  fi
}

jira_refresh_cache_async() {
  (jira_populate_cache &)
}

# jira fuzzy issue picker
fzf-jira-issue-widget() {
  local issue_key
  issue_key=$(
    jira_read_cache \
      | fzf --header-lines=1 --reverse \
            --prompt="Select Jira issue: " \
            --header="Press CTRL-R to reload issues" \
            --bind 'ctrl-r:reload(jira issues list --plain)' \
      | awk '{print $2}'
  )

  if [[ -n "$issue_key" ]]; then
    LBUFFER="${LBUFFER}${issue_key}-"
  fi
  zle reset-prompt
  jira_refresh_cache_async  # Refresh cache in background
}
zle -N fzf-jira-issue-widget
bindkey '^X^J' fzf-jira-issue-widget
