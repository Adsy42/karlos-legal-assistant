# Karlos Lawyers — AI Legal Assistant

AI-powered legal assistant for Victorian personal injury law practice, built on Claude Code.

## Overview

This system assists with WorkCover, TAC, Public Liability, TPD, and Common Law PI claims. It manages matter intake, document analysis, letter drafting, deadline tracking, and compliance monitoring.

## Setup

```bash
./scripts/setup.sh
```

### Prerequisites

- Node.js 18+
- Claude Code (`npm install -g @anthropic-ai/claude-code`)
- pdftotext (poppler-utils)
- Claude Max subscription

### Launch

```bash
cd ~/Documents/karlos-legal-assistant
claude
```

Type `/morning-briefing` to start, or `/help` for available commands.

## Architecture

- `.claude/skills/` — 21 workflow skills
- `rules/` — Victorian legislation references and deadline rules
- `templates/` — Letter templates by recipient type
- `reference/` — Schemas, fee schedules, style guides
- `matters/` — Client data (local only, never pushed to GitHub)
- `feedback/` — System improvement logs

## Key Principles

- Client data never leaves this machine
- All letters require explicit approval before sending
- Legislative references are always read from rules files, never guessed
- Every change is tracked via git for audit and undo capability
