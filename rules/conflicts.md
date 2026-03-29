# Conflict Check Rules (Legal Profession Uniform Law ss119-121)

## /new-matter Step 3 — check index.jsonl for:
1. **Same client name** (partial, case-insensitive): returning client (OK) or duplicate (prevent)
2. **Opposing party match**: new client's employer is existing client → CONFLICT. New client names someone responsible who is a client → CONFLICT.
3. **Same employer**: not automatic conflict, but flag if same incident/dispute
4. **Same claim number**: duplicate → prevent or link

## Recording in compliance section:
conflict_check_done: true | conflict_check_date | conflict_check_result: clear / flagged_proceed / flagged_declined
