# Discussion: Multi-Model Peer Review Workflow Design

> **Purpose:** This document captures the discussion and design decisions for implementing a multi-model peer review workflow in Cursor. It is itself subject to peer review — please critique this approach!

---

## The Problem We're Solving

When using AI to plan complex features, a single model can have blind spots, over-confidence, or biases from its training. We want to leverage multiple frontier models (Claude, Gemini, GPT, etc.) to stress-test plans before execution — similar to how a team of senior engineers would review each other's designs.

---

## Proposed Workflow Overview

### Phase 1: Initial Planning (Primary Model)
- Primary model (Claude) reviews project state and generates a detailed plan
- Plan includes: task breakdown, technical approach, risk assessment, testing strategy
- Output documented in `scratchpad.md`

### Phase 2: Peer Review (Multiple Models)
- User copies plan to 2-3 other frontier models via Cursor's multi-model agent mode
- Each model provides critical review looking for:
  - Logical gaps or flaws
  - Edge cases not considered
  - Better/simpler alternatives
  - Security or performance concerns
  - Over-engineering or under-engineering
- Reviews saved to `.cursor/archive/`

### Phase 3: Synthesis (Primary Model)
- Primary model reads all peer feedback
- Each suggestion triaged as:
  - ✅ **Incorporate** — Valid concern, update the plan
  - 🔄 **Nice to Have** — Good idea, defer to future iteration
  - ❌ **Won't Incorporate** — Disagree or out of scope (with reasoning)
- Final plan documented with rationale
- User approves before execution

### Phase 4: Execution
- Incremental implementation, one task at a time
- Verification after each task
- Documentation of progress and lessons learned

---

## Key Design Decision: Preventing File Collisions

### The Challenge

In Cursor's multi-model agent mode, all models receive the same prompt simultaneously. If each model tries to write to a file named by its own identity (e.g., `claude_review.md`, `gemini_review.md`), we face risks:

1. **Self-identification may fail** — Models might not reliably know their own name
2. **Filename collisions** — Two models might pick the same name
3. **Overwrites** — Later writes could destroy earlier content

### Options Considered

| Option | Approach | Pros | Cons |
|--------|----------|------|------|
| **Separate files by model name** | Each model writes to `<model>_<topic>.md` | Clear ownership | Relies on self-ID; collision risk |
| **Timestamp-based filenames** | Each model writes to `review_<topic>_<timestamp>.md` | Unique if timing differs | Sub-second collision possible |
| **Random hash suffix** | Each model writes to `review_<topic>_<random>.md` | Guaranteed unique | Lose track of which model wrote what |
| **Single file with sections** | All models append to ONE file with marked sections | Zero collision; easy synthesis | Potential race conditions on append |

### Decision: Single File with Sections

We chose **Option 4: Single file with sections** because:

1. **Zero collision risk** — All models write to the same file
2. **All reviews in one place** — Easy to read and synthesize
3. **Model identity in content** — Each model self-identifies within their section, not in filename
4. **Append operations are safer** — Even with race conditions, markdown sections are self-contained

### Format Chosen

```markdown
=== REVIEW START ===
**Reviewer:** [Model self-identifies here]
**Timestamp:** [Auto-generated]
... structured critique ...
=== REVIEW END ===
```

---

## Open Questions for Peer Review

1. **Is single-file append actually safe in Cursor's agent mode?** What happens if two models try to append simultaneously?

2. **Should we use a more structured format?** (e.g., JSON, YAML) for easier programmatic parsing during synthesis?

3. **How do we signal completion?** How does the user know all models have finished their reviews?

4. **Is there a better orchestration approach?** Should we use separate chat windows instead of multi-model mode for more control?

5. **What's the right number of reviewers?** Is 3 optimal, or would 2 or 4 be better?

6. **Should reviews be anonymous?** Would removing model identity reduce bias in synthesis?

---

## File Structure

```
.cursor/
├── scratchpad.md                           # Living project plan (Planner/Executor)
├── prompts/
│   └── peer_review_prompt.md               # Template for peer review requests
└── archive/
    ├── reviews_<topic>.md                  # Combined reviews for a topic
    └── discussion_<topic>.md               # Design discussions (like this one)
```

---

## Request for Reviewers

Please critique this workflow design. Specifically consider:

1. **Will this actually work in practice?** Are there failure modes we haven't considered?
2. **Is it too complex?** Could we achieve the same benefit with a simpler approach?
3. **What's missing?** Are there important aspects of peer review we haven't addressed?
4. **Better alternatives?** Do you know of a fundamentally better approach?

Append your review using the standard format below.

---

=== REVIEWS START BELOW THIS LINE ===


