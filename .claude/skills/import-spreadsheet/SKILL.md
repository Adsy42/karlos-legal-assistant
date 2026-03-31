---
name: import-spreadsheet
description: "One-time migration tool to import matters from Mandy's Excel tracker into the system. Use when Mandy says 'import spreadsheet', 'import matters', 'load from Excel', 'migrate from Smokeball', or provides an Excel file with matter data. Reads the tracker format and creates matter.json files for all matters."
---

# Import Spreadsheet — Bulk Matter Migration

## Important
- Manual-only. This is a one-time migration tool.
- ALWAYS back up existing matters/ before running.
- ALWAYS present a summary and get confirmation before writing any files.
- Sparse matters (no stage, no notes) get stage "initial_review" — NOT "intake".
- Preserve Smokeball matter numbers as matter_id.

## Instructions

### Step 0: Identify File
Ask Mandy to provide the Excel file path, or check recent conversation for a dropped file.
Expected format: columns for Matter No., Matter Type, Client Name, Email, Other Party/Defendant, Claim/Insurance No., Date of Injury, Limitation Date, Conciliation/Hearing Date, Current Stage of Claim, Next Action Date, Next Steps, Priority, File Status, Notes/Comments.

### Step 1: Read and Parse
```python
import pandas as pd
df = pd.read_excel(filepath, sheet_name='All Matters', header=0)
# First data row is the actual header
real_headers = df.iloc[0].tolist()
df = df.iloc[1:].reset_index(drop=True)
df.columns = real_headers
```

### Step 2: Map Each Row

For each matter row, map fields:

**Direct mappings:**
- Matter No. → matter_id (preserve as-is, e.g., "24:0707")
- Client Name → client.full_name (format: "Last, First" → store as-is)
- Email → client.email
- Claim / Insurance No. → insurer.claim_number OR court_proceedings.proceeding_number (if starts with "S ECI")
- File Status → status (Active → "active", On Hold → "on_hold", Settled → "closed", Closed → "closed", Archived → "archived")
- Priority → store in notes or a custom field (not in schema as formal field — surface in briefing)
- Next Steps → notes (prepend to notes)
- Next Action Date → create a deadline entry with type "custom"

**Matter Type mapping:**
- "Workers Compensation" → "workcover"
- "Motor Vehicle Accident" → "tac"
- "Public Liability" → "public_liability"
- "Comcare" → "comcare"
- "Medical Negligence" → "medical_negligence"

**Stage mapping:**
- "Claim Lodged" → "claim_lodged"
- "Conciliation / Mediation" → "conciliation_pending"
- "Common Law - Pre-Litigation" → "common_law_pre_litigation"
- "Litigation" → "litigation"
- Empty/missing → "initial_review"

**Date parsing (try in order):**
1. ISO format (YYYY-MM-DD) → use directly
2. DD/MM/YYYY → parse and convert to ISO
3. Descriptive ("April/May 2024", "Approx. Jan-Mar 2025") → set date_of_injury_approximate: true, store original in date_of_injury_description, use best-guess midpoint for date_of_injury
4. Unparseable → null, flag for manual entry

**Other Party / Defendant mapping by claim type:**
- WorkCover → employers[0] with role "direct_employer"
- TAC → if "Transport Accident Commission" → insurer.name; otherwise store as party
- Public Liability → employers[0] with role "occupier" or parties entry
- Comcare → employers[0] with role "direct_employer"
- Medical Negligence → parties entry with role "respondent"

**Multi-defendant parsing:**
- If contains "(1D)" / "(2D)" / "(3D)" → split into multiple employer entries
- If contains "/" separating entities → split into multiple entries

### Step 3: Parse Notes Column (for matters that have notes)

Use structured extraction to pull data from free-text Notes:

