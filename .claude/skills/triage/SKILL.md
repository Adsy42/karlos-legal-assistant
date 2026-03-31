---
name: triage
description: "Deep review of a dormant or unfamiliar matter. Use when Mandy says 'triage', 'review file', 'catch me up', 'what's happening with', 'where did we leave off', or comes back to a matter after a long gap. Different from /matter-status — this is proactive gap analysis with recommendations, not just current state."
---

# Triage — Deep File Review

## Important
- Manual-only. Resolve matter first.
- READ-ONLY initially. Only write if Mandy confirms updates.
- Focus on: what's missing, what's overdue, what's the next critical action.

## Instructions

### Step 0: Resolve Matter
Follow `_shared/resolve-matter.md`.

### Step 1: Full Read
Read matter.json completely. Read ALL .extract.json files (Tier 1). Read activity-log.jsonl (last 30 entries). Read all files in notes/. Check letters/ for drafts and sent items. Git history: `git -C matters/ log --oneline -20 -- {id}/`

### Step 2: Time Since Last Activity
Calculate days since last git commit or activity log entry. Flag if > 30 days.

### Step 3: Data Completeness Audit
Check each section of matter.json against what's expected for this claim type and stage:
- Client: DOB, contact details, interpreter needs
- Dates: DOI, limitation, key milestones
- Injury: body parts, diagnoses, work capacity
- Employer/insurer: names, contacts, claim number
- Parties: treating doctors, specialists
- Documents: any PDFs without extracts?
- Letters: any drafts unsent > 7 days?
- Compliance: costs disclosure, authority to release, conflict check
- Court proceedings: if litigation stage — proceeding number, solicitors, next hearing
- Serious injury: if applicable — certificate status

### Step 4: Stage Expectations Check
Read rules/stage-expectations.json for current stage. Check every expected action. Flag overdue items.

### Step 5: Deadline Review
Read rules/deadlines.json. Calculate ALL applicable deadlines for this claim type. Compare against matter dates. Flag any overdue or imminent (< 30 days).

### Step 6: Present Triage Report
```
TRIAGE: {id} — {client_name}
Type: {claim_type} | Stage: {stage} | Last activity: {date} ({n} days ago)

LIMITATION: {expiry} ({days} remaining) {⚠️ if < 12 months}

DATA GAPS (fields missing that should be populated by now):
• {field}: {why it matters}

OVERDUE ACTIONS:
• {action}: expected within {n} days of {trigger}, now {n} days overdue

UPCOMING DEADLINES:
• {deadline}: {date} ({days} remaining)

DOCUMENTS: {n} total, {n} unanalysed
LETTERS: {n} drafts, {n} sent

RECOMMENDED NEXT STEPS (prioritised):
1. {highest priority action}
2. {next action}
3. {next action}

Want me to update any of this now?
```

### Step 7: Offer Actions
Based on gaps found, suggest specific skills:
- Missing data → "/update-matter {name}"
- Unanalysed docs → "/analyse-document {name} {file}"
- No chronology → "/build-chronology {name}"
- Letters needed → "/draft-letter {name} {type}"
- Stage wrong → "Should this be at {suggested_stage}?"
