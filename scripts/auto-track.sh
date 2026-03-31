#!/bin/bash
# Auto-commit and push after every Claude response
# Called by Claude Code Stop hook

REPO_DIR="/home/user/karlos-legal-assistant"
cd "$REPO_DIR" || exit 0

# 1. Auto-commit matters/ (local only — never pushed)
if [ -d matters/.git ]; then
  cd matters
  git add -A 2>/dev/null
  git diff --cached --quiet 2>/dev/null || \
    git commit -m "auto: session update $(date +%Y-%m-%dT%H:%M:%S)" --quiet 2>/dev/null
  cd "$REPO_DIR"
fi

# 2. Auto-commit feedback/ and any other tracked changes to main repo
git add feedback/ 2>/dev/null
git diff --cached --quiet 2>/dev/null || \
  git commit -m "auto: session log $(date +%Y-%m-%dT%H:%M:%S)" --quiet 2>/dev/null

# 3. Auto-push main repo (retry with backoff on network failure)
BRANCH=$(git branch --show-current 2>/dev/null)
if [ -n "$BRANCH" ]; then
  for i in 1 2 3 4; do
    git push origin "$BRANCH" --quiet 2>/dev/null && break
    sleep $((2 ** i))
  done
fi
