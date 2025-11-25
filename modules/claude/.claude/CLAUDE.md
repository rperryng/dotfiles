# Claude Instructions

## Version Control

This user uses **jj** (Jujutsu) instead of git for version control.

**Important:** Whenever you need to perform version control operations, use `jj` commands instead of `git` commands.

Common mappings:
- `git status` → `jj status`
- `git log` → `jj log`
- `git diff` → `jj diff`
- `git commit` → `jj commit` or `jj describe`
- `git add` → changes are auto-tracked in jj
- `git branch` → `jj branch`
- `git checkout` → `jj new` or `jj edit`

For more information, see the jj configuration in `modules/jj/.config/`.