```
Patterns to extract:
- DOB: r'DOB[:\s]+(\d{2}/\d{2}/\d{4})'
- Injuries: r'[Ii]njuries?:\s*([^.]+?)\.'
- Claim dates: r'[Cc]laim (?:lodged|filed)[:\s]+(\d{2}/\d{2}/\d{4})'
- Accepted/rejected: r'(?:accepted|rejected)\s+(\d{2}/\d{2}/\d{4})'
- Court refs: r'(S\s*ECI\s*\d+\s*\d+)'
- Court type: r'(Magistrate[s]?\s*Court|Supreme Court|County Court|Federal Court)'
- Defendant solicitors: r'(?:Def(?:endant)?\s*solicitors?|solicitors?):\s*([^.]+?)(?:\.|$)'
- Insurer: r'[Ii]nsurer:\s*([^|.]+?)(?:\||\.)'
- WPI: r'(\d+%?\s*WPI)'
- Settlement offers: r'\$[\d,]+k?\s*(?:less|plus|settlement|offer)'
- Keep amount: r'[Kk]eep[:\s~]+\$([\d,]+)k?'
- Interpreter: r'[Ii]nterpreter[:\s]+(?:required\s*)?(?:\()?([^).\n]+)'
- Serious injury: r'[Ss]erious [Ii]njury\s+(certificate|granted|application|refused)'
- Pre-existing: r'[Pp]re-existing:\s*([^.]+?)\.'
- Weekly payments: r'weekly payments'
- Occupation/role: r'[Rr]ole:\s*([^.]+?)[\.\,]'
```

Map extracted data to appropriate schema fields. Preserve full original notes in import_notes field.

### Step 4: Conflict Check
Before creating any files, scan ALL matters for:
- Duplicate client names
- Same employer appearing as client in another matter
- Same claim number
Report any conflicts. Proceed unless genuine conflict (duplicate client is fine — just note returning client).

### Step 5: Present Summary
```
IMPORT SUMMARY
Total matters: {n}
By type: WC: {n} | TAC: {n} | PL: {n} | Comcare: {n} | MedNeg: {n}
Rich data (stage + notes): {n}
Sparse (name/type/email only): {n}
Approximate dates: {n}
Missing defendants: {n}
Multi-defendant: {n}
Conflicts found: {n}

Proceed with import?
```

### Step 6: Create Files
For each matter:
```bash
mkdir -p matters/{id}/documents matters/{id}/letters matters/{id}/chronology matters/{id}/notes
```
Create matter.json from parsed data.
Create empty activity-log.jsonl.
If notes contain strategy info: create notes/strategy.md.

### Step 7: Build Index
Create/overwrite matters/index.jsonl with one JSON line per matter:
```json
{"matter_id":"24:0707","claim_type":"workcover","client_name":"Al Thaaleby, Ibraheem","stage":"litigation","status":"active","limitation_expiry":"2030-05-01","next_deadline":"2026-03-24","next_deadline_type":"court_mention","open_flags":0,"unanalysed_docs":0}
```

### Step 8: Git Commit
```bash
cd matters/ && git init (if needed)
git config user.name "Karlos AI Assistant"
git config user.email "ai@karloslawyers.com.au"
git add -A
git commit -m "import-spreadsheet: system — Imported {n} matters from Excel tracker. {rich} with detailed data, {sparse} as stubs."
```

### Step 9: Post-Import Report
```
IMPORT COMPLETE
{n} matters created
{rich} matters with full data — ready for /morning-briefing
{sparse} matters as stubs (stage: initial_review) — update with /update-matter or /triage as needed
Next: Run /morning-briefing to see your active matters, or /all-matters for the full pipeline.
```

## Error Handling
- **File not found:** "Can't find that file. Provide the full path or drop the file here."
- **Unexpected format:** "This doesn't look like the expected tracker format. Expected columns: Matter No., Matter Type, Client Name... Found: {columns}"
- **Duplicate matter_id:** "Matter {id} already exists. Skip, overwrite, or merge?"
- **matters/ directory missing:** Run setup.sh first.
