# Multi-Model Peer Review Workflow

Stress-test AI plans using multiple frontier models before execution.

## Why

Single models have blind spots. Running plans through 2-3 different models catches edge cases, reduces over-confidence, and surfaces better alternatives — like a team of senior engineers reviewing each other's designs.

## Quick Start

1. **Plan** — Tell primary model what you want → writes `plan_{{TOPIC}}.md`
2. **Review** — Paste [review prompt](.cursor/prompts/peer_review_prompt.md#2-review-prompt-multiple-models) into multi-model chat (Agent mode)
3. **Check** — Verify expected review files exist before proceeding
4. **Synthesize** — Primary model reads all files → creates `plan_{{TOPIC}}_v2.md`

No copy-paste needed between steps — everything is file-based.

---

## New Project Setup

### Option 1: Run the Setup Script (Easiest)

```bash
# From anywhere, run:
/path/to/cursor-groupthink/setup.sh /path/to/your-new-project

# Or if you're in the new project directory:
/path/to/cursor-groupthink/setup.sh .
```

### Option 2: Add to PATH (Run from Anywhere)

```bash
# Add to your shell profile (~/.zshrc or ~/.bashrc):
export PATH="$PATH:/Users/kevinglynn/cursor-groupthink"

# Then from any project:
cd /path/to/new-project
setup.sh .
```

### Option 3: Manual Copy

```bash
cp -r /path/to/cursor-groupthink/.cursor /path/to/new-project/
cp /path/to/cursor-groupthink/.cursorrules /path/to/new-project/
```

### Verify Setup

Open a new Cursor chat in the project and ask:
> "What project rules are active?"

You should see **"Peer Review Workflow Rules"**.

---

## Files

| Path | Purpose |
|------|---------|
| [`setup.sh`](setup.sh) | One-command setup for new projects |
| [`.cursorrules`](.cursorrules) | Project rules (auto-loaded by Cursor) |
| [`.cursor/prompts/peer_review_prompt.md`](.cursor/prompts/peer_review_prompt.md) | All prompts (plan, review, synthesize) |
| `.cursor/archive/plan_<topic>.md` | Original plan |
| `.cursor/archive/plan_<topic>_v2.md` | Updated plan after synthesis |
| `.cursor/archive/reviews_<topic>_<model>_<ts>.md` | Individual reviews |

---

## Lessons Learned

- **Concurrent writes overwrite** — Use unique filenames (model + timestamp), not single file.
- **LLM "random" isn't random** — Use timestamps, not model-generated strings.
- **Keep originals** — Synthesis creates `_v2.md`, preserving the original for comparison.
- **Project-scoped rules only** — Don't modify global User Rules; keep everything in `.cursorrules` for portability.
- **Planner/Executor conflict** — Review prompt now explicitly tells models to ignore Planner/Executor rules.

---

## Compatibility

Works with existing Planner/Executor workflows. The review prompt includes instructions to bypass Planner/Executor mode selection.
