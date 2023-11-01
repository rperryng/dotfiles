home := env_var('HOME')
dotfiles_dir := home + '/.dotfiles'
bogus_links_path := dotfiles_dir + '/.stow-bogus-links'
modules_dir := dotfiles_dir + '/modules'
module_names := `ls -d ./modules/*/ | sed "s|./modules||" | sed "s|/||g" | tr "\n" " "`

# XDG directories
export XDG_CONFIG_HOME := home + '/.config'
export XDG_DATA_HOME := home + '/.local/share'
export XDG_CACHE_HOME := home + '/.cache'

# Non-standard
export XDG_BIN_HOME := home + '/.local/bin'
export XDG_LIB_HOME := home + '/.local/lib'
export XDG_OPT_HOME := home + '/.local/opt'

[private]
default:
  just --list

# Setup dotfiles symlinks
stow: prepare-directories setup
  #!/usr/bin/env bash
  stow --target="${HOME}" --dir="{{justfile_directory()}}" --stow local
  stow --target="${HOME}" --dir="{{modules_dir}}" --stow {{module_names}}

# Remove dotfiles symlinks
unstow:
  #!/usr/bin/env bash
  stow --target="${HOME}" --dir="{{justfile_directory()}}" --delete local
  stow --target="${HOME}" --dir="{{modules_dir}}" --delete {{module_names}}

# Verify stow symlinks are correctly setup
verify:
  #!/usr/bin/env bash
  set -e

  echo "--- Default package files currently unlinked ---"
  stow --no --verbose --target "${HOME}" --dir="{{modules_dir}}" --stow {{module_names}}

  echo "--- Local packages currently unlinked ---"
  stow --no --verbose --target "${HOME}" --dir="{{justfile_directory()}}" --stow local

  echo "--- Checking bogus links ---"
  rm -f {{bogus_links_path}}
  chkstow -a -b -t "${XDG_CONFIG_HOME}" | sed 's/Bogus link: //' >> {{bogus_links_path}}
  chkstow -a -b -t "${XDG_DATA_HOME}" >> {{bogus_links_path}}
  chkstow -a -b -t "${XDG_BIN_HOME}" >> {{bogus_links_path}}
  chkstow -a -b -t "${XDG_LIB_HOME}" >> {{bogus_links_path}}
  chkstow -a -b -t "${XDG_OPT_HOME}" >> {{bogus_links_path}}

  cat {{bogus_links_path}}

  if [[ -s "{{bogus_links_path}}" ]]; then
   echo "run 'just clnlink' to remove these files"
  fi

# Clean up bogus symlinks
clean:
  #!/usr/bin/env bash
  if [[ ! -f "{{bogus_links_path}}" || ! -s "{{bogus_links_path}}" ]]; then \
    echo "no bogus links to clean"; \
    exit 1; \
  fi

  echo "deleting bogus links at '{{bogus_links_path}}'"
  cat "{{bogus_links_path}}"
  cat "{{bogus_links_path}}" | xargs rm

[private]
setup:
  @stow --target="${HOME}" --stow etc

[private]
prepare-directories:
  #!/usr/bin/env bash
  set -e

  mkdir -p "{{ justfile_directory() }}/local"
  mkdir -p "${HOME}/.ssh/config.d"
  mkdir -p "${XDG_CONFIG_HOME}/profile.d"
  mkdir -p "${XDG_CONFIG_HOME}/shell.d"
  mkdir -p "${XDG_CONFIG_HOME}/git"
  mkdir -p "${XDG_CONFIG_HOME}/less"
  mkdir -p "${XDG_DATA_HOME}/zsh"
  mkdir -p "${XDG_CACHE_HOME}/less"
  mkdir -p "${XDG_BIN_HOME}"
  mkdir -p "${XDG_LIB_HOME}"
  mkdir -p "${XDG_OPT_HOME}"
  mkdir -p "${HOME}/code"
  
  if [[ "$DOTFILES_OS" == "macos" ]]; then
    mkdir "${XDG_CONFIG_HOME}/hammerspoon"
    mkdir "${XDG_CONFIG_HOME}/homebrew"
  fi

