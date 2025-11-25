---
name: draft-pr
description: Use when creating a GitHub PR in repos using jj (Jujutsu) version control with bookmark format rpn/<jira-ticket>/description - extracts JIRA ticket from bookmark, reads PR template, creates draft PR with JIRA in body (not title)
---

# Draft PR Creation with jj

## Overview

Creates GitHub draft PRs following project conventions when using jj (Jujutsu) version control. Extracts JIRA ticket from bookmark name, follows PR templates, and includes JIRA at top of PR body.

## When to Use

- User asks to "create a PR" or "make a PR"
- Working in a repo using jj version control
- Bookmarks follow `rpn/<jira-ticket>/description` format

**When NOT to use:**
- Bookmark is `main` or `master` → Something is wrong, ask user what to do
- Bookmark doesn't match expected format → Ask user for JIRA ticket
- Not a work repo (e.g., personal dotfiles) → Skip JIRA requirements

## Workflow

### 1. Validate Context

```bash
# Get current bookmark - DON'T assume, actually run this
bookmark=$(jj bookmark list --revisions "closest_bookmark(@)" --template "name ")

# Alternative: parse from jj log if bookmark list doesn't work
# bookmark=$(jj log -r @ --limit 1 -T 'bookmarks' | grep -oE 'rpn/[a-z0-9-]+/[a-z0-9-]+')

# Check for problematic bookmarks
if [[ "$bookmark" == "main" ]] || [[ "$bookmark" == "master" ]]; then
  # ASK USER - something is wrong
fi

# Validate bookmark format (rpn/<jira-ticket>/description)
if [[ ! "$bookmark" =~ ^rpn/([A-Z]+-[0-9]+)/ ]] && [[ ! "$bookmark" =~ ^rpn/([a-z]+-[0-9]+)/ ]]; then
  # ASK USER for JIRA ticket or confirm this is non-work repo
fi
```

### 2. Extract JIRA Ticket

```bash
# Parse bookmark: rpn/ws-1234/add-feature → WS-1234
jira_ticket=$(echo "$bookmark" | sed -E 's|rpn/([a-z]+-[0-9]+)/.*|\1|' | tr '[:lower:]' '[:upper:]')
```

### 3. Gather Change Context

```bash
# Check what changed - use jj revision syntax
jj diff --revision 'trunk()..@'

# Review recent commits in this bookmark
jj log -r 'trunk()..@' --template 'description'
```

### 4. Read PR Template

```bash
# Actually read the template - don't assume format
if [[ -f PULL_REQUEST_TEMPLATE.md ]]; then
  cat PULL_REQUEST_TEMPLATE.md
fi
```

