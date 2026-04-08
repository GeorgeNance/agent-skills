---
name: simplify-code-review-and-cleanup
description: Review current code changes for reuse, code quality, and efficiency, then fix issues directly. Use when the user asks for a cleanup pass on changed files, wants the current diff reviewed before finishing, or asks for duplication, maintainability, or performance issues in recent edits to be identified and cleaned up.
---

# Simplify: Code Review and Cleanup

Review current code changes for reuse, quality, and efficiency. Fix any issues found.

## Phase 1: Identify Changes

Run `git diff HEAD` if there are staged changes so the review includes staged and unstaged work. Otherwise run `git diff`.

If there are no git changes, review the most recently modified files that the user mentioned or that you edited earlier in this conversation.

Capture the full diff once and reuse that same diff for all three review passes.

## Phase 2: Run Three Review Passes

If sub-agents are available and appropriate for the current environment, launch all three review agents concurrently in a single assistant turn with `spawn_agent`. Pass each agent the full diff so it has the complete context.

Prefer `agent_type: "explorer"` for these review passes.

If sub-agents are unavailable or not appropriate, perform the same three review passes yourself before making any edits.

### Pass 1: Code Reuse Review

For each change:

1. **Search for existing utilities and helpers** that could replace newly written code. Look for similar patterns elsewhere in the codebase. Common locations are utility directories, shared modules, and files adjacent to the changed ones.
2. **Flag any new function that duplicates existing functionality.** Suggest the existing function to use instead.
3. **Flag any inline logic that could use an existing utility**. Hand-rolled string manipulation, manual path handling, custom environment checks, ad-hoc type guards, and similar patterns are common candidates.

### Pass 2: Code Quality Review

Review the same changes for hacky patterns:

1. **Redundant state**: state that duplicates existing state, cached values that could be derived, observers or effects that could be direct calls
2. **Parameter sprawl**: adding new parameters to a function instead of generalizing or restructuring existing ones
3. **Copy-paste with slight variation**: near-duplicate code blocks that should be unified with a shared abstraction
4. **Leaky abstractions**: exposing internal details that should be encapsulated, or breaking existing abstraction boundaries
5. **Stringly-typed code**: using raw strings where constants, enums, string unions, or branded types already exist in the codebase
6. **Unnecessary JSX nesting**: wrapper boxes or elements that add no layout value. Check whether inner component props such as `flexShrink` or `alignItems` already provide the needed behavior
7. **Unnecessary comments**: comments explaining what the code does, narrating the change, or referencing the task or caller. Keep only non-obvious why comments such as hidden constraints, subtle invariants, or workarounds

### Pass 3: Efficiency Review

Review the same changes for efficiency:

1. **Unnecessary work**: redundant computations, repeated file reads, duplicate network or API calls, N+1 patterns
2. **Missed concurrency**: independent operations run sequentially when they could run in parallel
3. **Hot-path bloat**: new blocking work added to startup or per-request or per-render hot paths
4. **Recurring no-op updates**: state or store updates inside polling loops, intervals, or event handlers that fire unconditionally. Add a change-detection guard so downstream consumers are not notified when nothing changed. Also, if a wrapper function takes an updater or reducer callback, verify it honors same-reference returns or whatever the no-change signal is so callers' early-return no-ops are not silently defeated
5. **Unnecessary existence checks**: pre-checking file or resource existence before operating. Operate directly and handle the error
6. **Memory**: unbounded data structures, missing cleanup, event listener leaks
7. **Overly broad operations**: reading entire files when only a portion is needed, loading all items when filtering for one

## Phase 3: Fix Issues

If you launched agents, use `wait_agent` to wait for all three to complete.

Aggregate the findings and fix each issue directly.

If a finding is a false positive or not worth addressing, note it and move on. Do not argue with the finding. Skip it.

When done, briefly summarize what was fixed or confirm the code was already clean.
