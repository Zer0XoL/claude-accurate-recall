# Log user messages (PowerShell)
$input_data = $input | Out-String
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($input_data -match '"session_id"\s*:\s*"([^"]*)"') {
    $session_id = $matches[1]
} else { exit 0 }

$log_dir = Join-Path $env:USERPROFILE ".claude\logs\$session_id"
New-Item -ItemType Directory -Force -Path $log_dir | Out-Null
$log_file = Join-Path $log_dir "conversation.log"

try {
    $json = $input_data | ConvertFrom-Json
    $prompt = $json.prompt
    if ($prompt) {
        $entry = "[$timestamp] USER:`n  $prompt`n`n"
        [System.IO.File]::AppendAllText($log_file, $entry, [System.Text.Encoding]::UTF8)
    }
} catch {
    # Fallback to regex if JSON parse fails
    if ($input_data -match '"prompt"\s*:\s*"([^"]*)"') {
        $entry = "[$timestamp] USER:`n  $($matches[1])`n`n"
        [System.IO.File]::AppendAllText($log_file, $entry, [System.Text.Encoding]::UTF8)
    }
}
