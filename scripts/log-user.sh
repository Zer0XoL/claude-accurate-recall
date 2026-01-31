#!/bin/bash
# Log user messages

INPUT=$(cat)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

[[ -z "$SESSION_ID" ]] && exit 0

LOG_DIR="$HOME/.claude/logs/$SESSION_ID"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/conversation.log"

PROMPT=$(echo "$INPUT" | grep -o '"prompt"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/')

if [[ -n "$PROMPT" ]]; then
    {
        echo "[$TIMESTAMP] USER:"
        echo "  $PROMPT"
        echo ""
    } >> "$LOG_FILE"
fi
