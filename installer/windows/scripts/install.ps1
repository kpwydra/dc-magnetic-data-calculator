# ============================================================
# GNU Make + Chocolatey Installer (Professional GUI, Final)
# ============================================================
# - Auto-elevates to Administrator
# - Repairs broken Chocolatey installs
# - Installs Chocolatey + GNU Make
# - Refreshes PATH for current and future sessions
# - Displays progress + summary report
# ============================================================

# --- Import Scripts ------------------------------------------------------------
. "$PSScriptRoot\utils\admin_check.ps1"
. "$PSScriptRoot\utils\path.ps1"
. "$PSScriptRoot\utils\ui_helpers.ps1"
. "$PSScriptRoot\utils\welcome.ps1"
. "$PSScriptRoot\utils\logging.ps1"

# --- Entry Point ------------------------------------------------------------
try {
    Write-Host "🔧 Starting MagBridge Installer..."
    Initialize-Environment
    Show-WelcomeForm
    Start-InstallationProcess
    Show-FinalSummary
    Write-Host "✅ Installer finished."
} catch {
    Write-Host "❌ Fatal error: $($_.Exception.Message)"
    exit 1
}

# === Step 1: Install or repair Chocolatey ===================================
$step = 1
Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Ensuring Chocolatey..."

try {
    $chocoRoot = Join-Path $env:ProgramData "chocolatey"
    $chocoBin  = Join-Path $chocoRoot "bin"

    if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
        Write-LogInfo "Chocolatey already installed."
    } else {
        if (Test-Path $chocoRoot) {
            Write-LogInfo "Cleaning broken Chocolatey folder..."
            Remove-Item -Recurse -Force $chocoRoot -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1
        }

        Write-LogInfo "Installing Chocolatey..."
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $env:ChocolateyUseWindowsCompression = 'false'
        $env:ChocolateyInstall = $chocoRoot
        $tmp = Join-Path $env:TEMP 'chocolatey\chocoInstall'
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue | Out-Null

        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

        Refresh-Path
        if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
            Write-LogOk "Chocolatey installed successfully."
        } else {
            Write-LogFail "Chocolatey not detected after install."
        }
    }
} catch {
    Write-LogFail "Chocolatey installation failed: $($_.Exception.Message)"
}

# === Step 2: Install GNU Make ===============================================
$step = 2
Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Installing GNU Make..."
try {
    if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
        choco install make -y --no-progress | Out-Null
        Write-LogOk "GNU Make installed via Chocolatey."
    } else {
        Write-LogFail "Chocolatey not found — cannot install Make."
    }
} catch {
    Write-LogFail "Make installation failed: $($_.Exception.Message)"
}

# === Step 3: Update PATH ====================================================
$step = 3
Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Updating PATH..."
try {
    $makeDir  = "C:\ProgramData\chocolatey\lib\make\tools\install\bin"
    $chocoBin = "C:\ProgramData\chocolatey\bin"

    foreach ($dir in @($chocoBin, $makeDir)) {
        if (Test-Path $dir) {
            $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
            if (-not ($machine -split ';' | Where-Object { $_ -ieq $dir })) {
                [Environment]::SetEnvironmentVariable('Path', "$machine;$dir", 'Machine')
            }
        }
    }

    Write-LogOk "PATH updated successfully."
} catch {
    Write-LogFail "Failed to update PATH: $($_.Exception.Message)"
}

# === Step 4: Verify GNU Make ===============================================
$step = 4
Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Verifying GNU Make..."
try {
    Refresh-Path
    $makeCmd = Get-Command make.exe -ErrorAction SilentlyContinue
    if ($makeCmd) {
        $ver = & $makeCmd.Source --version 2>$null
        if ($LASTEXITCODE -eq 0 -and $ver) {
            Write-LogOk ("GNU Make detected: " + ($ver -split "`r?`n")[0])
        } else {
            Write-LogFail "'make --version' failed to execute."
        }
    } else {
        Write-LogFail "make.exe not found on PATH."
    }
} catch {
    Write-LogFail "Verification step failed: $($_.Exception.Message)"
}

# --- Close UI ---------------------------------------------------------------
Close-ProgressForm -Ui $ui

# --- Final summary & goodbye -----------------------------------------------
$summary = ($report -join "`n")
$goodbyeText = @"
MagBridge Project — Installation Complete 🎉

$summary

Installation finished successfully.
You can now use 'make' in new PowerShell or CMD sessions.

A restart is recommended so PATH updates take effect.
Would you like to restart now?
"@

if ($script:UIAvailable) {
    try {
        Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
        $res = [System.Windows.MessageBox]::Show(
            $goodbyeText,
            "GNU Make Installer — Summary",
            [System.Windows.MessageBoxButton]::YesNo,
            [System.Windows.MessageBoxImage]::Information
        )
        if ($res -eq [System.Windows.MessageBoxResult]::Yes) {
            Write-Host "🔄 Restarting system..."
            shutdown.exe /r /t 5 /c "Rebooting to complete GNU Make installation."
        } else {
            Write-Host "ℹ️  Please restart your computer later."
        }
    } catch {
        $script:UIAvailable = $false
    }
}

if (-not $script:UIAvailable) {
    Write-Host ""
    Write-Host "========================================================"
    Write-Host " MagBridge Project — Installation Complete 🎉"
    Write-Host "--------------------------------------------------------"
    Write-Host ($report -join "`n")
    Write-Host ""
    Write-Host "You can now use 'make' in new shells."
    Write-Host "A system restart is recommended."
    Write-Host "========================================================"
    if (-not ($env:CI -or $env:GITHUB_ACTIONS)) {
        $resp = Read-Host "Restart now? (Y/N)"
        if ($resp -match '^[Yy]') {
            Write-Host "🔄 Restarting system..."
            shutdown.exe /r /t 5 /c "Rebooting to complete GNU Make installation."
        } else {
            Write-Host "ℹ️  Please restart your computer later."
        }
    } else {
        Write-LogInfo "CI environment detected — skipping reboot."
    }
}

exit 0
