#!/bin/bash
# Log Bash commands - keeps only 10 most recent per session

INPUT=$(cat)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

[[ -z "$SESSION_ID" ]] && exit 0

LOG_DIR="$HOME/.claude/logs/$SESSION_ID"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/bash.log"
TEMP_FILE="$LOG_DIR/bash.tmp"

COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -c 200)
OUTPUT=$(echo "$INPUT" | grep -o '"stdout"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -c 300 | tr '\n' ' ')

if [[ -n "$COMMAND" ]]; then
    {
        echo "=== [$TIMESTAMP] ==="
        echo "CMD: $COMMAND"
        echo "OUT: $OUTPUT"
        echo ""
    } >> "$LOG_FILE"

    if [[ -f "$LOG_FILE" ]]; then
        tail -40 "$LOG_FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$LOG_FILE"
    fi
fi
