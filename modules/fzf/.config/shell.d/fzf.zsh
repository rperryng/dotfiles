#!/usr/bin/env zsh

#
# FZF Configuration
#
export FZF_DEFAULT_OPTS="--height 70%"

if [ -x "$(command -v rg)" ]; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  export FZF_ALT_C_COMMAND='rg --files --hidden --follow --glob "!.git" | xargs dirname | sort -u'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

prepend_path "${XDG_OPT_HOME}/fzf/bin"

# Function that takes one argument and reads from STDIN
get_column_data() {
  # Read the header row from STDIN and split it into an array
  read -r header
  read -ra columns <<< "$header"

  # Find the index of the matching column name in the header array
  for (( i=1; i<${#columns[@]}; i++ )); do
    if [[ "${columns[$i]}" =~ "$1" ]]; then
      index=$i
      break
    fi
  done

  # Read the remaining rows from STDIN and extract the data for the matching column
  while read -r row; do
    # Extract the column data using awk and the index of the matching column
    column_data=$(echo "$row" | awk "{print \$${index+1}}")
    echo "$column_data"
  done
}

fzf_with_header() {
  local header
  read -r header

  local contents=$(cat)
  local pattern=$1

  echo $contents \
    | fzf --header="${header}" \
    | grep -oE "\\s${pattern}" \
    | head -1 \
    | grep -oE $pattern
}
