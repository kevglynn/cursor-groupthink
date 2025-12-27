# Peer Review

**Reviewer:** Claude Opus 4.5  
**Date:** 2025-12-26  
**Summary:** Solid layered approach with clear separation of concerns. However, the `.cursorrules` convention may be outdated—Cursor now prefers `.cursor/rules/` directories—and the plan lacks synthesis guidance.

## Strengths
- Clean 3-layer architecture (global → project → manual) maps well to Cursor's rule hierarchy
- Pragmatic acceptance that multi-model review requires manual copy-paste
- Risk table shows forethought; "rules not loaded" verification is smart
- Simple, predictable file naming conventions

## Concerns
- **`.cursorrules` may be deprecated:** Modern Cursor uses `.cursor/rules/*.md` files with frontmatter. Verify which format the IDE currently respects before implementing.
- **No synthesis protocol:** Plan ends at "reviews land in files." Who synthesizes? What triggers it? How are conflicts resolved? This is a workflow gap.
- **User rules snippet is minimal:** The 4-line addition may not give models enough context to understand when/how to invoke the workflow.
- **Prompt template versioning:** If `peer_review_prompt.md` changes, how do existing projects stay in sync? Git submodules are mentioned but not specified.
- **No "when to skip" enforcement:** The guidance says "NO: bug fixes, styling" but there's no mechanism to prevent overkill.

## Alternatives
1. **Use `.cursor/rules/peer_review.md`** instead of `.cursorrules` for project rules—more consistent with Cursor's current architecture.
2. **Add a synthesis trigger prompt** to `.cursor/prompts/` so the final aggregation step is also templated.
3. **Create a bootstrap script** (`./scripts/init-peer-review.sh`) that copies the necessary files into a new project, reducing manual error.

## Suggestions
1. Verify `.cursorrules` vs `.cursor/rules/` by testing in a fresh Cursor session before proceeding.
2. Add a `synthesis_prompt.md` template that instructs the Planner how to reconcile reviews.
3. Expand the user rules snippet to include a brief example of triggering peer review.
4. In Task Breakdown, add step 4: "Test portability in a clean project."

---

