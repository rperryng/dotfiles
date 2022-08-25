#!/usr/bin/env sh

# Aliases
alias g_branch="git symbolic-ref --short -q HEAD"
alias gcom='git checkout $(git_default_branch)'
alias gdm="git diff --stat --color master..\$(git symbolic-ref --short -q HEAD)"
alias glo="git log --oneline"

alias gcaem="git commit --allow-empty --message"
alias gcam="git commit --amend --message"
alias gcane="git commit --amend --no-edit"
alias gcmsg="git commit --message"
alias gcne="git commit --no-edit"

# Push new local branch to remote under the same name
alias gpsu="git push --set-upstream origin \$(git symbolic-ref --short -q HEAD)"

# Semantically a 'git rebase --continue --no-edit', i.e. re-use the same commit
# message as the original.
alias grbcne='GIT_EDITOR=true git rebase --continue'
alias git_default_branch="git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'"

git_migrate_to_main() {
  git branch -m master main
  git fetch origin
  git branch -u origin/main main
  git remote set-head origin -a
}

point_branch_to_head() {
  local branch_name
  branch_name=$1
  git branch -f $1 HEAD
  git checkout $1
}

# replay all commits, starting at feature_branch exclusive, through
# dependent_feature inclusive onto master
rebase_dependent() {
  local feature_branch
  feature_branch=$1
  git rebase --onto $(git_default_branch) "${feature_branch}" HEAD
}

refresh_clone_urls() {
  temp_file=$(mktemp)
  (
    gh api /user/repos --paginate | \
        jq -r '
          .[]
          | select(.owner.login | test("rperryng*"))
          | select(.archived | not)
          | .ssh_url
        ' > $temp_file && \
        rm --force "$HOME/.clone_urls" && \
        mv $temp_file "$HOME/.clone_urls" \
  ) &
}
