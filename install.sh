#!/usr/bin/env bash

set -e -o pipefail

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
export DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/.dotfiles}"

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
    grep -qi microsoft '/proc/version' && return 0
  fi

  return 1
}

setup_debian_prebuilt_mpr() {
  wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1> /dev/null
  echo "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
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
      setup_debian_prebuilt_mpr &&
        sudo apt update &&
        sudo apt install -y build-essential &&
        sudo apt install -y $pkgs
      ;;
    "fedora")
      sudo dnf groupinstall "Development Tools" &&
        sudo dnf install -y libxcrypt-compat util-linux-user $pkgs
      ;;
    "rhel")
      sudo yum groupinstall "Development Tools" &&
        sudo yum install -y $pkgs
      ;;
    "arch")
      echo "pacman"
      sudo pacman -S base-devel $pkgs
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
    "apt") sudo apt install -y $pkgs ;;
    "dnf") sudo dnf install -y $pkgs ;;
    "yum") sudo yum install -y $pkgs ;;
    "pacman") sudo pacman -S $pkgs ;;
    "brew")
      echo "brew installing: '${pkgs}'"
      # source "${DOTFILES_DIR}/modules/homebrew/.config/profile.d/homebrew.sh"
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
  echo "installing default packages"
  install_packages "stow"
  install_packages "zsh"
  install_packages "tldr"
  install_packages "ripgrep"
  install_packages "jq"
  install_packages "just"
  install_packages "unzip"
}

clone_dotfiles() {
  if [[ ! -d "${DOTFILES_DIR}" ]]; then
    # Clone this repo
    git clone "https://github.com/rperryng/dotfiles.git" ~/.dotfiles

    # Ensure repo is using the ssh remote
    pushd "${DOTFILES_DIR}" >/dev/null
    git remote set-url origin git@github.com:rperryng/dotfiles.git

    if [[ -n "${DOTFILES_BRANCH}" ]]; then
      echo "Checking out dotfiles branch: ${DOTFILES_BRANCH}"
      git checkout "${DOTFILES_BRANCH}"
    fi 

    popd >/dev/null
  fi
}

setup_default_shells() {
  if [[ "${SHELL}" =~ zsh ]]; then
    return 0
  fi

  local bash_path
  bash_path="$(which bash | head -1)"
  local zsh_path
  zsh_path="$(which zsh | head -1)"

  if [[ "${os_family}" == "macos" ]]; then
    # Add available shells
    ! grep -q "${bash_path}" /etc/shells && echo "${bash_path}/bin/bash" | sudo tee -a /etc/shells
    ! grep -q "${zsh_path}" /etc/shells && echo "${zsh_path}/bin/zsh" | sudo tee -a /etc/shells
  fi

  # Change default shell to zsh
  sudo chsh -s "$zsh_path" "${USER}"
}

main() {
  # Prompt for admin password upfront
  sudo -v

  # get OS family & preferred package manager
  os_family="$(get_os_family)"
  package_manager="$(get_package_manager)"

  # pre-setup steps
  install_prerequisites

  # clone the dotfiles (if needed)
  clone_dotfiles
  cd "$DOTFILES_DIR"

  # install things
  install_package_managers
  install_default_packages

  # configure dotfiles & shell
  setup_default_shells
  just stow

  # Install the user modules in a ZSH session, so that proper envs are loaded
  "${DOTFILES_DIR}/modules/install.zsh"

  # Start zsh
  echo "Starting zsh..."
  zsh
}

# Run the script
main "$@"
exit 0
