# Log Bash commands - keeps only 10 most recent (PowerShell)
$input_data = $input | Out-String
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($input_data -match '"session_id"\s*:\s*"([^"]*)"') {
    $session_id = $matches[1]
} else { exit 0 }

$log_dir = Join-Path $env:USERPROFILE ".claude\logs\$session_id"
New-Item -ItemType Directory -Force -Path $log_dir | Out-Null
$log_file = Join-Path $log_dir "bash.log"

$command = if ($input_data -match '"command"\s*:\s*"([^"]*)"') {
    $matches[1].Substring(0, [Math]::Min(200, $matches[1].Length))
} else { "" }
$output = if ($input_data -match '"stdout"\s*:\s*"([^"]*)"') {
    $matches[1].Substring(0, [Math]::Min(300, $matches[1].Length)) -replace "`n", " "
} else { "" }

if ($command) {
    "=== [$timestamp] ===`nCMD: $command`nOUT: $output`n" | Add-Content -Path $log_file -Encoding UTF8

    if (Test-Path $log_file) {
        $content = Get-Content $log_file -Tail 40
        $content | Set-Content $log_file -Encoding UTF8
    }
}
