#!/bin/bash
# Log file changes made by Claude

INPUT=$(cat)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

SESSION_ID=$(echo "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

[[ -z "$SESSION_ID" ]] && exit 0

LOG_DIR="$HOME/.claude/logs/$SESSION_ID"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/changes.log"

TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

if [[ "$TOOL_NAME" == "Edit" ]]; then
    OLD_STRING=$(echo "$INPUT" | grep -o '"old_string"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | tr '\n' ' ')
    NEW_STRING=$(echo "$INPUT" | grep -o '"new_string"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | tr '\n' ' ')

    {
        echo "[$TIMESTAMP] EDIT $FILE_PATH"
        echo "  OLD: ${OLD_STRING}"
        echo "  NEW: ${NEW_STRING}"
        echo ""
    } >> "$LOG_FILE"

elif [[ "$TOOL_NAME" == "Write" ]]; then
    {
        echo "[$TIMESTAMP] WRITE $FILE_PATH"
        echo ""
    } >> "$LOG_FILE"
fi
