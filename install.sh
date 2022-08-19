#!/usr/bin/env bash

set -e -o pipefail

DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/.dotfiles}"
DOTFILES_INSTALL_USE_SUDO="${DOTFILES_INSTALL_USE_SUDO:-0}"

# XDG configuration
# - https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Non-standard
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_LIB_HOME="${XDG_LIB_HOME:-$HOME/.local/lib}"
export XDG_OPT_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}"

# Get the appropriate package manager script
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

get_os_family

function is_wsl() {
  if [[ -f '/proc/version' ]]; then
    grep -qi microsoft '/proc/version' && return
  fi

  false
}

install_prerequisites() {
  local pkgs="curl file git"

  case ${os_family} in
    "macos")
      if [[ ! -d "$(xcode-select -p)" ]]; then
        xcode-select --install
      else
        echo "xcode command line tools installed"
      fi
      ;;
    "debian")
      $sudo_cmd apt update &&
        $sudo_cmd apt install -y build-essential &&
        $sudo_cmd apt install -y $pkgs
      ;;
    "fedora")
      $sudo_cmd dnf groupinstall "Development Tools" &&
        $sudo_cmd dnf install -y libxcrypt-compat util-linux-user $pkgs
      ;;
    "rhel")
      $sudo_cmd yum groupinstall "Development Tools" &&
        $sudo_cmd yum install -y $pkgs
      ;;
    "arch")
      echo "pacman"
      $sudo_cmd pacman -S base-devel $pkgs
      ;;
    *)
      echo "OS family: '${os_family}' not supported"
      exit 1
      ;;
  esac
}

get_package_manager() {
  if [[ -n "$DOTFILES_INSTALL_PACKAGE_MANAGER" ]]; then
    echo "$DOTFILES_INSTALL_PACKAGE_MANAGER"
  else
    case ${os_family} in
      "macos") echo "brew" ;;
      "debian") echo "apt" ;;
      "fedora") echo "dnf" ;;
      "rhel") echo "yum" ;;
      "arch") echo "pacman" ;;
      *) ;;
    esac
  fi
}

install_package_managers() {
  case ${os_family} in
    "macos")
      # Always install homebrew on macos
      "${DOTFILES_DIR}/modules/homebrew/install.sh"
      brew install "$pkgs"
      ;;
    *) ;;
  esac

  if [[ "${package_manager}" == "nix" ]]; then
    "${DOTFILES_DIR}/modules/nix/install.sh"
  fi
}

install_packages() {
  local pkgs="$1"

  case ${package_manager} in
    "apt") $sudo_cmd apt install -y $pkgs ;;
    "dnf") $sudo_cmd dnf install -y $pkgs ;;
    "yum") $sudo_cmd yum install -y $pkgs ;;
    "pacman") $sudo_cmd pacman -S $pkgs ;;
    "brew")
      source "${DOTFILES_DIR}/modules/homebrew/.config/profile.d/homebrew.sh"
      # shellcheck disable=SC2086
      brew install $pkgs
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

install_default_packages() {
  install_packages "stow"
  install_packages "zsh"
  install_packages "tldr"
  install_packages "jq"
  install_packages "unzip"

  modules/starship/install.zsh
  modules/fzf/install.zsh
  modules/nvim/install.zsh
  modules/zsh-autosuggestions/install.zsh
  modules/zsh-syntax-highlighting/install.zsh
  modules/rg/install.zsh
}

clone_dotfiles() {
  if [[ ! -d "${DOTFILES_DIR}" ]]; then
    # Clone this repo
    git clone "https://github.com/rperryng/dotfiles.git" ~/.dotfiles

    # Ensure repo is using the ssh remote
    pushd "${DOTFILES_DIR}" >/dev/null
    git remote set-url origin git@github.com:rperryng/dotfiles.git

    # TODO: Remove this
    git checkout ezsetup
    popd >/dev/null
  fi
}

setup_default_shells() {
  local bash_path
  bash_path="$(which bash | head -1)"
  local zsh_path
  zsh_path="$(which zsh | head -1)"

  if [[ "${os_family}" == "macos" ]]; then
    # Add available shells
    ! grep -q "${bash_path}" /etc/shells && echo "${bash_path}/bin/bash" | $sudo_cmd tee -a /etc/shells
    ! grep -q "${zsh_path}" /etc/shells && echo "${zsh_path}/bin/zsh" | $sudo_cmd tee -a /etc/shells
  fi

  # Change default shell to zsh
  chsh -s "$zsh_path"
}

main() {
  # Prompt for admin password upfront
  # sudo -v

  # sudo command
  sudo_cmd=""
  [[ "$DOTFILES_INSTALL_USE_SUDO" -eq 1 ]] && sudo_cmd="sudo "

  # get OS family & preferred package manager
  os_family="$(get_os_family)"
  package_manager="$(get_package_manager)"

  # pre-setup steps
  install_prerequisites

  # clone the dotfiles (if needed)
  clone_dotfiles
  cd "$DOTFILES_DIR"

  # install packages
  install_package_managers
  install_default_packages

  # configure dotfiles & shell
  setup_default_shells
  make

  # Start zsh
  echo "Starting zsh ..."
  echo "Install modules from ${DOTFILES_DIR}/install"
  zsh
}

# Run the script
main "$@"
exit 0
