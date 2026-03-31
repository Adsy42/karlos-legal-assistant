# Karlos Lawyers — AI Legal Assistant

## User Manual for Mandy

This is your AI-powered legal assistant. It manages your entire personal injury caseload — matter intake, document analysis, letter drafting, deadline tracking, settlement calculations, and compliance monitoring — all from a single terminal window.

**You talk to it in plain English. It does the paperwork.**

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Daily Workflow](#daily-workflow)
3. [All Commands at a Glance](#all-commands-at-a-glance)
4. [Matter Management](#matter-management)
5. [Document Analysis](#document-analysis)
6. [Letter Drafting and Sending](#letter-drafting-and-sending)
7. [Deadlines and Compliance](#deadlines-and-compliance)
8. [Settlement Financials](#settlement-financials)
9. [File Notes](#file-notes)
10. [Search and Reporting](#search-and-reporting)
11. [Undo and Audit Trail](#undo-and-audit-trail)
12. [Claim Types Supported](#claim-types-supported)
13. [Matter Stages](#matter-stages)
14. [How Letters Work](#how-letters-work)
15. [How Documents Work](#how-documents-work)
16. [Proactive Alerts](#proactive-alerts)
17. [Data Safety and Privacy](#data-safety-and-privacy)
18. [Weekly Review](#weekly-review)
19. [Troubleshooting](#troubleshooting)
20. [Quick Reference Card](#quick-reference-card)

---

## Getting Started

### Prerequisites

- Node.js 18+
- Claude Code (`npm install -g @anthropic-ai/claude-code`)
- pdftotext (`sudo apt install poppler-utils`)
- Claude Max subscription

### First-Time Setup

```bash
cd ~/Documents/karlos-legal-assistant
./scripts/setup.sh
```

### Launching

```bash
cd ~/Documents/karlos-legal-assistant
claude
```

Once inside, type `/morning-briefing` to start your day, or `/help` for a quick command list.

### How to Talk to It

You can use **slash commands** or **plain English** — or both.

| You say... | What happens |
|---|---|
| `/morning-briefing` | Shows your daily priorities dashboard |
| `/new-matter` | Starts a new client intake |
| `/matter-status chen` | Shows Sarah Chen's matter status |
| "insurer rejected Chen's claim yesterday" | Updates the matter automatically |
| "draft a notice of involvement for chen" | Drafts the letter using the right template |

**Key principle:** Use client names, not file IDs. Say "chen" or "sarah chen", not "WC-2026-012". The system resolves names for you. If you don't specify a name, it uses the matter you were most recently discussing.

---

## Daily Workflow

Here's what a typical day looks like:

### Morning

```
/morning-briefing
```

This shows you everything that needs attention today:
- **Limitation period alerts** (always shown first — these are critical)
- Overdue deadlines
- This week's upcoming deadlines
- Stage expectations you haven't completed yet
- Unanalysed documents sitting in matter folders
- Open flags and warnings
- Matters with no activity in 30+ days
- Draft letters waiting for approval
- A prioritised task list for the day

### During the Day

Work through your tasks naturally:

```
/matter-status chen              — Check where things stand
/draft-letter chen treatment-rejection-dispute   — Write a letter
/approve-letter chen treatment-rejection-dispute-2026-03-28.md  — Approve it
/send-letter chen treatment-rejection-dispute-2026-03-28.md     — Send via Outlook
/analyse-document chen report.pdf   — Ingest a new medical report
/add-note chen                   — Record a phone call or conference
/update-matter chen              — Update after an insurer decision
```

Or just talk:

> "Just spoke to the insurer on Chen's matter. They've rejected the claim as of today. We need to apply for conciliation."

The system will update the matter, calculate the 60-day conciliation deadline, and suggest next steps.

### End of Week

```
/weekly-review
```

A 5-minute check-in: what happened this week, what needs improving, any matters drifting.

---

## All Commands at a Glance

### Daily

| Command | What It Does |
|---|---|
| `/morning-briefing` | Daily priorities dashboard with all alerts |
| `/help` | Quick reference of all available commands |

### Matter Lifecycle

| Command | What It Does |
|---|---|
| `/new-matter` | Create a new matter from intake consultation |
| `/matter-status chen` | Full status summary for a matter |
| `/update-matter chen` | Update matter details (stage, insurer decision, new info) |
| `/all-matters` | Pipeline view of entire caseload grouped by stage |
| `/search-matters allianz` | Search matters by client, insurer, claim type, stage, flags |
| `/matter-history chen` | Full audit trail of all changes to a matter |
| `/close-matter chen` | Archive a completed matter |
| `/undo chen` | Revert the last change (supports depth: `/undo chen 3`) |
| `/validate-matters` | Check data integrity across all matters |

### Documents

| Command | What It Does |
|---|---|
| `/analyse-document chen report.pdf` | Ingest and analyse a PDF document |
| `/build-chronology chen` | Build a medical chronology from all analysed documents |

### Letters

| Command | What It Does |
|---|---|
| `/draft-letter chen notice-of-involvement` | Draft correspondence using templates |
| `/approve-letter chen filename.md` | Mark a draft as ready to send |
| `/send-letter chen filename.md` | Send an approved letter via Outlook |

### Deadlines and Money

| Command | What It Does |
|---|---|
| `/calculate-deadline chen insurer_decision 2026-03-15` | Calculate a legal deadline |
| `/settlement-financials chen 150000` | Calculate settlement breakdown |

### Notes

| Command | What It Does |
|---|---|
| `/add-note chen` | Record a file note (phone call, conference, instruction) |

### System

| Command | What It Does |
|---|---|
| `/weekly-review` | Friday check-in for system and practice review |

---

## Matter Management

### Creating a New Matter (`/new-matter`)

You can either use the command directly or just describe the consult:

> "Just had a consult with Sarah Chen. She hurt her back lifting boxes at Woolworths on January 12th. WorkCover claim. She's off work, seeing Dr Smith as her GP. She wants to know if she can get surgery approved."

The system will:
1. **Extract** all details from your conversation (name, employer, DOI, claim type, treating doctors, work status, goals)
2. **Run a conflict check** against all existing matters
3. **Show you a summary** and ask you to confirm
4. **Ask only about gaps** — it won't pester you for things typically unknown at intake (claim numbers, WPI, etc.)
5. **Create the matter** with a unique ID (e.g., WC-2026-012)
6. **Calculate all deadlines** including limitation period
7. **Draft initial letters** (notice of involvement + engagement/retainer for WorkCover/TAC)
8. **Present a summary** with next steps

### Updating a Matter (`/update-matter`)

Tell it what changed naturally:

> "Insurer rejected Chen's claim yesterday"

It will:
- Update the stage to `insurer_rejected`
- Calculate the 60-day conciliation deadline
- Suggest follow-up actions (advise client, prepare conciliation application)

### Viewing Status (`/matter-status`)

```
/matter-status chen
```

Shows: client details, current stage, all deadlines, documents, letters, flags, recent activity, and what's expected next based on the stage.

### Closing a Matter (`/close-matter`)

```
/close-matter chen
```

Before closing, it checks for loose ends: unsent draft letters, unanalysed documents, open flags, missing costs disclosure. It will warn you before archiving.

---

## Document Analysis

### Ingesting a Document (`/analyse-document`)

1. Save the PDF to `matters/{id}/documents/`
2. Run the command:

```
/analyse-document chen report.pdf
```

The system will:
- Read the full PDF (this is the one time it reads the whole thing)
- Classify the document type (GP report, specialist report, IME, insurer letter, etc.)
- Rename it to a standard format (e.g., `specialist-report-dr-jones-2026-03-15.pdf`)
- Create a structured `.extract.json` alongside it with: diagnoses, causation, work capacity, treatment, prognosis, impairment, key quotes, and chronology entries
- **Cross-reference** with existing documents — flagging contradictions, changed capacity, conflicting causation
- Update the matter with any new information
- Suggest stage changes if appropriate

After ingestion, all future operations (briefings, chronologies, letter drafting) use the lightweight extract rather than re-reading the full PDF.

### Building a Chronology (`/build-chronology`)

```
/build-chronology chen
```

Collects all chronology entries from every analysed document, merges them into a timeline, and runs gap analysis:
- Treatment gaps (3+ months for same body part)
- Missing initial consultation
- Certificate of Capacity gaps
- Contradictions between providers
- Missing impairment assessments
- Unexplained changes in work capacity

Saves to `chronology/chronology-{date}.md` in the matter folder.

---

## Letter Drafting and Sending

### The Three-Step Letter Workflow

Letters follow a strict **Draft, Approve, Send** process. Nothing goes out without your explicit approval.

#### Step 1: Draft

```
/draft-letter chen notice-of-involvement
```

The system:
- Reads the matter data and the right template
- Pulls legislative citations from the rules files (never guesses)
- References specific document findings where relevant
- Saves the draft to `matters/{id}/letters/`
- Shows you the letter for review

#### Step 2: Approve

```
/approve-letter chen notice-of-involvement-2026-03-28.md
```

Marks the letter as ready to send. You can also request changes first — just say what needs adjusting.

#### Step 3: Send

```
/send-letter chen notice-of-involvement-2026-03-28.md
```

If Outlook integration is set up, it sends via email. If not, it tells you the file location to send manually.

### Available Letter Templates

**To Insurers:**
- Notice of involvement
- Treatment approval request
- Treatment rejection dispute
- Weekly payment dispute
- Impairment benefit claim
- Section 114 request
- File disclosure request
- Pre-conciliation submission
- Post-conciliation follow-up
- Serious injury application
- Common law election

**To Clients:**
- Engagement/retainer letter
- Process explanation
- Regular update
- Insurer decision advice
- Pre-conciliation preparation
- Costs disclosure update
- Settlement recommendation
- Authority to settle
- Final reporting

**To Doctors:**
- Authority to release medical records
- Treating practitioner report request
- Certificate of capacity request
- Clarification request

**To IMEs:**
- IME instructions
- IME objection
- IME response

**To Employers:**
- Wage information request
- Return to work obligations
- Suitable duties dispute
- Certificate of capacity compliance

**To WIC/Courts:**
- Conciliation application
- Genuine dispute response
- Medical panel objection

**Settlement:**
- Settlement deed
- Settlement financial statement

### Tone

Letters automatically match the appropriate tone:
- **Insurers:** Firm, citation-heavy
- **Clients:** Plain English, empathetic
- **Doctors:** Clinical and professional
- **IMEs:** Professional, detailed
- **Employers:** Firm, measured
- **WIC/Courts:** Formal submission style

---

## Deadlines and Compliance

### Calculating Deadlines (`/calculate-deadline`)

```
/calculate-deadline chen insurer_decision 2026-03-15
```

Shows: the deadline name, trigger event, due date, days remaining, legislative basis, and what happens if it's missed.

### Key Deadlines Tracked

**WorkCover:**
- 3-year limitation period (common law)
- 28-day insurer decision period (deemed accepted if missed)
- 60-day conciliation application deadline (no extension)
- 13/52/130-week payment rate milestones
- 6-year serious injury application window
- Certificate of Capacity renewal (7 days before expiry)

**TAC:**
- 3-year limitation period
- 12-month no-fault benefit claim window
- 6-year serious injury certificate window

**Public Liability:**
- 3-year limitation period
- 12-year absolute long-stop
- 6-year significant injury threshold

**TPD:**
- 6-year limitation (contract)
- 3-6 month waiting period (fund-specific)

**Compliance (all claim types):**
- 7-day initial costs disclosure
- Pre-settlement costs disclosure (before client agrees)

### Automatic Alerts

You don't need to manually check deadlines. The system surfaces them automatically:
- **Every morning briefing** shows overdue and upcoming deadlines
- **After every matter action** it checks and alerts you
- **Limitation periods** always get top priority

---

## Settlement Financials

```
/settlement-financials chen 150000
```

Calculates:
- Gross settlement amount
- Professional fees (25% speculative for WC/TAC/PL, or hourly for TPD)
- GST on fees
- Disbursements (medical reports, barristers, court filing, etc.)
- GST on applicable disbursements
- **Net to client**

You can provide multiple amounts for side-by-side comparison:

```
/settlement-financials chen 100000 150000 200000
```

Includes the mandatory s184 Legal Profession Uniform Law costs disclosure.

---

## File Notes

```
/add-note chen
```

Or just describe what happened:

> "Just spoke to Dr Smith about Chen's MRI results. He recommends surgery. He'll send a report next week."

The system records:
- Date and time
- Note type (phone call, conference, instruction, strategy, general)
- Participants
- Key points
- Action items

Saved to `matters/{id}/notes/` and committed for audit trail.

---

## Search and Reporting

### Search Across Matters (`/search-matters`)

```
/search-matters allianz         — Find all matters with Allianz as insurer
/search-matters workcover       — All WorkCover matters
/search-matters rejected        — All rejected claims
/search-matters dr smith        — Matters involving Dr Smith
```

### Pipeline View (`/all-matters`)

```
/all-matters
```

Shows your entire caseload grouped by stage — like a Kanban board for your practice.

---

## Undo and Audit Trail

### Undo Changes (`/undo`)

Made a mistake? Undo it:

```
/undo chen          — Revert the last change
/undo chen 3        — Revert the last 3 changes
```

This uses git under the hood, so every change is reversible.

### View History (`/matter-history`)

```
/matter-history chen
```

Shows the full audit trail: every change, when it happened, and what was modified. Useful for file reviews and compliance.

### Validate Data (`/validate-matters`)

```
/validate-matters
```

Checks data integrity across all matters and the index file. Can auto-repair common issues like index mismatches.

---

## Claim Types Supported

| Claim Type | Legislation | Rules File |
|---|---|---|
| **WorkCover** | Workplace Injury Rehabilitation and Compensation Act 2013 | `rules/workcover.md` |
| **TAC** | Transport Accident Act 1986 | `rules/tac.md` |
| **Public Liability** | Wrongs Act 1958 | `rules/public-liability.md` |
| **TPD** | Fund-specific policy terms | `rules/tpd.md` |
| **Common Law** | Various (depends on underlying claim) | `rules/common-law.md` |

Additional rules files:
- `rules/conciliation.md` — WIC conciliation procedures
- `rules/medical-panels.md` — Medical panel referral rules
- `rules/deadlines.json` — All deadline calculation rules
- `rules/conflicts.md` — Conflict of interest rules

---

## Matter Stages

Every matter progresses through these stages. The system tracks where each matter is and tells you what should happen next.

| Stage | Description |
|---|---|
| `intake` | Just created. Initial steps pending (conflict check, retainer, notice of involvement). |
| `claim_lodged` | Claim filed with insurer. Awaiting acknowledgment. |
| `awaiting_insurer_decision` | Waiting for accept/reject (28 days for WorkCover). |
| `insurer_accepted` | Benefits flowing. Monitor entitlements, treatment approvals, CoC renewals. |
| `insurer_rejected` | Rejected. 60-day conciliation deadline starts. |
| `benefits_terminated` | Previously accepted, now terminated. Review grounds, consider conciliation. |
| `conciliation_pending` | Application filed. Prepare submission, gather evidence, prepare client. |
| `conciliation_completed` | Outcome received. Determine next pathway. |
| `serious_injury_pending` | Application filed. Gather medical evidence, prepare narrative. |
| `medical_panel_referred` | Awaiting examination/opinion. Prepare client, review questions. |
| `common_law_elected` | Election made (irrevocable). Prepare litigation/negotiation. |
| `litigation` | Court proceedings active. Comply with directions, discovery, mediation. |
| `settlement_negotiation` | Active discussions. Costs disclosure required, prepare SFS. |
| `settled` | Agreement reached. Finalise deed, SFS, and final reporting. |
| `closed_successful` | Positive outcome. Matter archived. |
| `closed_unsuccessful` | Unsuccessful outcome. Matter archived. |
| `withdrawn` | Client withdrew or abandoned. Matter archived. |

The system automatically suggests stage transitions when conditions are met, but always asks for your confirmation before changing.

---

## Proactive Alerts

After every action that touches a matter, the system automatically checks:

1. **Limitation period** — Is it expired, within 6 months, or within 12 months?
2. **Stage expectations** — What should have happened by now at this stage?
3. **Overdue deadlines** — Anything past due?
4. **Upcoming deadlines** — Anything within 7 days?

It surfaces 1-3 of the most important alerts. **Limitation period alerts always come first** — they are the highest priority.

---

## Data Safety and Privacy

- **Client data never leaves this machine.** The `matters/` folder has its own local-only git repository that is never pushed to any remote server.
- **Every change is tracked.** Git commits happen after every action, giving you a full audit trail and the ability to undo.
- **Letters require explicit approval.** Nothing gets sent without you saying so.
- **Legislative references are always read from source.** The system never guesses Act sections or deadline calculations.
- **The system admits uncertainty.** If it's unsure about the law, it says so rather than fabricating advice.

---

## Weekly Review

```
/weekly-review
```

Run this on Fridays (or whenever). It covers:
- Usage stats for the week (how many matters touched, letters drafted, documents analysed)
- Issues found (unsent drafts sitting for 3+ days, inactive matters, re-extractions)
- Three quick questions about what could be better
- Saves a summary for continuous improvement

The morning briefing will remind you if it's been more than 7 days since your last weekly review.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| "Index file appears corrupted" | Run `/validate-matters` to repair |
| A matter name isn't resolving | Use more of the name, or check `/all-matters` for the correct spelling |
| PDF analysis returns empty | The PDF may be scanned/image-only. You'll need to add key findings manually |
| Letter template not found | Run `/draft-letter` without a type to see all available templates |
| Missing matter data for a letter | Run `/update-matter` to fill in the missing fields first |
| Outlook send fails | Check MCP integration is configured, or send the letter manually from the saved file |
| Something seems wrong with data | Run `/validate-matters` to check and auto-repair |
| Need to undo multiple changes | Use `/undo chen 3` (replace 3 with number of changes to revert) |

---

## Quick Reference Card

```
DAILY
  /morning-briefing          — Start your day here
  /help                      — Show all commands

MATTERS
  /new-matter                — New client intake
  /matter-status chen        — Full status summary
  /update-matter chen        — Update after a development
  /all-matters               — Pipeline view of all matters
  /search-matters allianz    — Search by any field
  /matter-history chen       — Audit trail
  /close-matter chen         — Archive a matter
  /undo chen                 — Revert last change (/undo chen 3 for multiple)
  /validate-matters          — Check and repair data integrity

DOCUMENTS
  /analyse-document chen report.pdf   — Ingest a PDF
  /build-chronology chen              — Medical timeline

LETTERS
  /draft-letter chen notice-of-involvement   — Draft a letter
  /approve-letter chen filename.md           — Approve for sending
  /send-letter chen filename.md              — Send via Outlook

DEADLINES & MONEY
  /calculate-deadline chen insurer_decision 2026-03-15   — Calculate a deadline
  /settlement-financials chen 150000                     — Settlement breakdown

NOTES
  /add-note chen             — Record a phone call, conference, or instruction

SYSTEM
  /weekly-review             — Friday check-in

TIPS
  - Talk first, command second — describe what happened naturally
  - Use names, not IDs — "chen" not "WC-2026-012"
  - Drop PDFs in documents/ then /analyse-document
  - Every change is tracked — /undo and /matter-history always available
  - Letters: draft then /approve-letter then /send-letter
  - Client data never leaves this machine
  - Run /validate-matters if anything seems off
```
