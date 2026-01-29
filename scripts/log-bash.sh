#!/bin/bash
# Log Bash commands - keeps only 10 most recent

LOG_DIR="$HOME/.claude/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/bash.log"
TEMP_FILE="$LOG_DIR/bash.tmp"

INPUT=$(cat)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Extract session_id
SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1 | cut -c1-8)

# Extract command
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -c 200)

# Extract output (stdout)
OUTPUT=$(echo "$INPUT" | grep -o '"stdout"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -c 300 | tr '\n' ' ')

if [[ -n "$COMMAND" ]]; then
    # Append new entry
    {
        echo "=== [$TIMESTAMP] [$SESSION_ID] ==="
        echo "CMD: $COMMAND"
        echo "OUT: $OUTPUT"
        echo ""
    } >> "$LOG_FILE"

    # Keep only last 10 entries (each entry is 4 lines)
    if [[ -f "$LOG_FILE" ]]; then
        tail -40 "$LOG_FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$LOG_FILE"
    fi
fi
