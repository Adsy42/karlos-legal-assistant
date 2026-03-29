#!/bin/bash
set -e
echo "=== Matters Validation ==="
ERRORS=0; WARNINGS=0
[ ! -f "matters/index.jsonl" ] && echo "ERROR: index.jsonl missing" && ERRORS=$((ERRORS+1))
for dir in matters/*/; do
    [ "$dir" = "matters/*/" ] || [ "$dir" = "matters/.git/" ] && continue
    ID=$(basename "$dir")
    [ ! -f "$dir/matter.json" ] && echo "ERROR: $ID — no matter.json" && ERRORS=$((ERRORS+1)) && continue
    python3 -c "import json; json.load(open('$dir/matter.json'))" 2>/dev/null || { echo "ERROR: $ID — invalid JSON" && ERRORS=$((ERRORS+1)) && continue; }
    [ ! -f "$dir/activity-log.jsonl" ] && echo "WARN: $ID — no activity-log" && WARNINGS=$((WARNINGS+1))
    [ -d "$dir/documents" ] && for pdf in "$dir"/documents/*.pdf; do
        [ "$pdf" = "$dir/documents/*.pdf" ] && continue
        [ ! -f "${pdf%.pdf}.extract.json" ] && echo "WARN: $ID — unanalysed $(basename $pdf)" && WARNINGS=$((WARNINGS+1))
    done
    grep -q "\"$ID\"" matters/index.jsonl 2>/dev/null || { echo "ERROR: $ID — not in index" && ERRORS=$((ERRORS+1)); }
done
echo "Errors: $ERRORS | Warnings: $WARNINGS"
[ $ERRORS -gt 0 ] && echo "Run /validate-matters in Claude Code to auto-repair." && exit 1
