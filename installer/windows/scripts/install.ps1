# --- Determine script root (works in normal PS and compiled EXE) ---
if ($MyInvocation.MyCommand.Path) {
    $ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    $ScriptRoot = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
}

# --- Verify required file exists ---
$checkPath = Join-Path $ScriptRoot 'admin_check.ps1'
if (-not (Test-Path $checkPath)) {
    Write-Host "Invalid ScriptRoot — missing admin_check.ps1 in $ScriptRoot"
    throw "Invalid ScriptRoot — missing admin_check.ps1 in $ScriptRoot"
}

# --- Import Scripts -----------------------------------------------------
. (Join-Path $ScriptRoot 'admin_check.ps1')
# . (Join-Path $ScriptRoot 'logging.ps1')
# . (Join-Path $ScriptRoot 'ui_helpers.ps1')
# . (Join-Path $ScriptRoot 'path.ps1')
# . (Join-Path $ScriptRoot 'forms.ps1')
# . (Join-Path $ScriptRoot 'choco.ps1')
# . (Join-Path $ScriptRoot 'gnu_make.ps1')

# 🧩 --- Entry Point: Start-MagBridgeInstaller ---------------------------
# Main controller for the MagBridge GNU Make installer.
# Initializes environment, runs installation steps, and shows summary.
# Example:
#   Start-MagBridgeInstaller

function Start-MagBridgeInstaller {
    try {
        Write-Host "🔧 Starting MagBridge Installer..."
        Initialize-Environment
        Test-UIAvailable
        Show-WelcomeForm

        # shared state
        $script:InstallerState = [PSCustomObject]@{
            StepsTotal  = 4
            StepCurrent = 0
            Ui          = $null
        }

        # progress UI
        $script:InstallerState.Ui = New-ProgressForm -Title "GNU Make Installer" -Max $script:InstallerState.StepsTotal
        if ($script:InstallerState.Ui.Form) { $script:InstallerState.Ui.Form.Show() }

        # Step 1: Chocolatey
        $script:InstallerState.StepCurrent++
        Update-ProgressForm -Ui $script:InstallerState.Ui -Step $script:InstallerState.StepCurrent -Total $script:InstallerState.StepsTotal -Message "Ensuring Chocolatey..."
        Ensure-Chocolatey

        # Step 2: GNU Make
        $script:InstallerState.StepCurrent++
        Install-GnuMake -Ui $script:InstallerState.Ui -Step $script:InstallerState.StepCurrent -Total $script:InstallerState.StepsTotal

        # Step 3: PATH (append dirs if missing, then refresh current session)
        $script:InstallerState.StepCurrent++
        Update-ProgressForm -Ui $script:InstallerState.Ui -Step $script:InstallerState.StepCurrent -Total $script:InstallerState.StepsTotal -Message "Updating PATH..."
        try {
            $makeDir  = "C:\ProgramData\chocolatey\lib\make\tools\install\bin"
            $chocoBin = "C:\ProgramData\chocolatey\bin"
            foreach ($dir in @($chocoBin,$makeDir)) {
                if (Test-Path $dir) {
                    $machine = [Environment]::GetEnvironmentVariable('Path','Machine')
                    if (-not ($machine -split ';' | Where-Object { $_ -ieq $dir })) {
                        [Environment]::SetEnvironmentVariable('Path', "$machine;$dir", 'Machine')
                    }
                }
            }
            Update-EnvironmentPath
            Write-LogOk "PATH updated successfully."
        } catch { Write-LogFail "Failed to update PATH: $($_.Exception.Message)" }

        # Step 4: Verify
        $script:InstallerState.StepCurrent++
        Verify-GnuMake -Ui $script:InstallerState.Ui -Step $script:InstallerState.StepCurrent -Total $script:InstallerState.StepsTotal

        Show-FinalSummary
        Close-ProgressForm -Ui $script:InstallerState.Ui
        Write-Host "✅ Installer finished."
    } catch {
        Write-Host "❌ Fatal error: $($_.Exception.Message)"
        exit 1
    }
}

# Start-MagBridgeInstaller
