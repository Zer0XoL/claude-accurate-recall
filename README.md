# log-changes Plugin

A Claude Code plugin that logs conversations and file changes for context recovery after compression.

## What Gets Logged

- **User messages** → `~/.claude/logs/conversation.log`
- **Claude responses** → `~/.claude/logs/conversation.log`
- **File edits/writes** → `~/.claude/logs/changes.log`
- **Bash commands** → `~/.claude/logs/bash.log` (keeps last 10 only)

## Installation

### From GitHub

```bash
claude plugin install https://github.com/YOUR_USERNAME/claude--context-independent-log-changes
```

### From Local Clone

```bash
git clone https://github.com/YOUR_USERNAME/claude--context-independent-log-changes.git
claude plugin install ./claude--context-independent-log-changes
```

### Single Session (without installing)

```bash
claude --plugin-dir ./claude--context-independent-log-changes
```

## Log Format

### conversation.log
```
[2026-01-16 12:15:30] [abc123] USER:
  fixa geographic filtering

[2026-01-16 12:15:45] [abc123] CLAUDE:
  Jag ändrar VectorDbService.cs...
```

### changes.log
```
[2026-01-16 12:16:00] [abc123] EDIT ./src/VectorDbService.cs
  OLD: match = new { any = new[] { countyCode } }...
  NEW: match = new { value = countyCode }...
```

## Searching (Important: avoid reading full log)

Never read the entire log into context. Use targeted searches:

```bash
# Search for specific topic
grep "geographic" ~/.claude/logs/conversation.log

# Recent messages only
tail -20 ~/.claude/logs/conversation.log

# First message in session
head -5 ~/.claude/logs/conversation.log

# Find file changes
grep "VectorDbService" ~/.claude/logs/changes.log

# Changes from specific date
grep "2026-01-16" ~/.claude/logs/changes.log
```

## Why

When Claude Code conversations are compressed, Claude loses details about what was discussed and changed. These logs enable recovery of that context.

## License

MIT
