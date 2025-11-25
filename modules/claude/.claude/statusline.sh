#!/usr/bin/env bash

# Read JSON from stdin
read -r json

# Extract values from JSON
model=$(echo "$json" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$json" | jq -r '.workspace.current_dir // .cwd // "unknown"' | sed "s|^$HOME|~|")

# Get context usage percentage
usage_pct=$(echo "$json" | jq -r '.context_window.used_percentage // 0')

GREEN='\033[38;2;0;255;0m'
ORANGE='\033[38;2;255;165;0m'
LIGHT_RED='\033[38;2;255;100;100m'

# Set color based on usage percentage
if [ "$usage_pct" -lt 25 ]; then
  color_code="$GREEN"
elif [ "$usage_pct" -lt 50 ]; then
  color_code="$ORANGE"
else
  color_code="$LIGHT_RED"
fi

context_display=" (${usage_pct}%)"

# Get git branch
if git rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null || echo "no branch")
else
  branch="no git"
fi

# Output status line
printf "👤 %b%s%s\033[0m | 📁 \033[97m%s\033[0m | 🌳 \033[38;2;0;206;200m%b\033[0m\n" "$color_code" "$model" "$context_display" "$cwd" "$branch"
