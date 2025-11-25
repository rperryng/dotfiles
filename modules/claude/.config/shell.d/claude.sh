#!/usr/bin/env bash

# Merge Claude settings from JSONC fragments
alias merge-claude-settings='${DOTFILES_DIR}/modules/merge-jsonc/.local/bin/merge-jsonc ~/.claude/rpn-settings > ~/.claude/settings.json && echo "✓ Merged settings to ~/.claude/settings.json" >&2'
