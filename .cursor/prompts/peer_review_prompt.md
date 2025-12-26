# Multi-Model Peer Review Prompt

> **Instructions:** Copy everything below the line into a new Cursor chat with multiple models selected in Agent mode. Replace `{{TOPIC_TITLE}}` with a short descriptor (e.g., `auth_refactor`, `api_redesign`).

---

## Prompt to Copy:

```
You are participating in a multi-model peer review. Your task is to critically review a plan and document your feedback.

## Your Mission

1. **Read** the plan/proposal below carefully
2. **Critique** it from your unique perspective as a senior engineer
3. **Append** your review to the shared review file

## Output Instructions

**IMPORTANT:** Append your review to this file:
`.cursor/archive/reviews_{{TOPIC_TITLE}}.md`

Use this exact format when appending:

---

=== REVIEW START ===
**Reviewer:** [State your model name/identity]
**Timestamp:** [Current date/time]
**Overall Assessment:** [1-2 sentence summary]

### Strengths
- [What's good about this plan?]

### Concerns & Gaps
- [Logical gaps or flaws?]
- [Edge cases not considered?]
- [Security or performance issues?]

### Alternative Approaches
- [Simpler or better ways to achieve this?]

### Specific Suggestions
1. [Concrete, actionable suggestion]
2. [Another suggestion]

### Risk Assessment
- **Severity:** [Low/Medium/High]
- **Key Risk:** [What could go wrong?]

=== REVIEW END ===

---

## The Plan to Review:

{{PASTE_THE_PLAN_HERE}}

---

Now write your review. Be thorough but concise. Focus on what matters most.
```

---

## After All Reviews Are Complete

Tell your primary chat:

> "Please read `.cursor/archive/reviews_{{TOPIC_TITLE}}.md` and synthesize the peer feedback. Triage each suggestion as: ✅ Incorporate, 🔄 Nice to Have, or ❌ Won't Incorporate (with reasoning)."

