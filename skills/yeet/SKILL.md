---
name: yeet
description: Use when the user says "yeet" or "/yeet" to quickly stage, review, commit, and push all changes with a provided message
---

# Yeet

Fast commit-and-push. Usage: `/yeet "some commit message"` or just `/yeet` to auto-generate the message.

## The Process

### Step 1: Stage All Files

```bash
git add -A
```

### Step 2: Show What Changed

Run `git diff --cached --stat` and `git diff --cached` to show:
- List of changed files with insertions/deletions
- The actual diff content

Present to user as a summary.

### Step 3: Determine Commit Message

- If the user provided a message, use it.
- If no message was provided, check `git log --oneline -10` for recent commit style, then generate a concise commit message based on the diff. Use the **Conventional Commits** format: `type(scope): description` (e.g., `fix(auth): resolve token refresh race condition`, `feat(dashboard): add player search`). Common types: `feat`, `fix`, `refactor`, `style`, `docs`, `test`, `chore`, `perf`, `ci`, `build`. Scope is optional but preferred when the change is clearly scoped to a specific area.

### Step 4: Confirm

Ask user to confirm with a message like:

```
Ready to commit and push with message: "<message>"
```

Use `AskUserQuestion` with options "Yeet it" and "Cancel".

### Step 5: On Confirm

```bash
git commit -m "<message>"
git push
```

If push fails (no upstream), use `git push -u origin <current-branch>`.

Report the commit hash and pushed branch when done.

### On Cancel

```bash
git reset
```

Unstage everything and stop.
