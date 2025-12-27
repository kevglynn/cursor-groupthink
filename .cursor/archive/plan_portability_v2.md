# Plan: Make Workflow Portable Across Projects (v2)

**Author:** Claude Opus 4.5  
**Date:** 2025-12-26  
**Version:** 2.0  
**Status:** Post peer-review synthesis

---

## Summary

Establish a **project-scoped only** configuration approach so the multi-model peer review workflow can be reused across projects with minimal setup. 

> **Key change from v1:** Eliminated global User Rules layer. Everything is now project-local and version-controlled.

---

## Approach

Use **two layers** (simplified from three):

| Layer | Scope | File | Version-Controlled? |
|-------|-------|------|---------------------|
| **Project Rules** | This project | `.cursorrules` | ✅ Yes |
| **Prompt Templates** | Manual trigger | `.cursor/prompts/` | ✅ Yes |

### Why Not Global User Rules?

Per peer review feedback (all 6 reviewers):
- Global rules affect ALL projects, causing cross-project interference
- Not version-controlled — collaborators won't have them
- Breaking change if workflow evolves

### Project Rules (`.cursorrules`)

Create at project root with version metadata:

```markdown
# Peer Review Workflow
# Version: 1.0

This project uses multi-model peer review.

## File Conventions
- Plans: `.cursor/archive/plan_<topic>.md`
- Reviews: `.cursor/archive/reviews_<topic>_<model>_<ts>.md`
- Updated plans: `.cursor/archive/plan_<topic>_v2.md`

## When to Peer Review
- YES: High-risk changes, architecture, uncertainty
- NO: Bug fixes, styling, simple CRUD

## Workflow
1. Planner creates plan in `.cursor/archive/plan_<topic>.md`
2. User triggers peer review via multi-model chat (see `.cursor/prompts/peer_review_prompt.md`)
3. User tells Planner to synthesize reviews from `.cursor/archive/reviews_<topic>_*.md`
```

### Prompt Templates

Keep `.cursor/prompts/peer_review_prompt.md` as-is. Manual copy-paste required for:
- Multi-model review chats (cannot be automated)
- Synthesis trigger

---

## Task Breakdown

### 1. **Verify Cursor config format**
Test whether `.cursorrules` or `.cursor/rules/*.md` is preferred in current Cursor version.
- Success: Confirmed working format documented

### 2. **Create `.cursorrules`**
Create project-level rules file with version metadata.
- Success: File exists, includes version header

### 3. **Verify rules loaded**
Ask Cursor: "What project rules are currently active?" to confirm loading.
- Success: Rules appear in response

### 4. **Document portability in README**
Add "New Project Setup" section with copy instructions.
- Success: README has clear 3-step setup

---

## Risks

| Risk | Mitigation |
|------|------------|
| Rules not loaded by Cursor | Task 3 includes verification test |
| User forgets to copy prompts | README checklist includes prompts |
| Rules become outdated | Version header allows staleness detection |
| `.cursorrules` format deprecated | Task 1 verifies current format |

---

## Open Questions (Deferred)

1. ~~Should we create a GitHub template repository?~~ → **Defer.** Prove manual approach first.
2. ~~Is there value in a CLI/bootstrap script?~~ → **Defer.** Ship docs, automate later.

---

## Changes from v1

| Change | Reason |
|--------|--------|
| Removed User Rules layer | All 6 reviewers flagged portability issues |
| Added version metadata | 4 reviewers requested staleness detection |
| Added "verify rules loaded" task | 4 reviewers wanted validation step |
| Collapsed Task 2 into Task 1 | 3 reviewers noted redundancy |
| Added Cursor format verification task | 4 reviewers uncertain about config format |

