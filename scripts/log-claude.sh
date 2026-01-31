#!/bin/bash
# Log Claude responses

INPUT=$(cat)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

[[ -z "$SESSION_ID" ]] && exit 0

LOG_DIR="$HOME/.claude/logs/$SESSION_ID"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/conversation.log"

TRANSCRIPT_PATH=$(echo "$INPUT" | grep -o '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
    RESPONSE=$(tail -20 "$TRANSCRIPT_PATH" | grep '"role"[[:space:]]*:[[:space:]]*"assistant"' | tail -1 | grep -o '"text"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/')

    if [[ -n "$RESPONSE" ]]; then
        {
            echo "[$TIMESTAMP] CLAUDE:"
            echo "  $RESPONSE"
            echo ""
        } >> "$LOG_FILE"
    fi
fi
