#!/usr/bin/env bash
# wiki-open.sh — Open a wiki article in Obsidian
# Usage: wiki-open.sh <path>
#   path : relative path within vault (e.g. wiki/articles/bulk-enrollment.md)

set -euo pipefail

VAULT="lexicon"
FILE_PATH="${1:?Usage: wiki-open.sh <path>}"

obsidian open vault="$VAULT" path="$FILE_PATH" newtab 2>/dev/null
echo "Opened ${FILE_PATH} in Obsidian"
