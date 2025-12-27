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

### Decision: Single File with Sections ❌ SUPERSEDED

> **Update (2025-12-26):** This decision was proven wrong. See [Outcome](#outcome) below. We now use **timestamp-based unique filenames**.

~~We chose **Option 4: Single file with sections** because:~~
1. ~~Zero collision risk~~
2. ~~All reviews in one place~~
3. ~~Model identity in content~~
4. ~~Append operations are safer~~

**What actually happened:** All models writing concurrently overwrote each other. Only one review survived.

### Current Decision: Model Name + Timestamp Filenames ✅

Each model writes to: `reviews_<topic>_<model>_<unix_epoch_ms>.md`

Example: `reviews_auth_claude_opus_1735257600123.md`

- **Zero collision** — Model name + timestamp guarantees uniqueness even within same millisecond
- **Model identity in filename AND content** — Belt and suspenders
- **No overwrite instruction** — Prompt explicitly says "do NOT overwrite"
- **Versioned synthesis** — Creates `plan_<topic>_v2.md`, keeps original intact

---

## Open Questions for Peer Review

> **Status:** Most questions resolved through testing. See [Outcome](#outcome).

1. ~~**Is single-file append actually safe?**~~ → **No.** Concurrent writes overwrite. Use unique filenames.

2. ~~**Structured format (JSON/YAML)?**~~ → **Deferred.** Markdown is human-readable; automate later if needed.

3. ~~**Completion signaling?**~~ → **Manual check.** Count review files before synthesis. Simple enough for MVP.

4. ~~**Separate chat windows vs multi-model?**~~ → **Multi-model works** with unique filenames.

5. **Right number of reviewers?** → 2-3 seems optimal. More adds noise, fewer loses diversity.

6. ~~**Anonymous reviews?**~~ → **No.** Model identity helps understand biases during synthesis.

---

## File Structure

```
.cursor/
├── scratchpad.md                              # Living project plan (Planner/Executor)
├── prompts/
│   └── peer_review_prompt.md                  # All prompts (plan, review, synthesize)
└── archive/
    ├── plan_<topic>.md                        # Original plan
    ├── plan_<topic>_v2.md                     # Updated plan after synthesis
    ├── reviews_<topic>_<model>_<ts>.md        # Individual reviews
    └── discussion_<topic>.md                  # Design discussions
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

---

## Outcome

**Test Date:** 2025-12-26

### What Happened

We tested the single-file append approach with 4 models (Opus 4.5, GPT-5.1 Codex, Gemini 3 Pro, Sonnet 4.5). All four correctly identified the race condition risk in their reviews — and then **fell victim to it**. Each model's write overwrote the previous, leaving an empty file.

### Verdict

❌ **Single-file append does not work** with concurrent agent writes.

✅ **Solution:** Timestamp-based filenames (`reviews_<topic>_<unix_epoch_ms>.md`). Each model writes to a unique file. Model identity stays in content header.

> **Why timestamp, not random hash?** LLMs are deterministic — they generate predictable "random" strings (like `a1b2c3`). Timestamps are guaranteed unique. Feedback from Gemini, Sonnet, and GPT all flagged this.

### Feedback Incorporated

| Change | Source |
|--------|--------|
| Switch to unique filenames (now: model + timestamp) | All 4 models |
| Add "when to use" guidance | Sonnet |
| Keep model ID in content, not filename | Opus |

### Feedback Deferred

- Sequential reviews (loses parallelism)
- Structured data format (JSON/YAML)
- Role-based reviewer specialization
- Cost/time tracking

See updated prompt: [peer_review_prompt.md](../prompts/peer_review_prompt.md)

