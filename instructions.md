# Setup Instructions

This file is written for an AI coding assistant to follow directly when a user wants this repo set up in Claude Code or Codex.

Choose the platform that matches the user's request and complete the steps end to end.

## Codex

Goal: install the local `devflows` plugin and the Codex custom agent for the current user.

1. Run `./scripts/install-codex-plugin.sh` from the repo root.
2. If the command needs permission because it writes to the user's home directory, request approval and continue.
3. After the script succeeds, tell the user:
   - the plugin was installed as `devflows@agent-skills`
   - the custom agent `devflows_code_simplifier` was copied into `~/.codex/agents/`
   - they should restart Codex before using the plugin and agent
4. If the user only wants the Codex custom agent and not the plugin, run `./scripts/install-codex-agent.sh` instead and report the installed agent path.

## Claude Code

Goal: install the `devflows` plugin from the marketplace in Claude Code.

1. In Claude Code, run `/plugin marketplace add GeorgeNance/agent-skills`.
2. Run `/plugin install devflows@george-skills`.
3. After installation, tell the user the plugin is available under the `devflows` namespace.
4. If the plugin was already installed or the user is testing local changes, use `/reload-plugins`.

## Response Style

When you finish setup:

- confirm what was installed
- include the plugin or agent name exactly
- keep the response short
