#!/usr/bin/env bash

# select files with fzf
# then make sure they are 'stow'-ed across all the worktrees
# Also, store the list of stowed files in a file for easy access
wt-stow() {
  "${DOTFILES_DIR}"/modules/worktree-tool/.data/share/worktree-tool/src/main.ts
}
#
# wt-add() {
#   # TODO: Single binary?
#   "${DOTFILES_DIR}"/modules/worktree-tool/.data/share/worktree-tool/src/commands/addWorktree.ts $@
# }

alias wt-add="${DOTFILES_DIR}/modules/worktree-tool/.data/share/worktree-tool/src/commands/addWorktree.ts"
