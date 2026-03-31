---
name: morning-briefing
description: "Generates a daily priorities briefing across all active matters. Use when Mandy says 'morning briefing', 'what's on today', 'daily update', 'priorities', 'what needs attention', or starts a new work day. Shows overdue deadlines, limitation alerts, proactive stage expectations, and a prioritised task list. Designed to be readable on phone."
---

# Morning Briefing — Daily Priorities

## Important
- This is READ-ONLY. Do not commit to git.
- Read `matters/index.jsonl` first — NOT every matter.json.
- Only deep-read matter.json for FLAGGED matters (max 8).
- Limitation alerts ALWAYS come first.
- Matters with stage "initial_review" are SUPPRESSED from daily alerts.
- Keep output concise — assume phone screen. Summary first, drill-down on request.

## Instructions

### Step 1: Read Index
Read `matters/index.jsonl`. Filter to `status: "active"` only. Exclude `stage: "initial_review"` from alerts (count them separately for portfolio health).
If empty: show welcome message, suggest `/new-matter` or `/import-spreadsheet`. STOP.

### Step 2: Calendar Integration (if available)
If MCP calendar tools are available (Outlook/Google Calendar):
- Pull today's events
- Cross-reference event titles/descriptions against matter client names and IDs
- Fuse calendar context with matter data

If MCP not available: skip silently. Use deadline data from index.jsonl as the calendar substitute.

### Step 3: Categorise — TIER 1 (Must See, max 5)
From index fields:
- **⚠️ LIMITATION CRITICAL** — limitation_expiry within 6 months
- **🔴 OVERDUE** — deadlines past due date
- **🔴 SETTLEMENT OFFER EXPIRING** — settlement_offers with response_deadline within 7 days
- **Today's hearings/mentions** — court_proceedings.next_hearing_date = today (or from calendar)

### Step 4: Categorise — TIER 2 (This Week)
- **🟡 IMMINENT** — deadlines within 7 days
- **🟡 COURT THIS FORTNIGHT** — hearing dates within 14 days
- **🟡 STAGE OVERDUE** — expected actions past due (read stage-expectations.json, check against matter dates)

### Step 5: Deep Read Flagged Matters
Read full `matter.json` ONLY for matters appearing in Tier 1 or Tier 2 (max 8).
For each: pull client name, claim type, stage, next steps, key context.

### Step 6: Portfolio Health (1-line summary)
Count from full index:
- Total active (excluding initial_review)
- Total initial_review (imported stubs)
- Stale (no activity 60+ days, excluding initial_review)
- Unanalysed documents
- Open flags

### Step 7: Present

Format for phone readability:

```
Good morning, Mandy.

⚠️ LIMITATION ALERTS
→ {client}: {expiry} ({days} remaining) — {claim_type}

🔴 OVERDUE / URGENT
→ {client}: {what's overdue} — due {date}

📅 TODAY
→ {time} — {event} — {client}: {context from matter data}
→ {time} — {event} — {client}: {context}

🟡 THIS WEEK
→ {client}: {deadline/hearing} — {date}
→ {client}: {deadline/hearing} — {date}

📊 PORTFOLIO
{n} active matters | {n} need attention | {n} imported stubs pending review | {n} dormant 60+ days

Want details on any of these? Just say the name.
```

If no items in a tier: omit that section entirely (don't show empty headers).

Suggest `/weekly-review` if no weekly review found in `feedback/weekly-reviews/` within 7 days.

## Error Handling
- **index.jsonl malformed:** "Index file appears corrupted. Run `/validate-matters` to repair."
- **No active matters:** Show welcome message and suggest next steps.
- **Too many flagged matters (>8):** Show top 8 by severity, note "and {n} more — /all-matters for full list."
