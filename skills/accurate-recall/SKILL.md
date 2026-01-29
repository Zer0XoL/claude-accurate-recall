# /accurate-recall

Search session logs for past context.

## Usage

```
/accurate-recall <search term>
```

## What to search

Session logs are at `~/.claude/logs/{session_id}/` (the path is injected via prompt hook - use that exact path, NOT the global `~/.claude/logs/`):

- **conversation.log** - User messages and Claude responses
- **changes.log** - File edits/writes with old and new content
- **bash.log** - Recent bash commands and their output

## Instructions

1. Use the session path from the injected prompt (e.g., `~/.claude/logs/abc123-def456/`)
2. Search the relevant log file(s) using grep:
   ```bash
   grep -i "<search term>" ~/.claude/logs/<session_id>/conversation.log
   grep -i "<search term>" ~/.claude/logs/<session_id>/changes.log
   ```
3. Use context flags (-B, -A, -C) to get surrounding lines
4. For recent entries, use `tail` instead of grep
5. Report findings to the user

## Examples

- `/accurate-recall authentication` - Find past discussion about authentication
- `/accurate-recall VectorDb` - Find changes made to VectorDb files
- `/accurate-recall what did I say about` - Search for user's past instructions
