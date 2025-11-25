# Claude Code Configuration

Configuration for Claude Code CLI, including composable JSONC-based settings management.

## Structure

```
modules/claude/
├── .claude/
│   └── rpn-settings/
│       ├── .gitignore          # Excludes work-specific files
│       └── 01-base.jsonc       # Public base settings (in git)
└── .config/
    └── shell.d/
        └── claude.sh           # Shell alias: merge-claude-settings
```

## Settings Management

This module uses the `merge-jsonc` tool to compose Claude settings from multiple JSONC fragments, allowing you to separate public and private configuration.

### Usage

1. **Create settings fragments** in `~/.claude/rpn-settings/`:
   - `01-base.jsonc` - Public settings (from dotfiles)
   - `02-work.jsonc` - Private/work settings (create locally, gitignored)
   - `NN-*.jsonc` - Additional fragments as needed

2. **Merge settings**:
   ```bash
   merge-claude-settings
   ```

   Outputs to `~/.claude/settings.json`

3. **Re-run after editing** any fragment file.

### Merge Behavior

Powered by `merge-jsonc`:
- Objects merge recursively
- Arrays concatenate (later files append)
- Primitives override (later files win)
- JSONC: supports comments and trailing commas

### Example

```jsonc
// 01-base.jsonc (public, in git)
{
  "permissions": {
    "allow": ["Bash(git:*)", "Bash(jj:*)"]
  }
}

// 02-work.jsonc (private, gitignored)
{
  "enabledPlugins": {
    "company-plugin@internal": true
  },
  "permissions": {
    "allow": ["Bash(jira:*)"]  // Appends to array
  }
}

// Result: ~/.claude/settings.json
{
  "enabledPlugins": {
    "company-plugin@internal": true
  },
  "permissions": {
    "allow": ["Bash(git:*)", "Bash(jj:*)", "Bash(jira:*)"]
  }
}
```

## Files

- `.claude/rpn-settings/` - JSONC settings fragments
- `.config/shell.d/claude.sh` - Shell alias

## Requirements

- `merge-jsonc` tool (from `modules/merge-jsonc`)