**Extract from template:**
- JIRA URL format (don't hard-code `jira.company.com` or similar)
- Required sections
- Checklist items

### 5. Construct PR Title

Format: `type(scope): description`

**Type**: `feat`, `fix`, `chore`, `docs`, `style`, `refactor`, `perf`, `test`, `build`

**Scope**: Component/file affected (from changes)

**Example**: `feat(auth): add OAuth support`

**Note**: JIRA ticket goes in PR body, NOT title

### 6. Write Draft PR Body to File

```bash
# Write PR body to .pr-draft.md for manual editing
cat > .pr-draft.md <<'EOF'
JIRA: [TICKET-123](https://jira-url/TICKET-123)

## Why
Why this change was made (intent, not what)

## What Changed
- [ ] Change 1
- [ ] Change 2

## Testing
- [ ] Test approach 1
- [ ] Test approach 2
EOF

echo "Draft PR body written to .pr-draft.md"
```

**Note**: Save the PR title separately - you'll need it later.

### 7. Ask User What To Do

Use AskUserQuestion tool with these options:

1. **Create the PR as-is** - Create draft PR with current content
2. **Reload the draft PR body** - Read .pr-draft.md again (after manual edits)
3. **Do something else** - Cancel or take different action

**Don't skip this step** - Always give user a chance to edit manually.

### 8. Push Bookmark to Remote

Before creating the PR, push the jj bookmark to GitHub:

```bash
# Track the bookmark for remote pushing (if not already tracked)
jj bookmark track "$bookmark" --remote=origin

# Push the bookmark to create the remote branch
jj git push --bookmark "$bookmark"
```

**Important**: The `gh pr create` command requires a remote branch to exist. Always push first.

### 9. Create Draft PR

After user confirms or reloads and bookmark is pushed:

```bash
# Read the (potentially edited) PR body
pr_body=$(cat .pr-draft.md)

# Create the draft PR with explicit head and base branches
# This is required because gh can't detect the current branch with jj
gh pr create \
  --draft \
  --head "$bookmark" \
  --base main \
  --title "type(scope): description" \
  --body "$pr_body"
```

If user chose "Reload", read .pr-draft.md again and show them the updated content before creating.

**Note**: Use `--head` and `--base` flags explicitly since `gh` can't auto-detect branches in jj repos.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| JIRA ticket in title | Put JIRA in body only |
| Using `main..@` syntax | Use jj revisions: `trunk()..@` |
| Assuming bookmark format | Validate with regex, ask if invalid |
| Skipping PR template | Always read template if exists |
| Hard-coding JIRA URL | Get actual URL format from template or ask user - don't assume jira.company.com |
| Not running bookmark detection | Always execute command, don't theorize |
| Creating PR without writing to file first | Always write to .pr-draft.md and ask user |
| Not asking user before creating PR | Use AskUserQuestion tool with 3 options |
| Skipping reload option | User might have edited - always offer reload |
| Not pushing bookmark before PR creation | gh requires remote branch - always push first with `jj git push` |
| Not using --head and --base flags | gh can't detect branches in jj repos - use explicit flags |

## Red Flags - STOP and Validate

- "I'll assume the bookmark format" → Detect bookmark from jj first
- "Can expand description later" → Time pressure rationalization
- "PR template probably follows X format" → Read the actual file
- "The JIRA URL is probably..." → Get it from template, don't guess
- Bookmark is `main`/`master` → Ask user what's wrong
- Writing JIRA link before reading template → You're guessing the format
- "I'll create the PR directly" → Write to .pr-draft.md first, always
- "User doesn't need to edit" → You don't know that - ask them
- "gh will figure out the branch" → No it won't in jj repos - push bookmark and use --head/--base
- "I'll skip pushing to remote" → gh requires remote branch to exist

**All of these mean: Slow down and follow the workflow.**

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "User needs this urgent" | 2 minutes to read template saves rework later |
| "I know the JIRA URL pattern" | Patterns change, companies have custom setups - read template |
| "User told me the bookmark" | Still run command - validation catches mistakes |
| "Generic PR body is fine" | Reviewers need context - read diffs and write meaningful summary |
| "Can refine after creating" | Do it right the first time - no faster to do it twice |
| "User can edit PR after creation" | GitHub PR edits are slower - let them edit .pr-draft.md first |
| "Skip the file, just create PR" | User explicitly wants manual edit option - write file always |

## Quick Reference

```bash
# 1. Get bookmark
bookmark=$(jj bookmark list --revisions "closest_bookmark(@)" --template "name ")

# 2. Extract JIRA (rpn/ws-1234/desc → WS-1234)
echo "$bookmark" | sed -E 's|rpn/([a-z]+-[0-9]+)/.*|\1|' | tr '[:lower:]' '[:upper:]'

# 3. View changes
jj diff -r 'trunk()..@'

# 4. Write PR body to file
cat > .pr-draft.md <<'EOF'
JIRA: [XXX-123](https://url)
...
EOF

# 5. Ask user: Create as-is / Reload / Do something else
# Use AskUserQuestion tool

# 6. Push bookmark to remote (REQUIRED before creating PR)
jj bookmark track "$bookmark" --remote=origin
jj git push --bookmark "$bookmark"

# 7. Create draft PR from file with explicit flags
gh pr create \
  --draft \
  --head "$bookmark" \
  --base main \
  --title "type(scope): desc" \
  --body "$(cat .pr-draft.md)"
```
