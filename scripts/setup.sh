#!/bin/bash
set -e
echo "=== Karlos Lawyers AI Legal Assistant — Setup ==="
command -v claude &>/dev/null || { echo "ERROR: Claude Code not installed."; exit 1; }
command -v pdftotext &>/dev/null || echo "WARNING: pdftotext not found. Install poppler-utils."
mkdir -p matters feedback/weekly-reviews feedback/developer-summaries logs
touch matters/.gitkeep feedback/.gitkeep logs/.gitkeep matters/index.jsonl feedback/log.jsonl
for dir in "matters/" "feedback/" "logs/"; do
    grep -q "^${dir}" .gitignore 2>/dev/null || echo -e "\n${dir}\n!${dir}.gitkeep" >> .gitignore
done
if [ ! -d "matters/.git" ]; then
    cd matters/ && git init && git config user.name "Karlos AI Assistant" && git config user.email "ai@karloslawyers.com.au" && git add -A && git commit -m "init: matters repo" && cd ..
    echo "✓ Matters git repo initialised"
fi
echo "Checking files..."
MISSING=0
for f in rules/workcover.md rules/tac.md rules/public-liability.md rules/deadlines.json rules/stage-expectations.json rules/conflicts.md reference/matter-schema.json reference/extract-schema.json reference/fee-schedule.json reference/style-guide.md reference/medical-questions.md reference/quick-reference.md templates/letterhead.json templates/insurer/notice-of-involvement.md templates/client/engagement-retainer.md .claude/skills/_shared/resolve-matter.md; do
    [ ! -f "$f" ] && echo "  ✗ MISSING: $f" && MISSING=$((MISSING+1)) || echo "  ✓ $f"
done
[ $MISSING -gt 0 ] && echo "WARNING: $MISSING files missing." || echo "All files present."
echo "=== Setup complete. Run /morning-briefing to start. ==="
