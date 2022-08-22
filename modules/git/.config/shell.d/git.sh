#!/usr/bin/env sh

# Aliases
alias glo="git log --oneline"
alias gcmsg="git commit --message"
alias gcane="git commit --amend --no-edit"
alias gcam="git commit --amend --message"
alias gdm="git diff --stat --color master..\$(git symbolic-ref --short -q HEAD)"
alias g_branch="git symbolic-ref --short -q HEAD"
alias gcne="git commit --no-edit"
alias gcaem="git commit --allow-empty --message"

# Push new local branch to remote under the same name
alias gpsu="git push --set-upstream origin \$(git symbolic-ref --short -q HEAD)"

# Semantically a 'git rebase --continue --no-edit', i.e. re-use the same commit
# message as the original.
alias grbcne='GIT_EDITOR=true git rebase --continue'
