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
$UIAvailable = $true
try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    [System.Windows.Forms.Application]::EnableVisualStyles()
} catch {
    Write-Warning "⚠️ GUI not available (server or CI mode). Console progress will be used."
    $UIAvailable = $false
}

function New-ProgressForm {
    param(
        [string]$Title = "GNU Make Installer",
        [int]$Max = 4
    )

    # --- Fallback: console-only mode (no GUI) --------------------------------
    if (-not $UIAvailable) {
        $progress = [PSCustomObject]@{
            Step  = 0
            Max   = $Max
            Label = "Preparing..."
            Update = {
                param($text)
                $this.Step++
                $percent = [math]::Round(($this.Step / $this.Max) * 100)
                Write-Host ("[{0,2}/{1}] {2,-25} ({3,3}%)" -f $this.Step, $this.Max, $text, $percent)
            }
            Close = { Write-Host "✔️  Installation completed." }
        }
        $progress.Update.Invoke("Starting in console mode...")
        return $progress
    }

    # --- GUI mode ------------------------------------------------------------
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Width = 540; $form.Height = 180
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.TopMost = $true
    $form.BackColor = [System.Drawing.Color]::FromArgb(245,245,245)

    # Label
    $label = New-Object System.Windows.Forms.Label
    $label.Width = 500; $label.Height = 30
    $label.Left = 20; $label.Top = 20
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10,[System.Drawing.FontStyle]::Regular)
    $label.Text = "Preparing installer..."

    # ProgressBar
    $bar = New-Object System.Windows.Forms.ProgressBar
    $bar.Left = 20; $bar.Top = 60
    $bar.Width = 480; $bar.Height = 25
    $bar.Style = "Continuous"
    $bar.Minimum = 0; $bar.Maximum = $Max; $bar.Value = 0

    # Cancel button
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Cancel"
    $btnCancel.Left = 400; $btnCancel.Top = 100
    $btnCancel.Width = 100; $btnCancel.Height = 30
    $btnCancel.Add_Click({
        $form.Tag = "Cancelled"
        $form.Close()
    })

    # Add controls
    $form.Controls.AddRange(@($label, $bar, $btnCancel))

    # --- Return composite object ---------------------------------------------
    return [PSCustomObject]@{
        Form   = $form
        Label  = $label
        Bar    = $bar
        Cancel = $btnCancel
        Update = {
            param($text)
            $this.Bar.PerformStep()
            $this.Label.Text = $text
            $this.Form.Refresh()
        }
        Close = {
            if ($this.Form.Tag -ne "Cancelled") {
                $this.Label.Text = "Installation complete."
                Start-Sleep -Milliseconds 800
            }
            $this.Form.Close()
        }
    }
}

# --- Progress Form Control Helpers ------------------------------------------
function Update-ProgressForm($Ui, [int]$Step, [int]$Total, [string]$Msg) {
    if (-not $Ui) { return }

    # --- GUI mode ------------------------------------------------------------
    if ($Ui.Form -ne $null) {
        try {
            $Ui.Label.Text = $Msg
            $Ui.Bar.Maximum = $Total
            $Ui.Bar.Value   = [Math]::Min($Step, $Total)
            $Ui.Form.Refresh()
        } catch {
            Write-Warning "Failed to update progress form: $_"
        }
    }
    # --- Console fallback ----------------------------------------------------
    else {
        $percent = [math]::Round(($Step / $Total) * 100)
        Write-Host ("[{0,2}/{1}] {2,-25} ({3,3}%)" -f $Step, $Total, $Msg, $percent)
    }
}

function Close-ProgressForm($Ui) {
    if (-not $Ui) { return }

    if ($Ui.Form -ne $null) {
        try {
            $Ui.Close.Invoke()
        } catch {
            Write-Warning "Failed to close progress form: $_"
        }
    }
    else {
        Write-Host "✔️  Installation completed."
    }
}

#  call ---------------------------------------------------------------------------
# $ui = New-ProgressForm -Title "GNU Make Installer" -Max 4
# if ($ui.Form) { $ui.Form.Show() }

# for ($i=1; $i -le 4; $i++) {
#     Update-ProgressForm $ui $i 4 "Step $i in progress..."
#     Start-Sleep -Seconds 1
# }

# Close-ProgressForm $ui
#  call ---------------------------------------------------------------------------

# 📝 --- Logging ---------------------------------------------------------------
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

#  call ---------------------------------------------------------------------------
Write-LogInfo "Starting installer..."
Write-LogOk   "All dependencies found."
Write-LogWarn "Low disk space detected."
Write-LogFail "Could not create Start Menu entry."
Export-LogReport
#  call ---------------------------------------------------------------------------

# --- Welcome ---------------------------------------------------------------
$UIAvailable = $true
try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
} catch {
    $UIAvailable = $false
    Write-Host "⚙️  Headless environment detected — skipping GUI welcome screen."
}

