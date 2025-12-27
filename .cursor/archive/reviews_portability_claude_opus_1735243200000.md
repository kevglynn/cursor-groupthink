# Peer Review

**Reviewer:** Claude Opus 4.5  
**Date:** 2025-12-26  
**Summary:** Solid layered approach with clear separation of concerns. However, the heavy reliance on manual steps undermines the "portable" goal—more could be automated.

## Strengths

- **Clear layering** — User/Project/Prompt separation makes sense and aligns with Cursor's configuration model
- **Pragmatic scope** — Focuses on minimal viable setup rather than over-engineering
- **Good file conventions** — Consistent naming patterns (`plan_*`, `reviews_*`) aid discoverability
- **Risk awareness** — Identifies key failure modes upfront

## Concerns

- **"Auto-applied" is misleading** — User Rules require manual paste into Cursor Settings; they're not truly auto-applied
- **No prompt versioning** — If `peer_review_prompt.md` evolves, old projects get stale. No sync mechanism defined
- **Missing validation step** — Task 1 says "Cursor loads it automatically" but no concrete test provided (e.g., ask Cursor "list active rules")
- **Git submodule is heavy** — For simple file syncing, submodules add significant complexity (merge conflicts, detached heads)
- **Open questions may be distractions** — CLI scaffolding and GitHub templates are premature; ship manual first

## Alternatives

- **Use `.cursor/rules/` directory** — Cursor supports `*.mdc` rule files that auto-apply; more modular than single `.cursorrules`
- **Git subtree over submodule** — Simpler mental model if sharing is needed
- **Skip User Rules addition** — Project rules are sufficient; adding to global settings risks conflicts between projects

## Suggestions

1. **Add a verification task** — After creating `.cursorrules`, include a test: "Ask Cursor: 'What project rules are active?'"
2. **Rename "auto-applied" column** — Use "Scope-applied" or clarify User Rules require one-time manual setup
3. **Defer open questions** — Mark as "Future" and proceed with manual approach first
4. **Add prompt checksum/version** — Simple header like `Version: 1.0` in prompt templates helps detect staleness

---

