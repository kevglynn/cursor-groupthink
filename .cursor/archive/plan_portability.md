# Plan: Make Workflow Portable Across Projects

**Author:** Claude Opus 4.5  
**Date:** 2025-12-26  
**Status:** Awaiting peer review

---

## Summary

Establish a layered configuration approach so the multi-model peer review workflow can be reused across projects with minimal setup.

## Approach

Use three layers, each with a specific purpose:

| Layer | Scope | File | Auto-applied? |
|-------|-------|------|---------------|
| **User Rules** | All projects | Cursor Settings | Yes |
| **Project Rules** | This project | `.cursorrules` | Yes |
| **Prompt Templates** | Manual trigger | `.cursor/prompts/` | No (copy-paste) |

### Layer 1: User Rules (Global)

Add to existing Planner/Executor rules in Cursor Settings:

```markdown
## Peer Review Phase (Optional)
Between Planning and Execution, complex plans may go through multi-model peer review.
- User triggers review by pasting prompts to other models
- Reviews land in `.cursor/archive/reviews_*` files
- Planner synthesizes before Executor begins
- See `.cursor/prompts/peer_review_prompt.md` for workflow
```

### Layer 2: Project Rules

Create `.cursorrules` at project root:

```markdown
# Peer Review Workflow

This project uses multi-model peer review.

## File Conventions
- Plans: `.cursor/archive/plan_<topic>.md`
- Reviews: `.cursor/archive/reviews_<topic>_<model>_<ts>.md`
- Updated plans: `.cursor/archive/plan_<topic>_v2.md`

## When to Peer Review
- YES: High-risk changes, architecture, uncertainty
- NO: Bug fixes, styling, simple CRUD
```

### Layer 3: Prompt Templates

Keep `.cursor/prompts/peer_review_prompt.md` as-is. Manual copy-paste required for:
- Multi-model review chats (cannot be automated)
- Synthesis trigger

## Task Breakdown

1. **Create `.cursorrules`** — Project-level rules file
   - Success: File exists, Cursor loads it automatically

2. **Draft user rules addition** — Text for user to paste into Cursor Settings
   - Success: Clear instructions provided

3. **Document portability options** — How to reuse in new projects
   - Success: README updated with "New Project Setup" section

## Risks

| Risk | Mitigation |
|------|------------|
| Rules not loaded by Cursor | Verify with test prompt asking "what rules apply?" |
| User forgets to copy prompts | Include reminder in project rules |
| Updates don't propagate | Document manual sync or use git submodule |

## Open Questions

1. Should we create a GitHub template repository for easy project bootstrapping?
2. Is there value in a CLI tool to scaffold the `.cursor` folder?

