#!/bin/bash
# Auto-commit and push ALL changes after every Claude response
# Called by Claude Code Stop hook
# Tracks: matters/, feedback/sessions/, and any other changes

REPO_DIR="/home/user/karlos-legal-assistant"
cd "$REPO_DIR" || exit 0

# Stage everything
git add -A 2>/dev/null

# Commit if there are changes
git diff --cached --quiet 2>/dev/null || \
  git commit -m "auto: $(date +%Y-%m-%dT%H:%M:%S)" --quiet 2>/dev/null

# Push (retry with backoff on network failure)
BRANCH=$(git branch --show-current 2>/dev/null)
if [ -n "$BRANCH" ]; then
  for i in 1 2 3 4; do
    git push origin "$BRANCH" --quiet 2>/dev/null && break
    sleep $((2 ** i))
  done
fi
