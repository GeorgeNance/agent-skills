#!/usr/bin/env bash
# wiki-search.sh — Search the Lexicon wiki via Obsidian CLI
# Usage: wiki-search.sh <query> [section] [limit]
#   query   : search term (required)
#   section : wiki subfolder to scope (articles, atlas, timelines, lists) — default: all of wiki
#   limit   : max results (default: 10)

set -euo pipefail

VAULT="lexicon"
QUERY="${1:?Usage: wiki-search.sh <query> [section] [limit]}"
SECTION="${2:-}"
LIMIT="${3:-10}"

if [[ -n "$SECTION" ]]; then
  PATH_ARG="wiki/${SECTION}"
else
  PATH_ARG="wiki"
fi

obsidian search:context vault="$VAULT" query="$QUERY" path="$PATH_ARG" limit="$LIMIT" format=json 2>/dev/null
