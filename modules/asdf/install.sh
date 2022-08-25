#!/usr/bin/env bash

set -e

ASDF_REPOSITORY_URL="https://github.com/asdf-vm/asdf.git"

export ASDF_DIR="${XDG_OPT_HOME:-$HOME/.local/opt}/asdf"
export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/tool-versions"

install() {
  if [[ -x "$(command -v asdf)" ]]; then
    return 0
  fi

  if [[ ! -d "${ASDF_DIR}" ]]; then
    latest_tag=$( \
      git \
        -c 'versionsort.suffix=-' \
        ls-remote --exit-code --refs --sort='version:refname' --tags ${ASDF_REPOSITORY_URL} '*.*.*' \
        | tail --lines=1 \
        | grep -E --only-matching 'v\d+\.\d+\.\d+' \
    )

    git clone \
      "${ASDF_REPOSITORY_URL}" "${ASDF_DIR}" \
      --branch "${latest_tag}"
  fi
}

ASDF_PLUGIN_NODEJS_URL="https://github.com/asdf-vm/asdf-nodejs.git"
install_nodejs() {
  if [[ ! -x $(command -v asdf) ]]; then
    echo "asdf not installed; cannot install nodejs"
    return 1;
  fi


  set +e
  asdf plugin list | grep --quiet 'nodejs'
  local return_code=$?
  set -e

  if [[ "${return_code}" -eq 0 ]]; then
    return 0;
  fi

  case ${DOTFILES_OS} in
    "macos") brew install gpg gawk ;;
    "debian") sudo apt install dirmngr gpg curl gawk ;;
    *) ;;
  esac

  asdf plugin add nodejs ${ASDF_PLUGIN_NODEJS_URL}
  asdf nodejs update-nodebuild
  asdf install nodejs
}

ASDF_PLUGIN_RUBY_URL="https://github.com/asdf-vm/asdf-ruby.git"
install_ruby() {
  if [[ ! -x $(command -v asdf) ]]; then
    echo "asdf not installed; cannot install ruby"
    return 1;
  fi

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
      sudo apt install \
        autoconf bison build-essential libssl-dev libyaml-dev  \
        libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6  \
        libgdbm-dev libdb-dev uuid-dev
      ;;
    *) ;;
  esac

  asdf plugin add ruby ${ASDF_PLUGIN_RUBY_URL}
  asdf install ruby
}

install_python() {
  if [[ ! -x $(command -v asdf) ]]; then
    echo "asdf not installed; cannot install python"
    return 1;
  fi

  set +e
  asdf plugin list | grep --quiet python
  local return_code=$?
  set -e

  if [[ "${return_code}" -eq 0 ]]; then
    return 0;
  fi

  asdf plugin-add python
  asdf install python
}

install
install_nodejs
install_ruby
install_python
