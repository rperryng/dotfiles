#!/usr/bin/env zsh

ASDF_REPOSITORY_URL="https://github.com/asdf-vm/asdf.git"

export ASDF_DIR="${XDG_OPT_HOME:-$HOME/.local/opt}/asdf"
export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/asdfrc"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/tool-versions"

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

ASDF_PLUGIN_NODEJS_URL="https://github.com/asdf-vm/asdf-nodejs.git"
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

ASDF_PLUGIN_RUBY_URL="https://github.com/asdf-vm/asdf-ruby.git"
install_ruby() {
  case ${DOTFILES_OS} in
    "macos")
      install_packages openssl@1.1 readline libyaml
      export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
      ;;
    "debian")
      install_packages \
        'autoconf bison build-essential libssl-dev libyaml-dev ' \
        'libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 ' \
        'libgdbm-dev libdb-dev uuid-dev'
      ;;
    *) ;;
  esac

  asdf plugin add ruby ${ASDF_PLUGIN_RUBY_URL}
  asdf install ruby
  # TODO: add default-gems
}

install_python() {
  asdf plugin-add python
  asdf install python
}

install
install_nodejs
install_ruby
install_python
