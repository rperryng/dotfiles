# global gitignore
git config --global core.excludesfile ~/.gitignore

# http://www.rushiagr.com/blog/2016/06/16/everything-you-need-to-know-about-tmux-copy-pasting-ubuntu/
# https://github.com/BurntSushi/ripgrep
# https://github.com/denysdovhan/spaceship-zsh-theme
# https://github.com/ggreer/the_silver_searcher
# https://github.com/rbenv/rbenv
# https://github.com/romainl/ctags-patterns-for-javascript
# https://github.com/rupa/z
# https://github.com/scmbreeze/scm_breeze
# https://github.com/tmux-plugins/tpm
# https://github.com/tpope/gem-ctags
# https://github.com/tpope/rbenv-ctags
# https://github.com/zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-syntax-highlighting

# Z - jump around
. $HOME/code/tools/z/z.sh

# Base16
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_gruvbox-dark-pale

# Use neovim remote terminal if available
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  export VISUAL="nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"
  alias nv="nvr"
else
  export VISUAL=nvim
  alias nv="nvim"
fi
export EDITOR="$VISUAL"
alias nvv="nv +terminal"

# Neovim true color support
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

# When enter starts inputting ^M...
alias pls="stty sane"

# Aliases
alias g="git"
alias gaa="git add -A"
alias gap="git add -p"
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
alias glo="git log --oneline"
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
alias gcoh="git checkout HEAD -- "
