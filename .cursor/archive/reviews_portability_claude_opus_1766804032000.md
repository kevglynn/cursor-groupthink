# Peer Review

**Reviewer:** Claude Opus 4.5  
**Date:** 2025-12-26  
**Summary:** Solid layered approach with good separation of concerns. Main concern is reliance on deprecated `.cursorrules` file format and unclear cross-session data flow.

## Strengths

- **Clean three-layer architecture** — Global, project, and manual layers each serve distinct purposes
- **Practical scope** — Avoids over-engineering; focuses on what's needed
- **Risk awareness** — Proactively identifies failure modes with mitigations
- **Clear success criteria** — Each task has measurable completion criteria
- **Good naming conventions** — File patterns like `plan_<topic>.md` and `reviews_<topic>_<model>_<ts>.md` are intuitive

## Concerns

1. **`.cursorrules` may be deprecated** — Cursor has moved to `.cursor/rules/*.mdc` format. Need to verify `.cursorrules` still works in current version.

2. **Cross-session data flow unclear** — Plan says "Planner synthesizes" reviews, but doesn't explain *how* the Planner (running in one chat) sees reviews written by other models in separate chats. The user must manually paste or reference the review files.

3. **"Auto-applied" is misleading** — User Rules apply per-session, not truly automatically across all AI instances. Each model chat starts fresh.

4. **Copy-paste is error-prone** — Heavy reliance on user manually copying prompts. Easy to forget, paste partial content, or use outdated templates.

5. **No validation step** — No way to confirm the workflow is correctly configured in a new project beyond "ask Cursor what rules apply."

## Alternatives

1. **Use `.cursor/rules/peer_review.mdc`** instead of `.cursorrules` — More modular, aligns with current Cursor conventions, and allows multiple rule files.

2. **Single README-based approach** — Instead of three layers, document the entire workflow in one `WORKFLOW.md` that humans and models can reference. Simpler to maintain.

3. **Git template repository** — The plan asks this as an open question, but it's arguably the primary solution for portability. A `cursor-workflow-template` repo that users clone would be more reliable than manual copying.

## Suggestions

1. **Verify Cursor's current config format** — Test whether `.cursorrules` loads in latest Cursor. If deprecated, pivot to `.cursor/rules/` approach.

2. **Add explicit synthesis trigger** — Document that after reviews are written, user must tell Planner: "Read `.cursor/archive/reviews_*` and synthesize feedback."

3. **Create a setup checklist** — For new projects, provide a 5-item checklist users can tick off:
   - [ ] Copy `.cursor/prompts/` folder
   - [ ] Create `.cursorrules` (or equivalent)
   - [ ] Verify rules load with test prompt
   - [ ] etc.

4. **Consider a bootstrap script** — A simple `setup.sh` that copies the required files would be more reliable than manual steps.

5. **Reduce layers** — Layer 1 (User Rules) adds complexity for marginal benefit. Consider dropping it and keeping everything project-local for easier portability.

---

