#!/bin/bash
# Inject awareness of session logs into Claude's context

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

[[ -z "$SESSION_ID" ]] && exit 0

LOG_DIR="$HOME/.claude/logs/$SESSION_ID"

cat << EOF
{
  "result": "continue",
  "message": "CURRENT SESSION LOGS: $LOG_DIR/ — Always use this path (not the global ~/.claude/logs/). Files: conversation.log, changes.log, bash.log. Use grep/tail to search, never read full files."
}
EOF
