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

# Worktrees
alias wt="git worktree"
alias wta="git worktree add"

WORKTREE_DIR="${HOME}/code-worktrees"

_rpn_git_remote_refs() {
  git for-each-ref --format='%(refname)' 'refs/remotes/'
}

_rpn_git_local_refs() {
  git for-each-ref --format='%(refname)' 'refs/heads/'
}

wtan() {
  local branch_name
  local commit_ish
  branch_name="$1"
  commit_ish="$2"

  if [[ -z "$branch_name" || -z "$commit_ish" ]]; then
    echo "Usage: wta <new_branch_name> <commit-ish>" 1>&2
    return 1
  fi

  # # If no commit_ish given, choose one from either a local or remote branch
  # if [[ -z "$commit_ish" ]]; then
  #   remote_refs=$(_rpn_git_local_refs)
  #   commit_ish=$(echo "$remote_refs" | fzf)
  #
  #   if [[ -z "$commit_ish" ]]; then
  #     echo "no commit_ish selected ..." 1>&2
  #     return 1
  #   fi
  #
  #   commit_ish=$(echo "$commit_ish" | rg --only-matching 'refs/remotes/(.+)' --replace '$1')
  # fi

  local remote_url=$(git config --get remote.origin.url)
  owner=$(echo "$remote_url" | rg --only-matching ':(\w+)/(\w+)\.git' --replace '$1')
  reponame=$(echo "$remote_url" | rg --only-matching ':(\w+)/(\w+)\.git' --replace '$2')
  worktree_dir="${WORKTREE_DIR}/${owner}/${reponame}/${branch_name}"
  git worktree add -b "$branch_name" "$worktree_dir" $commit_ish
}

# git worktree add "--remote" (not a real flag, but the mnemonic helps me)
wtar() {
  local source_ref
  source_ref="$1"

  if [[ -z "$source_ref" ]]; then
    remote_refs=$(git for-each-ref --format='%(refname)' 'refs/remotes/origin/')
    source_ref=$(echo "$remote_refs" | fzf)

    if [[ -z "$source_ref" ]]; then
      echo "no source_ref selected ..." 1>&2
      return 1
    fi
  fi

  branch_name=$(echo "$source_ref" | rg --only-matching 'refs/remotes/origin/(.+)' --replace '$1')
  if [[ -z $branch_name ]]; then
    echo "failed to parse branch_name from ref: ${source_ref}" 1>&2
    return 1
  fi

  # see: man git-worktree
  # This will be used as the remote ref (typically a branch name) to base the new worktree on
  commit_ish=$(echo "$source_ref" | rg --only-matching 'refs/remotes/(origin/.+)' --replace '$1')

  # Parse owner / repo from origin url
  local remote_url=$(git config --get remote.origin.url)
  owner=$(echo "$remote_url" | rg --only-matching ':(\w+)/(\w+)\.git' --replace '$1')
  reponame=$(echo "$remote_url" | rg --only-matching ':(\w+)/(\w+)\.git' --replace '$2')
  worktree_dir="${WORKTREE_DIR}/${owner}/${reponame}/${branch_name}"

  if [[ -d "$worktree_dir" ]]; then
    echo "worktree already exists, switching"
    cd "$worktree_dir"
    return 1
  else
    echo "git worktree add -b \"$branch_name\" \"$worktree_dir\" \"$commit_ish\""
    git worktree add -b "$branch_name" "$worktree_dir" "$commit_ish"
  fi
}

# Convert normal git clone repo into a bare-like repo for use with worktrees only
git_convert_wt() {
  git checkout -b rpn-worktree-base
  git checkout --detach
  git checkout $(git commit-tree $(git hash-object -t tree /dev/null) < /dev/null)
}
