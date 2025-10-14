# 🧾 --- Logging ---------------------------------------------------------------
# Writes a log entry and stores it in $report.
# Example:
#   Write-LogInfo "Starting installer..."
#   Write-LogFail "Installation failed."

# --- Initialize log storage --------------------------------------------------
$report = New-Object System.Collections.Generic.List[string]

# --- Core logging function ---------------------------------------------------
function Write-LogEntry {
    param(
        [Parameter(Mandatory)][ValidateSet('OK','FAIL','INFO','WARN','LOG')]
        [string]$Type,
        [Parameter(Mandatory)][string]$Message
    )

    # Compose entry text
    $prefix = "[{0,-5}]" -f $Type
    $entry  = "$prefix $Message"
    $report.Add($entry) | Out-Null

    # Console output (plain, no colors)
    Write-Host $entry
}

# --- Convenience wrappers ----------------------------------------------------
function Write-LogOk   ($m) { Write-LogEntry -Type 'OK'   -Message $m }
function Write-LogFail ($m) { Write-LogEntry -Type 'FAIL' -Message $m }
function Write-LogInfo ($m) { Write-LogEntry -Type 'INFO' -Message $m }
function Write-LogWarn ($m) { Write-LogEntry -Type 'WARN' -Message $m }

# --- Export log to file ------------------------------------------------------
function Export-LogReport($Path = "$env:TEMP\installer_log.txt") {
    try {
        $report | Out-File -FilePath $Path -Encoding UTF8 -Force
        Write-Host "🧾 Log saved to $Path"
    } catch {
        Write-Warning "Failed to export log file: $_"
    }
}