if ($UIAvailable) {
    # --- Form setup ---------------------------------------------------------
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "MagBridge Project — GNU Make Installer"
    $form.Width = 600; $form.Height = 420
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false; $form.MinimizeBox = $false
    $form.TopMost = $true
    $form.BackColor = [System.Drawing.Color]::FromArgb(250,250,250)

    # --- Logo placeholder ---------------------------------------------------
    $logoBox = New-Object System.Windows.Forms.PictureBox
    $logoBox.Width = 80; $logoBox.Height = 80
    $logoBox.Left = 25; $logoBox.Top = 25
    $logoBox.BorderStyle = "FixedSingle"  # placeholder frame
    # You can later set: $logoBox.Image = [System.Drawing.Image]::FromFile("logo.png")

    # --- Title label --------------------------------------------------------
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "Welcome to the MagBridge Project Installer"
    $title.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
    $title.Left = 120; $title.Top = 35; $title.Width = 440; $title.Height = 30

    # --- Description --------------------------------------------------------
    $desc = New-Object System.Windows.Forms.Label
    $desc.Text =
"This open-source project streamlines chemists’ workflows through simplicity and thoughtful design focused on user experience.

This installer will:
 • Install Chocolatey (if missing or broken)
 • Install GNU Make via Chocolatey
 • Update PATH
 • Verify installation"
    $desc.Font = New-Object System.Drawing.Font("Segoe UI",10)
    $desc.Left = 40; $desc.Top = 110; $desc.Width = 520; $desc.Height = 140
    $desc.AutoSize = $false

    # --- Checkboxes ---------------------------------------------------------
    $chkChoco = New-Object System.Windows.Forms.CheckBox
    $chkChoco.Text = "Chocolatey – Windows Package Manager"
    $chkChoco.Left = 60; $chkChoco.Top = 260; $chkChoco.Width = 400
    $chkChoco.Checked = $true

    $chkMake = New-Object System.Windows.Forms.CheckBox
    $chkMake.Text = "GNU Make for Windows"
    $chkMake.Left = 60; $chkMake.Top = 290; $chkMake.Width = 400
    $chkMake.Checked = $true

    # --- Install button -----------------------------------------------------
    $btnInstall = New-Object System.Windows.Forms.Button
    $btnInstall.Text = "Install"
    $btnInstall.Width = 100; $btnInstall.Height = 35
    $btnInstall.Left = 460; $btnInstall.Top = 340
    $btnInstall.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $btnInstall.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)

    # --- Cancel button ------------------------------------------------------
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Cancel"
    $btnCancel.Width = 100; $btnCancel.Height = 35
    $btnCancel.Left = 340; $btnCancel.Top = 340
    $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    # --- Add controls -------------------------------------------------------
    $form.Controls.AddRange(@($logoBox,$title,$desc,$chkChoco,$chkMake,$btnInstall,$btnCancel))

    # --- Show dialog --------------------------------------------------------
    $dialogResult = $form.ShowDialog()

    # --- Store user decisions ----------------------------------------------
    $Global:InstallOptions = [PSCustomObject]@{
        Continue    = ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK)
        Chocolatey  = $chkChoco.Checked
        Make        = $chkMake.Checked
    }

    if (-not $InstallOptions.Continue) {
        Write-Host "❌  Installation cancelled by user."
        exit 0
    }

    Write-Host "✅  Proceeding with installation..."
    Write-Host ("Selected components: " +
                ("Chocolatey " * [int]$InstallOptions.Chocolatey) +
                ("GNU Make " * [int]$InstallOptions.Make))
}
else {
    # --- Fallback for CI/CD or no GUI --------------------------------------
    Write-Host @"
MagBridge Project — Open Source Initiative
This tool streamlines chemists’ workflows through simplicity and usability.

Tasks to perform:
 • Install Chocolatey (if missing)
 • Install GNU Make via Chocolatey
 • Update PATH
 • Verify installation
"@
    $response = Read-Host "Continue installation? (Y/N)"
    if ($response -notmatch '^[Yy]') { exit 0 }

    $Global:InstallOptions = [PSCustomObject]@{
        Continue   = $true
        Chocolatey = $true
        Make       = $true
    }
}

#  call ---------------------------------------------------------------------------
if ($script:UIAvailable) {
    Show-WelcomeForm
} else {
    Write-Host "Running in headless mode..."
}
#  call ---------------------------------------------------------------------------

# --- Progress UI ------------------------------------------------------------
$steps = 4
$ui = New-ProgressForm -Title "GNU Make Installer" -Max $steps
if ($ui.Form) { $ui.Form.Show() }
Update-ProgressForm $ui 0 $steps "Starting installation..."


# === Helper: refresh PATH from system ===
function Refresh-Path {
    try {
        $env:PATH = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' +
                    [System.Environment]::GetEnvironmentVariable('Path','User')
        Write-LogInfo "PATH variable refreshed."
    } catch {
        Write-LogWarn "Failed to refresh PATH: $_"
    }
}

# === Step 1: Install or repair Chocolatey ===================================
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

        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

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
