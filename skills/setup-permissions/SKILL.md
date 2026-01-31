# /accurate-recall:setup-permissions

Add required permissions for accurate-recall to access session logs.

## Instructions

1. Read the user's settings file at `~/.claude/settings.json`
2. Add `Read(~/.claude/logs/**)` to the `permissions.allow` array
3. If `permissions` or `permissions.allow` doesn't exist, create it
4. Preserve all existing settings - only merge the new permission
5. Write the updated settings back to `~/.claude/settings.json`
6. Confirm to the user that permissions have been configured

## Example

If the user's settings.json is:
```json
{
  "model": "opus"
}
```

It should become:
```json
{
  "model": "opus",
  "permissions": {
    "allow": [
      "Read(~/.claude/logs/**)"
    ]
  }
}
```

If permissions.allow already contains `Read(~/.claude/logs/**)`, inform the user that permissions are already configured.
