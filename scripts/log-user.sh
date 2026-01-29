#!/bin/bash
# Log user messages

INPUT=$(cat)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Extract session_id
SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

if [[ -z "$SESSION_ID" ]]; then
    exit 0
fi

LOG_DIR="$HOME/.claude/logs/$SESSION_ID"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/conversation.log"

# Extract prompt (user message)
PROMPT=$(echo "$INPUT" | grep -o '"prompt"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -c 500)

if [[ -n "$PROMPT" ]]; then
    {
        echo "[$TIMESTAMP] USER:"
        echo "  $PROMPT"
        echo ""
    } >> "$LOG_FILE"
fi
