#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
AGENT_SOURCE="${REPO_ROOT}/.codex/agents/devflows_code_simplifier.toml"
AGENT_DEST_DIR="${HOME}/.codex/agents"
AGENT_DEST="${AGENT_DEST_DIR}/devflows_code_simplifier.toml"

if [[ ! -f "${AGENT_SOURCE}" ]]; then
  echo "Missing Codex agent source at ${AGENT_SOURCE}" >&2
  exit 1
fi

mkdir -p "${AGENT_DEST_DIR}"
cp "${AGENT_SOURCE}" "${AGENT_DEST}"

echo "Installed Codex custom agent: devflows_code_simplifier"
echo "Agent: ${AGENT_DEST}"
