#!/usr/bin/env zsh

ASDF_REPOSITORY_URL="https://github.com/asdf-vm/asdf.git"
ASDF_PLUGIN_NODEJS_URL="https://github.com/asdf-vm/asdf-nodejs.git"

export ASDF_DIR="${XDG_OPT_HOME:-$HOME/.local/opt}/asdf"
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME}/asdf/tool-versions"

install() {
  latest_tag=$( \
    git -c 'versionsort.suffix=-' \
      ls-remote --exit-code --refs --sort='version:refname' --tags ${ASDF_REPOSITORY_URL} '*.*.*' \
      | tail --lines=1 \
      | cut --delimiter='/' --fields=3 \
  )

  git clone \
    "${ASDF_REPOSITORY_URL}" "${ASDF_DIR}" \
    --branch "${latest_tag}"
}

install_nodejs() {
  case ${DOTFILES_OS} in
    "macos") install_packages 'gpg gawk' ;;
    "debian") install_packages 'dirmngr gpg curl gawk' ;;
    *) ;;
  esac

  asdf plugin add nodejs ${ASDF_PLUGIN_NODEJS_URL}
  asdf nodejs update-nodebuild
  asdf install nodejs 16.17.0
}

install
install_nodejs
