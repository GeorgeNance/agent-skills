# agent-skills

My personal developer workflows, packaged for both Claude Code and Codex.

The root `skills/` directory is the source of truth. The Claude Code and Codex
plugin metadata at the repo root expose those skills under the `devflows`
namespace.

## Skills

- **yeet** — Fast commit-and-push. Usage: `/yeet "message"` or `/yeet` to auto-generate.
- **simplify-code-review-and-cleanup** — Review current changes for reuse, quality, and efficiency, then clean them up.
- **super-review** — Run an extremely strict maintainability review for abstraction quality, giant files, and spaghetti-condition growth. Inspired by the concept of a "thermo-nuclear code quality review" https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/thermo-nuclear-code-quality-review/SKILL.md

## Agent Skills CLI

This repo can be installed directly with the Agent Skills CLI:

```bash
npx skills add GeorgeNance/agent-skills --list
npx skills add GeorgeNance/agent-skills -g -a codex --skill '*' -y
```

Use the GitHub source when you want tracked updates:

```bash
npx skills update -g -y
```

For local development, validate the checkout before publishing changes:

```bash
npx skills add . --list
```

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
