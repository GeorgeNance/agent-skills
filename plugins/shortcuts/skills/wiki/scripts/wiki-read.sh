#!/usr/bin/env bash
# wiki-read.sh — Read a wiki article from the Lexicon vault
# Usage: wiki-read.sh <path>
#   path : relative path within vault (e.g. wiki/articles/bulk-enrollment.md)

set -euo pipefail

VAULT="lexicon"
FILE_PATH="${1:?Usage: wiki-read.sh <path>}"

obsidian read vault="$VAULT" path="$FILE_PATH" 2>/dev/null
