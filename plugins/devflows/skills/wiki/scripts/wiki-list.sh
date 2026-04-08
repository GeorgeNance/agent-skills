#!/usr/bin/env bash
# wiki-list.sh — List wiki articles from the Lexicon vault
# Usage: wiki-list.sh [section]
#   section : wiki subfolder (articles, atlas, timelines, lists) — default: all of wiki

set -euo pipefail

VAULT="lexicon"
SECTION="${1:-}"

if [[ -n "$SECTION" ]]; then
  FOLDER="wiki/${SECTION}"
else
  FOLDER="wiki"
fi

obsidian files vault="$VAULT" folder="$FOLDER" ext=md 2>/dev/null
