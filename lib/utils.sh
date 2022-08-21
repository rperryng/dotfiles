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
      eval "$fn() { source $file }; $fn"
    else
      source "$file"
    fi
  done

  unset file
}

#
# Prepends a path to the path variable (avoiding duplicates)
#
# usage:
#   prepend_path [path_to_prepend]
#   prepend_path [first_path] [second_path]
#
# examples:
#   prepend_path "/some/path"
#   # PATH="/some/path:/usr/bin:/bin"
#
#   prepend_path "/path/abc" "/path/xyz"
#   # PATH="/path/abc:/path/xyz:/usr/bin:/bin"
#
function prepend_path() {
  local i
  local paths=("$1")
  for ((i = $#; i > 0; i--)); do
    arg=${paths[i]}
    if [ -d "$arg" ] && [[ ":$PATH:" != *":$arg:"* ]]; then
      PATH="$arg${PATH:+":$PATH"}"
    fi
  done
}

#
# Appends paths to the path variable (avoiding duplicates)
#
# usage:
#   append_path [path_to_append]
#   append_path [first_path] [second_path]
#
# examples:
#   append_path "/some/path"
#   # PATH="/usr/bin:/bin:/some/path"
#
#   append_path "/path/abc" "/path/xyz"
#   # PATH="/usr/bin:/bin:/path/abc:/path/xyz"
#
function append_path() {
  local arg
  for arg in "$@"; do
    if [ -d "$arg" ] && [[ ":$PATH:" != *":$arg:"* ]]; then
      PATH="${PATH:+"$PATH:"}$arg"
    fi
  done
}

get_os_family() {
  if [ -f '/proc/version' ] && grep -qi microsoft '/proc/version'; then
    # TODO: Change to wsl?
    echo 'debian'
    return
  fi

  # ideally we would use an associative array here
  # but this needs to work in bash < v4 for macos
  os_info=(
    "/proc/auto_master::macos"
    "/etc/auto_master::macos"
    "/etc/debian_version::debian"
    "/etc/fedora-release::fedora"
    "/etc/redhat-release::rhel"
    "/etc/arch-release::arch"
    "/etc/alpine-release::alpine"
  )
  for kv in "${os_info[@]}"; do
    key="${kv%%::*}"
    val="${kv##*::}"
    [[ -f "$key" ]] && os_family="${val}"
  done
  echo "${os_family}"
}
export DOTFILES_OS="$(get_os_family)"

get_package_manager() {
  if [[ -n "$DOTFILES_INSTALL_PACKAGE_MANAGER" ]]; then
    echo "$DOTFILES_INSTALL_PACKAGE_MANAGER"
  else
    case ${DOTFILES_OS} in
      "macos") echo "brew" ;;
      "debian") echo "apt" ;;
      "fedora") echo "dnf" ;;
      "rhel") echo "yum" ;;
      "arch") echo "pacman" ;;
      *) ;;
    esac
  fi
}
export DOTFILES_PKG_MGR=$(get_package_manager)

install_packages() {
  local pkgs="$1"

  # Ensure $pkgs is word split by space when running in zsh
  [ -n "${ZSH_VERSION:-}" ] && set -A pkgs ${=pkgs}

  case ${DOTFILES_PKG_MGR} in
    "apt") sudo apt install -y $pkgs ;;
    "brew")
      echo "brew not ported yet"
      exit 1

      # source "${DOTFILES_DIR}/modules/homebrew/.config/profile.d/homebrew.sh"
      # # shellcheck disable=SC2086
      # brew install $pkgs
      ;;
    "nix")
      source "${DOTFILES_DIR}/modules/nix/.config/profile.d/nix.sh"
      nix_pkgs=("$pkgs")
      # shellcheck disable=SC2068
      for pkg in ${nix_pkgs[@]}; do
        nix-env -iA nixpkgs."$pkg"
      done
      ;;
    *) ;;
  esac
}
