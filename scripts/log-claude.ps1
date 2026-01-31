# Log Claude responses (PowerShell)
$input_data = $input | Out-String
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($input_data -match '"session_id"\s*:\s*"([^"]*)"') {
    $session_id = $matches[1]
} else { exit 0 }

$log_dir = Join-Path $env:USERPROFILE ".claude\logs\$session_id"
New-Item -ItemType Directory -Force -Path $log_dir | Out-Null
$log_file = Join-Path $log_dir "conversation.log"

if ($input_data -match '"transcript_path"\s*:\s*"([^"]*)"') {
    $transcript_path = $matches[1]
    if (Test-Path $transcript_path) {
        # Read last lines and find assistant messages with text content
        $lines = Get-Content $transcript_path -Tail 30
        for ($i = $lines.Count - 1; $i -ge 0; $i--) {
            $line = $lines[$i]
            if ($line -match '"role"\s*:\s*"assistant"') {
                try {
                    $json = $line | ConvertFrom-Json
                    if ($json.message -and $json.message.content) {
                        $textBlocks = $json.message.content | Where-Object { $_.type -eq "text" }
                        if ($textBlocks) {
                            $fullText = ($textBlocks | ForEach-Object { $_.text }) -join "`n"
                            if ($fullText) {
                                $entry = "[$timestamp] CLAUDE:`n  $fullText`n`n"
                                [System.IO.File]::AppendAllText($log_file, $entry, [System.Text.Encoding]::UTF8)
                                break
                            }
                        }
                    }
                } catch {
                    # JSON parse failed, skip this line
                }
            }
        }
    }
}
