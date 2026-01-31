# Inject awareness of session logs (PowerShell)
$input_data = $input | Out-String

if ($input_data -match '"session_id"\s*:\s*"([^"]*)"') {
    $session_id = $matches[1]
} else { exit 0 }

$log_dir = Join-Path $env:USERPROFILE ".claude\logs\$session_id"

@"
{
  "result": "continue",
  "message": "CURRENT SESSION LOGS: $log_dir/ - Always use this path (not the global ~/.claude/logs/). Files: conversation.log, changes.log, bash.log. Use grep/tail to search, never read full files."
}
"@
