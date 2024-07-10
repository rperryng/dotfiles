#!/usr/bin/env bash

set -e

export ASDF_REPOSITORY_URL="https://github.com/asdf-vm/asdf.git"
export ASDF_DIR="${XDG_OPT_HOME:-$HOME/.local/opt}/asdf"
export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/tool-versions"

install() {
  if [[ ! -d "${ASDF_DIR}" ]]; then
    latest_tag=$( \
      git \
        -c 'versionsort.suffix=-' \
        ls-remote --exit-code --refs --sort='version:refname' --tags ${ASDF_REPOSITORY_URL} 'v*.*.*' \
        | tail --lines=1 \
        | cut -d '/' -f 3
    )

    git clone \
      "${ASDF_REPOSITORY_URL}" "${ASDF_DIR}" \
      --branch "${latest_tag}"

    source "${ASDF_DIR}/asdf.sh"
  fi
}

ASDF_PLUGIN_NODEJS_URL="https://github.com/asdf-vm/asdf-nodejs.git"
install_nodejs() {
  set +e
  asdf plugin list | grep --quiet 'nodejs'
  local return_code=$?
  set -e

  if [[ "${return_code}" -eq 0 ]]; then
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos") brew install gpg gawk ;;
    "debian") sudo apt install -y dirmngr gpg curl gawk ;;
    *) ;;
  esac

  asdf plugin add nodejs ${ASDF_PLUGIN_NODEJS_URL}
  asdf nodejs update-nodebuild
  asdf install nodejs
}

ASDF_PLUGIN_RUBY_URL="https://github.com/asdf-vm/asdf-ruby.git"
install_ruby() {
  set +e
  asdf plugin list | grep --quiet ruby
  local return_code=$?
  set -e

  if [[ "${return_code}" -eq 0 ]]; then
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos")
      brew install openssl@1.1 readline libyaml
      export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
      ;;
    "debian")
      sudo apt install -y \
        autoconf patch build-essential rustc libssl-dev libyaml-dev \
        libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev \
        libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
      ;;
    *) ;;
  esac

  asdf plugin add ruby ${ASDF_PLUGIN_RUBY_URL}
  asdf install ruby
}

install_python() {
  set +e
  asdf plugin list | grep --quiet python
  local return_code=$?
  set -e

  if [[ "${return_code}" -eq 0 ]]; then
    return 0;
  fi

  asdf plugin add python
  asdf install python
}

ASDF_PLUGIN_ALIAS_URL="https://github.com/andrewthauer/asdf-alias.git"
install_alias() {
  set +e
  asdf plugin list | grep --quiet alias
  local return_code=$?
  set -e

  if [[ "${return_code}" -eq 0 ]]; then
    return 0;
  fi

  asdf plugin-add alias $ASDF_PLUGIN_ALIAS_URL
}

install_neovim() {
  set +e
  asdf plugin list | grep --quiet neovim
  local return_code=$?
  set -e

  if [[ "${return_code}" -eq 0 ]]; then
    return 0;
  fi

  asdf plugin add neovim
  asdf install neovim
}

install_just() {
  set +e
  asdf plugin list | grep --quiet just
  local return_code=$?
  set -e

  if [[ "${return_code}" -eq 0 ]]; then
    return 0;
  fi

  asdf plugin add just
  asdf install just

  if [[ $(which just) != *"asdf"* ]]; then
    echo "current 'just' distribution not from asdf - attempting to uninstall current 'just' $(which just)"

    case ${DOTFILES_OS} in
      "macos")
        brew uninstall just
        ;;
      "debian")
        sudo apt remove just
        ;;
      *)
        echo "OS family: '${DOTFILES_OS}' not supported"
        exit 1
        ;;
    esac
  fi
}

install

if [[ ! -x $(command -v asdf) ]]; then
  echo "asdf not installed; cannot install asdf plugins"
  exit 1;
fi

install_alias
install_nodejs
install_ruby
install_python
install_neovim
install_just
