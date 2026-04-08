---
name: wiki
description: >-
  This skill should be used when the user asks to "search the wiki", "look up in the wiki",
  "find a wiki article", "check the wiki for", "wiki search", "what does the wiki say about",
  "read wiki article", "open wiki article", "browse the wiki", "list wiki articles",
  "search obsidian", "check obsidian", or references wiki content. Also trigger for knowledge
  lookups such as "tell me about", "what do we know about", "give me background on", "give me
  context on", "history of", "summarize what we know about", or similar prompts when the answer
  may live in past meetings, project history, team notes, or other knowledge documented in the
  Obsidian vault. When in doubt between general knowledge and team knowledge, prefer checking the
  wiki first.
argument-hint: "[query-or-path]"
allowed-tools:
  - Bash
shell: bash
version: 0.1.0
---

# Obsidian Wiki

Search, read, and browse articles in the Obsidian wiki section. The wiki contains compiled
knowledge from meetings, projects, and team discussions organized into articles, atlas entries,
timelines, and lists.

For broad prompts like "tell me about X" or "what do we know about X", treat this skill as a
knowledge lookup workflow, not only an explicit wiki workflow. Search Obsidian first, then:

1. If relevant wiki results exist, answer from the wiki and cite article paths.
2. If no relevant results exist, say that the wiki did not contain useful context.
3. Only fall back to general knowledge if that still helps answer the user's request.

Default search behavior:

1. Start with one strong search using the user's original phrase.
2. Do not immediately repeat the search with trivial variants like dropping a first name,
   lowercasing, or reordering obvious terms when the first search already returned relevant hits.
3. Only run a second search if the first search returns no useful results or if a clearly different
   alias, acronym, or product name is likely to matter.

## Vault Details

- **Vault name**: `lexicon`
- **Vault path**: `/Users/georgenance/Library/Mobile Documents/iCloud~md~obsidian/Documents/lexicon`
- **Wiki root**: `wiki/` within the vault
- **Total articles**: ~84 markdown files

## Wiki Sections

| Section     | Path              | Content                                        |
|-------------|-------------------|------------------------------------------------|
| articles    | `wiki/articles/`  | Compiled topic pages (Aether, Salesforce, etc) |
| atlas       | `wiki/atlas/`     | Entity/organization entries (ASU, teams, etc)  |
| timelines   | `wiki/timelines/` | Date-based entries from meetings and events    |
| lists       | `wiki/lists/`     | Curated lists and collections                  |
| _meta       | `wiki/_meta/`     | Wiki maintenance metadata                      |

## Commands

All commands use the Obsidian CLI (`obsidian`) targeting `vault=lexicon`. Scripts are in
`scripts/` and suppress stderr (Obsidian outputs a deprecation notice on every CLI call).

### Search Articles

Search for content across wiki articles. Prefer `search:context` for richer results.

```bash
# Search all wiki sections
bash "${CLAUDE_SKILL_DIR}/scripts/wiki-search.sh" "<query>"

# Search specific section
bash "${CLAUDE_SKILL_DIR}/scripts/wiki-search.sh" "<query>" articles

# Limit results
bash "${CLAUDE_SKILL_DIR}/scripts/wiki-search.sh" "<query>" "" 5
```

Direct CLI equivalent:
```bash
obsidian search:context vault=lexicon query="<term>" path=wiki format=json limit=10 2>/dev/null
```

Output is JSON: an array of objects with `file` (path) and `matches` (array of `{line, text}`).

### Read Article

Read the full contents of a wiki article by its vault-relative path.

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/wiki-read.sh" "wiki/articles/bulk-enrollment.md"
```

Direct CLI equivalent:
```bash
obsidian read vault=lexicon path="wiki/articles/<slug>.md" 2>/dev/null
```

### Open in Obsidian

Open an article in the Obsidian desktop app (new tab). Use this when the user asks to "view
source", "open in obsidian", or "open the article".

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/wiki-open.sh" "wiki/articles/bulk-enrollment.md"
```

### List Articles

List all markdown files in a wiki section.

```bash
# All wiki files
bash "${CLAUDE_SKILL_DIR}/scripts/wiki-list.sh"

# Specific section
bash "${CLAUDE_SKILL_DIR}/scripts/wiki-list.sh" articles
```

### Additional CLI Commands

These Obsidian CLI commands can be run directly when needed:

```bash
# Get article metadata (frontmatter properties)
obsidian properties vault=lexicon path="wiki/articles/<slug>.md" format=yaml 2>/dev/null

# List backlinks to an article
obsidian backlinks vault=lexicon path="wiki/articles/<slug>.md" format=json 2>/dev/null

# List outgoing links from an article
obsidian links vault=lexicon path="wiki/articles/<slug>.md" 2>/dev/null

# Get article outline (headings)
obsidian outline vault=lexicon path="wiki/articles/<slug>.md" format=tree 2>/dev/null

# Search for exact match count
obsidian search vault=lexicon query="<term>" path=wiki total 2>/dev/null
```

## Workflow

### Answering a Question

1. Run one `wiki-search.sh "<relevant terms>"` query using the user's original phrase
2. Read the top results with `wiki-read.sh` to get full context
3. Synthesize the answer from wiki content, citing article paths
4. Only issue a follow-up search when the first result set is empty or clearly low-signal
5. If the user wants to view the source, use `wiki-open.sh` to open in Obsidian

### Exploring a Topic

1. Run `wiki-list.sh articles` to see available topics
2. Search for the topic with `wiki-search.sh`
3. Read the article and follow wikilinks (`[[wiki/articles/...]]`) to related pages
4. Check backlinks to see what else references the topic

## Notes

- Article paths are always relative to the vault root (e.g., `wiki/articles/aether.md`)
- Frontmatter uses `note_type`, `page_kind`, `status`, `tags`, `source_notes` fields
- Wikilinks in articles use format `[[wiki/articles/slug.md|Display Name]]`
- Timeline entries are date-stamped: `wiki/timelines/YYYY-MM-DD.md`
- Always redirect stderr when calling `obsidian` CLI: append `2>/dev/null`
