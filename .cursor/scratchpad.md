# Project Scratchpad

## Background and Motivation

Making the multi-model peer review workflow portable across projects.

## Peer Review Synthesis (portability plan)

**Date:** 2025-12-26  
**Reviewers:** 4× Opus 4.5, Sonnet 4.5, Gemini 3 Pro

### ✅ Incorporated
- Eliminated global User Rules layer (all 6 reviewers)
- Added validation task (4 reviewers)
- Added version metadata to rules (4 reviewers)
- Collapsed redundant tasks (3 reviewers)
- Added Cursor format verification (4 reviewers)

### 🔄 Deferred
- ~~Bootstrap script (ship manual first)~~ → **Completed:** `setup.sh` and `setup-submodule.sh` created
- Template repository (prove approach first)

### ❌ Won't Do
- Single file + git history (want explicit v2 comparison)

**Output:** `.cursor/archive/plan_portability_v2.md`

---

## Enhancement: Git Submodule Support

**Date:** 2025-12-26  
**Status:** Completed

### What Was Added

1. **`setup-submodule.sh`** — Automated setup script that creates symlinks from project to submodule
2. **`SUBMODULE_SETUP.md`** — Complete guide for using workflow as git submodule
3. **README updates** — Added "Option 3: Git Submodule" to setup instructions

### Why This Enhancement

Addresses two items from the original plan:
- **Deferred item:** Bootstrap script (now completed with both `setup.sh` and `setup-submodule.sh`)
- **Risk mitigation:** "Updates don't propagate" — submodule approach solves this with symlinks

### Comparison

| Approach | Best For | Updates |
|----------|----------|---------|
| Copy (`setup.sh`) | One-off projects, beginners | Manual re-copy |
| Submodule (`setup-submodule.sh`) | Multiple projects, teams | Auto-sync via git pull |

Both options are now documented and available.

---

## High-level Task Breakdown

From `plan_portability_v2.md`:

1. **Verify Cursor config format** — Test `.cursorrules` vs `.cursor/rules/`
2. **Create `.cursorrules`** — Project-level rules with version metadata
3. **Verify rules loaded** — Ask Cursor to confirm
4. **Document in README** — Add "New Project Setup" section

## Project Status Board

- [x] Create initial plan (`plan_portability.md`)
- [x] Run peer review (6 reviews received)
- [x] Synthesize feedback
- [x] Create updated plan (`plan_portability_v2.md`)
- [x] Execute Task 1: Verify Cursor config format (using `.cursorrules`)
- [x] Execute Task 2: Create `.cursorrules` with version metadata
- [x] Execute Task 3: Verify rules loaded ✅ CONFIRMED WORKING
- [x] Execute Task 4: Update README with setup instructions
- [x] Enhancement: Add git submodule support (addresses "updates don't propagate" risk)
  - Created `setup-submodule.sh` for automated symlink setup
  - Created `SUBMODULE_SETUP.md` documentation
  - Updated README with submodule option

## Executor's Feedback or Assistance Requests

Awaiting user approval to proceed with execution tasks.

## Lessons

- Include info useful for debugging in the program output.
- Read the file before you try to edit it.
- If there are vulnerabilities that appear in the terminal, run npm audit before proceeding
- Always ask before using the -force git command
- **Multi-model peer review works!** 6 models successfully created unique review files using model+timestamp naming.
- **User Rules interfere with reviewer prompts** — One model (GPT) asked about Planner/Executor mode. Consider adding "Ignore Planner/Executor rules" to review prompt.
- **Submodule approach vs copy approach** — Submodule with symlinks is better for multi-project setups (auto-updates), but copy approach is simpler for one-off projects. Both options documented in README.
