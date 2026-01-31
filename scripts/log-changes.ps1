# Log file changes (PowerShell)
$input_data = $input | Out-String
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($input_data -match '"session_id"\s*:\s*"([^"]*)"') {
    $session_id = $matches[1]
} else { exit 0 }

$log_dir = Join-Path $env:USERPROFILE ".claude\logs\$session_id"
New-Item -ItemType Directory -Force -Path $log_dir | Out-Null
$log_file = Join-Path $log_dir "changes.log"

$tool_name = if ($input_data -match '"tool_name"\s*:\s*"([^"]*)"') { $matches[1] } else { "" }
$file_path = if ($input_data -match '"file_path"\s*:\s*"([^"]*)"') { $matches[1] } else { "" }

if ($tool_name -eq "Edit") {
    $old_string = if ($input_data -match '"old_string"\s*:\s*"([^"]*)"') {
        $matches[1].Substring(0, [Math]::Min(100, $matches[1].Length)) -replace "`n", " "
    } else { "" }
    $new_string = if ($input_data -match '"new_string"\s*:\s*"([^"]*)"') {
        $matches[1].Substring(0, [Math]::Min(100, $matches[1].Length)) -replace "`n", " "
    } else { "" }
    "[$timestamp] EDIT $file_path`n  OLD: $old_string...`n  NEW: $new_string...`n" | Add-Content -Path $log_file -Encoding UTF8
}
elseif ($tool_name -eq "Write") {
    "[$timestamp] WRITE $file_path`n" | Add-Content -Path $log_file -Encoding UTF8
}
