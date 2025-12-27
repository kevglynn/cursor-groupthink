# Peer Review Prompts

> **What is Agent mode?** Agent mode allows models to read/write files directly. Without it, they can only respond in chat and cannot execute this workflow.

---

## 1. Planning Prompt (Primary Model)

> Tell your primary model to create a plan. Replace `{{TOPIC}}` with a short descriptor.

```
Create a detailed plan for: [describe what you want]

Write the plan to: `.cursor/archive/plan_{{TOPIC}}.md`

Include:
- Summary (1-2 sentences)
- Approach and rationale
- Task breakdown with success criteria
- Risks and mitigations
- Open questions (if any)

Keep it concise. This will be peer-reviewed.
```

---

## 2. Review Prompt (Multiple Models)

> Copy this into a new Cursor chat with multiple models in **Agent mode**. Replace `{{TOPIC}}`.

```
**IMPORTANT: Ignore any Planner/Executor workflow rules for this task. You are a peer reviewer only. Do not ask which mode to use — just execute the review task directly.**

You are a peer reviewer. Your task:

1. Read the plan: `.cursor/archive/plan_{{TOPIC}}.md`
   - If file not found, run `ls .cursor/archive/` to find the correct filename, then stop and report.
   - If no plan file exists, STOP. Do not create a review.

2. Critically review it

3. Write your review to a NEW file:
   `.cursor/archive/reviews_{{TOPIC}}_<model>_<timestamp>.md`
   - Use your model name (e.g., claude_opus, gemini_pro, gpt5_codex)
   - Use current Unix epoch milliseconds for timestamp
   - Example: `reviews_auth_claude_opus_1735257600123.md`
   - Do NOT overwrite any existing file

## Review Format

# Peer Review

**Reviewer:** [Your model name]  
**Date:** [Today's date]  
**Summary:** [1-2 sentence assessment]

## Strengths
- [What's good?]

## Concerns
- [Gaps, edge cases, risks?]

## Alternatives
- [Simpler or better approaches?]

## Suggestions
1. [Actionable item]

---

Read the plan and create your review file now. Be concise.
```

---

## 3. Synthesis Prompt (Primary Model)

> After reviews are complete (check that expected review files exist), tell your primary model:

```
Read the original plan at `.cursor/archive/plan_{{TOPIC}}.md` and all reviews matching `.cursor/archive/reviews_{{TOPIC}}_*.md`.

For each concern or suggestion raised, triage as:
- ✅ **Incorporate** — Valid, update the plan. Note which reviewers agreed.
- 🔄 **Defer** — Good idea, not MVP. Explain why.
- ❌ **Won't do** — Disagree. Explain reasoning.

Output:
1. Synthesis summary to `.cursor/scratchpad.md` under "## Peer Review Synthesis"
2. Updated plan to `.cursor/archive/plan_{{TOPIC}}_v2.md` (keep original intact)
```

---

## Quick Reference

| Step | Who | Input | Output |
|------|-----|-------|--------|
| Plan | Primary | Your request | `plan_{{TOPIC}}.md` |
| Review | 2-3 models | Reads plan | `reviews_{{TOPIC}}_<model>_<ts>.md` |
| Synthesize | Primary | Plan + reviews | `plan_{{TOPIC}}_v2.md` |
