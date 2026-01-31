# Log file changes (PowerShell)
$input_data = $input | Out-String
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($input_data -match '"session_id"\s*:\s*"([^"]*)"') {
    $session_id = $matches[1]
} else { exit 0 }

$log_dir = Join-Path $env:USERPROFILE ".claude\logs\$session_id"
New-Item -ItemType Directory -Force -Path $log_dir | Out-Null
$log_file = Join-Path $log_dir "changes.log"

try {
    $json = $input_data | ConvertFrom-Json
    $tool_name = $json.tool_name
    $file_path = $json.tool_input.file_path

    if ($tool_name -eq "Edit") {
        $old_string = $json.tool_input.old_string
        $new_string = $json.tool_input.new_string
        if ($old_string) { $old_string = $old_string -replace "`n", " " }
        if ($new_string) { $new_string = $new_string -replace "`n", " " }
        $entry = "[$timestamp] EDIT $file_path`n  OLD: $old_string`n  NEW: $new_string`n`n"
        [System.IO.File]::AppendAllText($log_file, $entry, [System.Text.Encoding]::UTF8)
    }
    elseif ($tool_name -eq "Write") {
        $entry = "[$timestamp] WRITE $file_path`n`n"
        [System.IO.File]::AppendAllText($log_file, $entry, [System.Text.Encoding]::UTF8)
    }
} catch {
    # Fallback to regex
    $tool_name = if ($input_data -match '"tool_name"\s*:\s*"([^"]*)"') { $matches[1] } else { "" }
    $file_path = if ($input_data -match '"file_path"\s*:\s*"([^"]*)"') { $matches[1] } else { "" }

    if ($tool_name -eq "Edit") {
        $entry = "[$timestamp] EDIT $file_path`n`n"
        [System.IO.File]::AppendAllText($log_file, $entry, [System.Text.Encoding]::UTF8)
    }
    elseif ($tool_name -eq "Write") {
        $entry = "[$timestamp] WRITE $file_path`n`n"
        [System.IO.File]::AppendAllText($log_file, $entry, [System.Text.Encoding]::UTF8)
    }
}
