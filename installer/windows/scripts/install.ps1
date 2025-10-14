# ============================================================
# GNU Make + Chocolatey Installer (Professional GUI, Final)
# ============================================================
# - Auto-elevates to Administrator
# - Repairs broken Chocolatey installs
# - Installs Chocolatey + GNU Make
# - Refreshes PATH for current and future sessions
# - Displays progress + summary report
# ============================================================

# --- Admin check ------------------------------------------------------------
$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    $useConsoleFallback = $false
    $userAccepted = $false

    # --- Try to load GUI library --------------------------------------------
    try {
        # PowerShell 2.0/3.0 on Win7 sometimes doesn't have WPF; try WinForms first
        try {
            Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
            $res = [System.Windows.Forms.MessageBox]::Show(
                "Administrator rights are required to continue.`n`nClick YES to restart this installer with elevated privileges.",
                "GNU Make Installer",
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Question
            )
            $userAccepted = ($res -eq [System.Windows.Forms.DialogResult]::Yes)
        } catch {
            # If WinForms fails, try WPF (PresentationFramework)
            Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
            $res = [System.Windows.MessageBox]::Show(
                "Administrator rights are required to continue.`n`nClick YES to restart this installer with elevated privileges.",
                "GNU Make Installer",
                [System.Windows.MessageBoxButton]::YesNo,
                [System.Windows.MessageBoxImage]::Question
            )
            $userAccepted = ($res -eq [System.Windows.MessageBoxResult]::Yes)
        }
    }
    catch {
        # No GUI subsystem available (headless mode, CI/CD, etc.)
        $useConsoleFallback = $true
    }

    # --- Fallback to console prompt -----------------------------------------
    if ($useConsoleFallback) {
        Write-Host ""
        Write-Host "========================================================"
        Write-Host "Administrator rights are required to continue."
        Write-Host "Run this script again as Administrator."
        Write-Host "========================================================"
        Write-Host ""
        $response = Read-Host "Restart automatically with admin rights? (Y/N)"
        if ($response -match '^[Yy]') { $userAccepted = $true }
    }

    # --- Relaunch elevated if confirmed -------------------------------------
    if ($userAccepted) {
        $shellExe = if ($PSVersionTable.PSEdition -eq 'Core') { 'pwsh' } else { 'powershell.exe' }
        $scriptPath = if ($PSCommandPath) { $PSCommandPath } else { $MyInvocation.MyCommand.Definition }
        $args = "-NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

        try {
            Start-Process -FilePath $shellExe -ArgumentList $args -Verb RunAs | Out-Null
        } catch {
            Write-Host "❌ Failed to elevate privileges. Please run manually as Administrator."
        }
    }

    exit 0
}

# --- UI helpers -------------------------------------------------------------
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

function New-ProgressForm {
    param([string]$Title = "GNU Make Installer", [int]$Max = 4)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Width = 520; $form.Height = 150
    $form.StartPosition = "CenterScreen"; $form.TopMost = $true
    $form.FormBorderStyle = "FixedDialog"; $form.MaximizeBox = $false; $form.MinimizeBox = $false

    $label = New-Object System.Windows.Forms.Label
    $label.AutoSize = $false; $label.Width = 480; $label.Height = 30
    $label.Left = 20; $label.Top = 10; $label.Text = "Preparing..."

    $bar = New-Object System.Windows.Forms.ProgressBar
    $bar.Left = 20; $bar.Top = 50; $bar.Width = 480; $bar.Height = 22
    $bar.Style = "Continuous"; $bar.Minimum = 0; $bar.Maximum = $Max; $bar.Value = 0

    $form.Controls.Add($label); $form.Controls.Add($bar)
    return [PSCustomObject]@{ Form=$form; Label=$label; Bar=$bar }
}

function Update-ProgressForm($Ui,[int]$Step,[int]$Total,[string]$Msg){
    $Ui.Label.Text = $Msg
    $Ui.Bar.Maximum = $Total
    $Ui.Bar.Value = [Math]::Min($Step,$Total)
    $Ui.Form.Refresh()
}
function Close-ProgressForm($Ui){ $Ui.Form.Close() }

# --- Logging ---------------------------------------------------------------
$report = New-Object System.Collections.Generic.List[string]
function Add-Ok($m){ $report.Add("[OK]   $m") | Out-Null }
function Add-Fail($m){ $report.Add("[FAIL] $m") | Out-Null }
function Add-Info($m){ $report.Add("[INFO] $m") | Out-Null }

