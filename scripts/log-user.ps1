# Log user messages (PowerShell)
$input_data = $input | Out-String
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($input_data -match '"session_id"\s*:\s*"([^"]*)"') {
    $session_id = $matches[1]
} else { exit 0 }

$log_dir = Join-Path $env:USERPROFILE ".claude\logs\$session_id"
New-Item -ItemType Directory -Force -Path $log_dir | Out-Null
$log_file = Join-Path $log_dir "conversation.log"

if ($input_data -match '"prompt"\s*:\s*"([^"]*)"') {
    $prompt = $matches[1].Substring(0, [Math]::Min(500, $matches[1].Length))
    "[$timestamp] USER:`n  $prompt`n" | Add-Content -Path $log_file -Encoding UTF8
}
