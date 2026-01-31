# Log Bash commands - keeps only 10 most recent (PowerShell)
$input_data = $input | Out-String
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($input_data -match '"session_id"\s*:\s*"([^"]*)"') {
    $session_id = $matches[1]
} else { exit 0 }

$log_dir = Join-Path $env:USERPROFILE ".claude\logs\$session_id"
New-Item -ItemType Directory -Force -Path $log_dir | Out-Null
$log_file = Join-Path $log_dir "bash.log"

try {
    $json = $input_data | ConvertFrom-Json
    $command = $json.tool_input.command
    $output = $json.tool_result.stdout
    if ($output) { $output = $output -replace "`n", " " }
} catch {
    $command = if ($input_data -match '"command"\s*:\s*"([^"]*)"') { $matches[1] } else { "" }
    $output = if ($input_data -match '"stdout"\s*:\s*"([^"]*)"') {
        $matches[1] -replace "`n", " "
    } else { "" }
}

if ($command) {
    $entry = "=== [$timestamp] ===`nCMD: $command`nOUT: $output`n`n"
    [System.IO.File]::AppendAllText($log_file, $entry, [System.Text.Encoding]::UTF8)

    if (Test-Path $log_file) {
        $content = Get-Content $log_file -Tail 40 -Encoding UTF8
        [System.IO.File]::WriteAllLines($log_file, $content, [System.Text.Encoding]::UTF8)
    }
}
