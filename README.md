# agent-skills

My personal developer workflows, packaged for both Claude Code and Codex.

## Skills

- **yeet** — Fast commit-and-push. Usage: `/yeet "message"` or `/yeet` to auto-generate.
- **wiki** — Search, read, and browse the Obsidian wiki from agent workflows.
- **simplify-code-review-and-cleanup** — Review current changes for reuse, quality, and efficiency, then clean them up.

## Agents

- **Claude plugin agent:** `code-simplifier` at `plugins/devflows/agents/code-simplifier.md`
- **Codex custom agent:** `devflows_code_simplifier` at `.codex/agents/devflows_code_simplifier.toml`

The cleanup workflow is split by platform:

- Claude Code supports plugin-packaged agents, so the repo includes a Claude agent.
- Codex supports custom agents via `.codex/agents/`, not as plugin-packaged agents, so the repo includes a project-scoped Codex custom agent plus the plugin skill.

## Claude Code

For Claude Code setup, tell Claude to follow [instructions.md](/Users/georgenance/Projects/agent-skills/instructions.md) and use the `Claude Code` section.

## Codex

For Codex setup, tell Codex to follow [instructions.md](/Users/georgenance/Projects/agent-skills/instructions.md) and use the `Codex` section.
