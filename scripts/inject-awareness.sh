#!/bin/bash
# Inject awareness of session logs into Claude's context

INPUT=$(cat)

# Extract session_id
SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

if [[ -z "$SESSION_ID" ]]; then
    exit 0
fi

LOG_DIR="$HOME/.claude/logs/$SESSION_ID"

# Output JSON with the prompt to inject
cat << EOF
{
  "result": "continue",
  "message": "CURRENT SESSION LOGS: $LOG_DIR/ — Always use this path (not the global ~/.claude/logs/). Files: conversation.log, changes.log, bash.log. Use grep/tail to search, never read full files."
}
EOF
