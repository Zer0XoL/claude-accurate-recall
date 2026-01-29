#!/bin/bash
# Log user messages

LOG_DIR="$HOME/.claude/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/conversation.log"

INPUT=$(cat)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Extract session_id
SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1 | cut -c1-8)

# Extract prompt (user message)
PROMPT=$(echo "$INPUT" | grep -o '"prompt"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -c 500)

if [[ -n "$PROMPT" ]]; then
    {
        echo "[$TIMESTAMP] [$SESSION_ID] USER:"
        echo "  $PROMPT"
        echo ""
    } >> "$LOG_FILE"
fi
