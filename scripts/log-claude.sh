#!/bin/bash
# Log Claude responses

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

# Extract transcript_path to read Claude's response
TRANSCRIPT_PATH=$(echo "$INPUT" | grep -o '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
    # Get last assistant message from transcript (JSONL format)
    RESPONSE=$(tail -20 "$TRANSCRIPT_PATH" | grep '"role"[[:space:]]*:[[:space:]]*"assistant"' | tail -1 | grep -o '"text"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -c 500)

    if [[ -n "$RESPONSE" ]]; then
        {
            echo "[$TIMESTAMP] CLAUDE:"
            echo "  $RESPONSE..."
            echo ""
        } >> "$LOG_FILE"
    fi
fi
