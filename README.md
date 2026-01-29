# log-changes Plugin

A Claude Code plugin that logs conversations and file changes for context recovery after compression.

## What Gets Logged

Each session gets its own folder at `~/.claude/logs/<session_id>/`:

- **User messages** → `conversation.log`
- **Claude responses** → `conversation.log`
- **File edits/writes** → `changes.log`
- **Bash commands** → `bash.log` (keeps last 10 only)

## Installation

### From GitHub

```bash
claude plugin install https://github.com/Zer0XoL/claude--context-independent-log-changes
```

### From Local Clone

```bash
git clone https://github.com/Zer0XoL/claude--context-independent-log-changes.git
claude plugin install ./claude--context-independent-log-changes
```

### Single Session (without installing)

```bash
claude --plugin-dir ./claude--context-independent-log-changes
```

## Log Format

### conversation.log
```
[2026-01-16 12:15:30] USER:
  fixa geographic filtering

[2026-01-16 12:15:45] CLAUDE:
  Jag ändrar VectorDbService.cs...
```

### changes.log
```
[2026-01-16 12:16:00] EDIT ./src/VectorDbService.cs
  OLD: match = new { any = new[] { countyCode } }...
  NEW: match = new { value = countyCode }...
```

## Usage

### Automatic

Claude is automatically aware of the logs and can search them when needed. Just ask:
- "What did I say earlier about authentication?"
- "How did that file look before you changed it?"
- "What command did you run?"

### Explicit

Use the `/accurate-recall` skill to search logs:

```
/accurate-recall <search term>
```

Examples:
- `/accurate-recall authentication`
- `/accurate-recall VectorDb`

## Manual Searching

```bash
# List all sessions
ls ~/.claude/logs/

# Search current session (replace SESSION_ID)
grep "geographic" ~/.claude/logs/SESSION_ID/conversation.log

# Recent messages in a session
tail -20 ~/.claude/logs/SESSION_ID/conversation.log

# Search across all sessions
grep -r "VectorDbService" ~/.claude/logs/*/changes.log
```

## Why

When Claude Code conversations are compressed, Claude loses details about what was discussed and changed. These logs enable recovery of that context.

## License

MIT
