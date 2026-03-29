# Matter Resolution
1. Parse reference: exact ID → 2a | name/keyword → 2b | empty → 2c
2a. **Exact ID:** find in index.jsonl. Not found → "No matter with ID '{ref}'. Try /all-matters." STOP.
2b. **Keyword:** search index.jsonl (client, employer, claim_number — case-insensitive partial). 0 matches → STOP. 1 match → Step 3. 2+ → present options, ask.
2c. **Conversation context:** find most recently discussed matter in session. Found → confirm "Using {id} ({client})?" Not found → ask for name/ID. STOP.
3. **Confirm:** "Working on {id} ({client})." Verify matters/{id}/matter.json exists. If missing → "Run /validate-matters." STOP. If status "closed" → note it, ask to reopen or just view.
Note: conversation context only works within session. After restart, Mandy must name the matter.
