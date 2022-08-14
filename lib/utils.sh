#
# Sources files in a glob
#
# examples:
#   source_files_in ${XDG_CONFIG_HOME}/profile.d/*.sh
#
source_files_in() {
  for file in "$@"; do
    if [[ -n "$PROFILE_STARTUP" ]]; then
      # eval function name for profiling
      fn=$(basename "$file")
      eval "$fn() { source_file $file }; $fn"
    else
      source "$file"
    fi
  done

  unset file
}
