#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PLUGIN_SOURCE="${REPO_ROOT}/plugins/shortcuts"
HOME_DIR="${HOME}"
MARKETPLACE_PATH="${HOME_DIR}/.agents/plugins/marketplace.json"
CONFIG_PATH="${HOME_DIR}/.codex/config.toml"
RULES_PATH="${HOME_DIR}/.codex/rules/default.rules"

if [[ ! -d "${PLUGIN_SOURCE}" ]]; then
  echo "Missing plugin source at ${PLUGIN_SOURCE}" >&2
  exit 1
fi

if [[ "${PLUGIN_SOURCE}" != "${HOME_DIR}/"* ]]; then
  echo "Personal marketplace installs require the plugin to live under ${HOME_DIR}" >&2
  exit 1
fi

PLUGIN_SOURCE_REL="./${PLUGIN_SOURCE#${HOME_DIR}/}"
export MARKETPLACE_PATH PLUGIN_SOURCE_REL

MARKETPLACE_NAME="$(
  python3 <<'PY'
import json
import os
from pathlib import Path

marketplace_path = Path(os.environ["MARKETPLACE_PATH"])
plugin_source_rel = os.environ["PLUGIN_SOURCE_REL"]

payload = {
    "name": "agent-skills",
    "interface": {"displayName": "Agent Skills"},
    "plugins": [],
}

if marketplace_path.exists():
    raw = marketplace_path.read_text().strip()
    if raw:
        payload = json.loads(raw)
        if not isinstance(payload, dict):
            raise SystemExit("Existing marketplace.json must contain a JSON object.")

name = payload.get("name")
if not isinstance(name, str) or not name:
    payload["name"] = "agent-skills"

interface = payload.get("interface")
if interface is None:
    payload["interface"] = {"displayName": "Agent Skills"}
elif not isinstance(interface, dict):
    raise SystemExit("Existing marketplace.json field 'interface' must be an object.")
else:
    interface.setdefault("displayName", "Agent Skills")

plugins = payload.setdefault("plugins", [])
if not isinstance(plugins, list):
    raise SystemExit("Existing marketplace.json field 'plugins' must be an array.")

entry = {
    "name": "shortcuts",
    "source": {
        "source": "local",
        "path": plugin_source_rel,
    },
    "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL",
    },
    "category": "Productivity",
}

for index, existing in enumerate(plugins):
    if isinstance(existing, dict) and existing.get("name") == "shortcuts":
        plugins[index] = entry
        break
else:
    plugins.append(entry)

marketplace_path.parent.mkdir(parents=True, exist_ok=True)
marketplace_path.write_text(json.dumps(payload, indent=2) + "\n")
print(payload["name"])
PY
)"

CACHE_PATH="${HOME_DIR}/.codex/plugins/cache/${MARKETPLACE_NAME}/shortcuts/local"
mkdir -p "${CACHE_PATH}"
cp -R "${PLUGIN_SOURCE}/." "${CACHE_PATH}/"

export CONFIG_PATH MARKETPLACE_NAME
python3 <<'PY'
import os
import re
from pathlib import Path

config_path = Path(os.environ["CONFIG_PATH"])
marketplace_name = os.environ["MARKETPLACE_NAME"]
plugin_key = f'shortcuts@{marketplace_name}'
section_header = f'[plugins."{plugin_key}"]'

text = config_path.read_text() if config_path.exists() else ""
pattern = re.compile(rf'(?ms)^{re.escape(section_header)}\n(.*?)(?=^\[|\Z)')
match = pattern.search(text)

if match:
    body = match.group(1)
    if re.search(r'(?m)^enabled\s*=', body):
        body = re.sub(r'(?m)^enabled\s*=.*$', 'enabled = true', body)
    else:
        if body and not body.endswith("\n"):
            body += "\n"
        body += "enabled = true\n"
    text = text[:match.start()] + section_header + "\n" + body + text[match.end():]
else:
    if text and not text.endswith("\n"):
        text += "\n"
    text += f"\n{section_header}\nenabled = true\n"

config_path.write_text(text)
PY

export RULES_PATH PLUGIN_SOURCE CACHE_PATH
python3 <<'PY'
import os
from pathlib import Path

rules_path = Path(os.environ["RULES_PATH"])
plugin_source = Path(os.environ["PLUGIN_SOURCE"])
cache_path = Path(os.environ["CACHE_PATH"])

script_roots = [
    plugin_source / "skills" / "wiki" / "scripts",
    cache_path / "skills" / "wiki" / "scripts",
]
script_names = [
    "wiki-search.sh",
    "wiki-read.sh",
    "wiki-open.sh",
    "wiki-list.sh",
]

rules_path.parent.mkdir(parents=True, exist_ok=True)
existing = rules_path.read_text() if rules_path.exists() else ""
lines = existing.splitlines()

for script_root in script_roots:
    for script_name in script_names:
        pattern = f'prefix_rule(pattern=["bash", "{script_root / script_name}"], decision="allow")'
        if pattern not in lines:
            lines.append(pattern)

rules_path.write_text("\n".join(lines).rstrip() + "\n")
PY

echo "Installed shortcuts@${MARKETPLACE_NAME}"
echo "Marketplace: ${MARKETPLACE_PATH}"
echo "Cache: ${CACHE_PATH}"
echo "Rules: ${RULES_PATH}"
