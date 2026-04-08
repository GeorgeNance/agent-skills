# agent-skills

My personal developer workflows, packaged for both Claude Code and Codex.

## Skills

- **yeet** — Fast commit-and-push. Usage: `/yeet "message"` or `/yeet` to auto-generate.
- **wiki** — Search, read, and browse the Obsidian wiki from agent workflows.
- **simplify-code-review-and-cleanup** — Review current changes for reuse, quality, and efficiency, then clean them up.

## Agents

- **Codex custom agent:** `devflows_code_simplifier` at `.codex/agents/devflows_code_simplifier.toml`

The cleanup workflow uses a project-scoped Codex custom agent plus the plugin skill.

## Claude Code

Paste this into Claude Code:

```text
Follow the setup instructions in this file exactly and complete the setup end to end:

https://raw.githubusercontent.com/GeorgeNance/agent-skills/refs/heads/master/instructions.md

Use the `Claude Code` section. Make sure you refresh the marketplace metadata before installing. When you're done, briefly confirm exactly what was installed.
```

## Codex

Paste this into Codex:

```text
Follow the setup instructions in this file exactly and complete the setup end to end:

https://raw.githubusercontent.com/GeorgeNance/agent-skills/refs/heads/master/instructions.md

Use the `Codex` section. If a command needs approval because it writes to my home directory, request approval and continue. When you're done, briefly confirm exactly what was installed.
```
