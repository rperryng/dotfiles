
#!/usr/bin/env bash
#
# Setup homebrew
#

set -e

# Prompt for admin password upfront
sudo -v

# Check if homebrew is installed
if [[ ! -x "$(command -v brew)" ]]; then
  if [[ "${DOTFILES_OS}" == 'macos' ]]; then
    # Install standard homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  elif [[ "${OSTYPE}" == linux* ]]; then
    # Make sure this is in the path
    if [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/bin* ]]; then
      PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
    fi

    # Install linuxbrew
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  fi
fi

# Install brews using brew bundle (uses the Brewfile)
# if [[ -x "$(command -v brew)" ]]; then
#   printf "Do you want run brew bundle [y/N]? "
#   read -r answer
#   case "${answer}" in [yY] | [yY][eE][sS])
#     brewfile="${DOTFILES_DIR:-$HOME/.dotfiles}/modules/homebrew/.config/homebrew/Brewfile"
#     HOMEBREW_BUNDLE_FILE="$brewfile" brew bundle
#     ;;
#   esac
# fi
