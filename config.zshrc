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
  export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
  alias nv="nvr"
else
  export VISUAL=nvim
fi
export EDITOR="$VISUAL"

# Neovim true color support
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

# Aliases
alias g="git"
alias gaa="git add -A"
alias gb="git branch"
alias gbD="git branch -D"
alias gbd="git branch -d"
alias gc="git commit"
alias gcam="git commit --amend -m"
alias gcane="git commit --amend --no-edit"
alias gcb="git checkout -b"
alias gcl="git clean"
alias gcm="git commit -m"
alias gco="git checkout"
alias gd="git diff"
alias gdc="git diff --cached"
alias gf="git fetch"
alias gl="git log --oneline"
alias gl="git log"
alias gm="git merge"
alias gpl="git pull"
alias gps="git push"
alias gpsf="git push -f"
alias gpsup="git push -u"
alias grb="git rebase"
alias grbi="git rebase -i"
alias grm="git rm"
alias grs="git reset"
alias grsh="git reset --hard"
alias gsh="git stash -u"

alias nvv="nv +terminal"
