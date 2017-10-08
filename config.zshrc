# global gitignore
git config --global core.excludesfile ~/.gitignore

# http://www.rushiagr.com/blog/2016/06/16/everything-you-need-to-know-about-tmux-copy-pasting-ubuntu/
# https://github.com/BurntSushi/ripgrep
# https://github.com/denysdovhan/spaceship-zsh-theme
# https://github.com/ggreer/the_silver_searcher
# https://github.com/rbenv/rbenv
# https://github.com/rupa/z
# https://github.com/scmbreeze/scm_breeze
# https://github.com/tmux-plugins/tpm
# https://github.com/zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-syntax-highlighting

# Z - jump around
. $HOME/code/tools/z/z.sh

# Base16
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_eighties

# Use neovim remote terminal if available
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  export VISUAL="nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"
  alias nv="nvr"
else
  export VISUAL=nvim
fi
export EDITOR="$VISUAL"

# Neovim true color support
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

# SCM Breeze

