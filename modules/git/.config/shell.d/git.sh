#!/usr/bin/env bash

# Aliases
alias g_branch="git symbolic-ref --short -q HEAD"
alias gcom='git checkout $(git_default_branch)'
alias gdm="git diff --stat --color master..\$(git symbolic-ref --short -q HEAD)"
alias glog="git log --oneline"
alias glo="git log --format='%C(yellow)%H%C(auto)%d %C(reset)%s'"

alias gcaem="git commit --allow-empty --message"
alias gca="git commit --amend"
alias gcam="git commit --amend --message"
alias gcane="git commit --amend --allow-empty --no-edit"
alias gcmsg="git commit --message"
alias gcne="git commit --no-edit"

alias gr="git rebase"
alias grc="git rebase --continue"
alias grcne="git rebase --continue --no-edit"

alias gbb="git branch | head -10"

# Push new local branch to remote under the same name
alias gpsu="git push --set-upstream origin \$(git symbolic-ref --short -q HEAD)"

# Semantically a 'git rebase --continue --no-edit', i.e. re-use the same commit
# message as the original.
alias grbcne='GIT_EDITOR=true git rebase --continue'
alias git_default_branch="git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'"

# Update `refs/remotes/origin/HEAD` if it was updated in the remote (e.g.
# default branch renamed to `main`)
alias git_fix_origin_head="git remote set-head origin --auto"

# Jump to repository root
alias cdp='cd $(git rev-parse --show-toplevel)'

git_migrate_to_main() {
  git branch --move master main
  git fetch origin
  git branch --set-upstream-to='origin/main' main
  git remote set-head origin --auto
}

point_branch_to_head() {
  local branch_name
  branch_name=$1
  git branch -f "$branch_name" HEAD
  git checkout "$branch_name"
}

rpn_test() {
  local feature_branch dependent_branch
  feature_branch=$1
  dependent_branch=${2:HEAD}
  git rebase --onto $(git_default_branch) "${feature_branch}" "${dependent_branch}"
}

# replay all commits, starting at feature_branch exclusive, through
# dependent_feature inclusive onto master
rebase_dependent() {
  local feature_branch dependent_branch
  feature_branch=$1
  dependent_branch=${2:HEAD}
  git rebase --onto $(git_default_branch) "${feature_branch}" "${dependent_branch}"
}

export DOTFILES_CLONE_URLS_PATH="${XDG_CONFIG_HOME}/.clone_urls"
refresh_clone_urls() {
  temp_file=$(mktemp)
  (
    gh api /user/repos --paginate | \
        jq -r '
          .[]
          | select(.owner.login | test("rperryng*|wealthsimple*"))
          | select(.archived | not)
          | .ssh_url
        ' > $temp_file && \
        rm -f $DOTFILES_CLONE_URLS_PATH && \
        mv $temp_file $DOTFILES_CLONE_URLS_PATH \
  )
}
