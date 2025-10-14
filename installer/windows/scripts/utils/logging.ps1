# 🧾 --- Logging ---------------------------------------------------------------
# Writes a color-coded log entry and stores it in $report.
# Colors auto-disable in old PS/CI environments.
# Example:
#   Write-LogInfo "Starting installer..."
#   Write-LogFail "Installation failed."

$report = New-Object System.Collections.Generic.List[string]

# Detect color capability (safe for old PS and CI)
$SupportsColor = $Host.UI.SupportsVirtualTerminal -or
                 ($Host.UI.RawUI -and $Host.UI.RawUI.ForegroundColor -ne $null)

# Define ANSI color codes
$ColorMap = @{
    'RESET' = "`e[0m"
    'OK'    = "`e[92m"    # bright green
    'INFO'  = "`e[37m"    # light gray / white
    'WARN'  = "`e[38;5;166m" # cinnamon / dark orange
    'FAIL'  = "`e[31m"    # dark red
}

function Write-LogEntry {
    param(
        [Parameter(Mandatory)][ValidateSet('OK','FAIL','INFO','WARN','LOG')]
        [string]$Type,
        [Parameter(Mandatory)][string]$Message
    )

    # Compose entry text (uncolored version for file)
    $prefix = "[{0,-5}]" -f $Type
    $entry  = "$prefix $Message"
    $report.Add($entry) | Out-Null

    # Console output
    if ($SupportsColor) {
        $color = $ColorMap[$Type]
        if (-not $color) { $color = $ColorMap['RESET'] }

        $coloredPrefix = "$color$prefix$($ColorMap['RESET'])"
        Write-Host "$coloredPrefix $Message"
    }
    else {
        Write-Host $entry
    }
}

function Write-LogOk   ($m) { Write-LogEntry -Type 'OK'   -Message $m }
function Write-LogFail ($m) { Write-LogEntry -Type 'FAIL' -Message $m }
function Write-LogInfo ($m) { Write-LogEntry -Type 'INFO' -Message $m }
function Write-LogWarn ($m) { Write-LogEntry -Type 'WARN' -Message $m }

function Export-LogReport($Path = "$env:TEMP\installer_log.txt") {
    try {
        $report | Out-File -FilePath $Path -Encoding UTF8 -Force
        Write-Host "🧾 Log saved to $Path"
    } catch {
        Write-Warning "Failed to export log file: $_"
    }
}
