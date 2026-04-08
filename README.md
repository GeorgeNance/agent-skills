# agent-skills

My personal shortcut skills, packaged for both Claude Code and Codex.

## Skills

- **yeet** — Fast commit-and-push. Usage: `/yeet "message"` or `/yeet` to auto-generate.
- **wiki** — Search, read, and browse the Obsidian wiki from agent workflows.

## Claude Code

```
/plugin marketplace add GeorgeNance/agent-skills
/plugin install shortcuts@george-skills
```

## Codex

This repo now includes a repo-local Codex marketplace at
`./.agents/plugins/marketplace.json` and a Codex plugin manifest at
`./plugins/shortcuts/.codex-plugin/plugin.json`.

To install it into your local Codex config and plugin cache, run:

```bash
./scripts/install-codex-plugin.sh
```

Restart Codex after running the script. The plugin will be enabled as
`shortcuts@agent-skills`, and the installer will also add execpolicy
prefix rules so the wiki wrapper scripts run without approval prompts.