# --- Welcome ---------------------------------------------------------------
Add-Type -AssemblyName PresentationFramework
$welcomeText = @"
This installer will:

 • Install Chocolatey (if missing or broken)
 • Install GNU Make via Chocolatey
 • Update PATH
 • Verify installation

Continue?
"@
$welcome = [System.Windows.MessageBox]::Show(
    $welcomeText,
    "GNU Make Installer",
    [System.Windows.MessageBoxButton]::YesNo,
    [System.Windows.MessageBoxImage]::Information
)
if ($welcome -ne [System.Windows.MessageBoxResult]::Yes) { exit 0 }

# --- Progress UI ------------------------------------------------------------
$steps = 4
$ui = New-ProgressForm -Title "GNU Make Installer" -Max $steps
$ui.Form.Show()
Update-ProgressForm -Ui $ui -Step 0 -Total $steps -Message "Starting installation..."

# === Helper: refresh PATH from system ===
function Refresh-Path {
    $env:PATH = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' +
                [System.Environment]::GetEnvironmentVariable('Path','User')
}

# === Step 1: Install or repair Chocolatey ===================================
$step = 1
Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Ensuring Chocolatey..."
try {
    $chocoRoot = Join-Path $env:ProgramData "chocolatey"
    $chocoBin  = Join-Path $chocoRoot "bin"

    if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
        Add-Info "Chocolatey already installed."
    } else {
        if (Test-Path $chocoRoot) {
            Add-Info "Cleaning broken Chocolatey folder..."
            Remove-Item -Recurse -Force $chocoRoot -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1
        }
        Add-Info "Installing Chocolatey..."
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $env:ChocolateyUseWindowsCompression = 'false'
        $env:ChocolateyInstall = $chocoRoot
        $tmp = Join-Path $env:TEMP 'chocolatey\chocoInstall'
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue | Out-Null

        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

        Refresh-Path
        if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
            Add-Ok "Chocolatey installed successfully."
        } else {
            Add-Fail "Chocolatey not detected after install."
        }
    }
} catch {
    Add-Fail "Chocolatey installation failed: $($_.Exception.Message)"
}

# === Step 2: Install GNU Make ===============================================
$step = 2
Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Installing GNU Make..."
try {
    if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
        choco install make -y --no-progress | Out-Null
        Add-Ok "GNU Make installed via Chocolatey."
    } else {
        Add-Fail "Chocolatey not found — cannot install Make."
    }
} catch {
    Add-Fail "Make installation failed: $($_.Exception.Message)"
}

# === Step 3: Update PATH ====================================================
$step = 3
Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Updating PATH..."
try {
    $makeDir = "C:\ProgramData\chocolatey\lib\make\tools\install\bin"
    $chocoBin = "C:\ProgramData\chocolatey\bin"
    foreach ($dir in @($chocoBin,$makeDir)) {
        if (Test-Path $dir) {
            $machine = [Environment]::GetEnvironmentVariable('Path','Machine')
            if (-not ($machine -split ';' | Where-Object { $_ -ieq $dir })) {
                [Environment]::SetEnvironmentVariable('Path',"$machine;$dir",'Machine')
            }
        }
    }
    Refresh-Path
    Add-Ok "PATH updated successfully."
} catch {
    Add-Fail "Failed to update PATH: $($_.Exception.Message)"
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
            Add-Ok ("GNU Make detected: " + ($ver -split "`r?`n")[0])
        } else {
            Add-Fail "'make --version' failed to execute."
        }
    } else {
        Add-Fail "make.exe not found on PATH."
    }
} catch {
    Add-Fail "Verification step failed: $($_.Exception.Message)"
}

# --- Close UI ---------------------------------------------------------------
Close-ProgressForm -Ui $ui

# --- Final summary ----------------------------------------------------------
Add-Type -AssemblyName PresentationFramework
$summary = ($report -join "`n")
[System.Windows.MessageBox]::Show(
    $summary + "`n`nInstallation complete. You can now use 'make' in new PowerShell or CMD sessions.",
    "GNU Make Installer - Summary",
    [System.Windows.MessageBoxButton]::OK,
    [System.Windows.MessageBoxImage]::Information
) | Out-Null

# exit 0
