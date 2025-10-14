# ============================================================
# GNU Make + Chocolatey Uninstaller (Professional GUI)
# ============================================================
# - Shows welcome summary of detected components
# - Confirms before uninstall
# - Single progress window during actions
# - Final summary with OK/FAIL per step
# - PowerShell 5.1 compatible (ASCII only)
# ============================================================

# --- Admin check ------------------------------------------------------------
$principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        "Please run this uninstaller as Administrator.",
        "GNU Make Uninstaller",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Error
    ) | Out-Null
    exit 1
}

# --- UI helpers -------------------------------------------------------------
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

function New-ProgressForm {
    param([string]$Title = "GNU Make Uninstaller", [int]$Max = 100)

    $form                 = New-Object System.Windows.Forms.Form
    $form.Text            = $Title
    $form.Width           = 520
    $form.Height          = 150
    $form.StartPosition   = "CenterScreen"
    $form.TopMost         = $true
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox     = $false
    $form.MinimizeBox     = $false

    $label        = New-Object System.Windows.Forms.Label
    $label.AutoSize= $false; $label.Width = 480; $label.Height = 30
    $label.Left   = 20; $label.Top = 10; $label.Text = "Preparing..."

    $bar          = New-Object System.Windows.Forms.ProgressBar
    $bar.Left     = 20; $bar.Top = 50; $bar.Width = 480; $bar.Height = 22
    $bar.Style    = "Continuous"; $bar.Minimum = 0; $bar.Maximum = $Max; $bar.Value = 0

    $form.Controls.Add($label)
    $form.Controls.Add($bar)

    return [PSCustomObject]@{ Form=$form; Label=$label; Bar=$bar }
}

function Update-ProgressForm {
    param($Ui, [int]$Step, [int]$Total, [string]$Message)
    $Ui.Label.Text   = $Message
    $Ui.Bar.Maximum  = $Total
    $Ui.Bar.Value    = [Math]::Min([Math]::Max($Step,0), $Total)
    $Ui.Form.Refresh()
}

function Close-ProgressForm { param($Ui) $Ui.Form.Close() }

# --- Detection --------------------------------------------------------------
function Test-ChocoCli { Get-Command choco.exe -ErrorAction SilentlyContinue }
function Get-MakePath {
    try { (Get-Command make.exe -ErrorAction SilentlyContinue).Source } catch { $null }
}

$chocoRoot        = Join-Path $env:ProgramData "chocolatey"
$chocoLibMakeDir  = Join-Path $chocoRoot "lib\make"
$chocoFolderExists= Test-Path $chocoRoot
$hasChocoCli      = [bool](Test-ChocoCli)
$hasChocoMakePkg  = Test-Path $chocoLibMakeDir
$makePath         = Get-MakePath

# PATH patterns we will clean
$removePatterns = @(
    'GnuWin32\\bin',
    'ezwinports\\bin',
    'chocolatey\\lib\\make',
    'chocolatey\\bin',
    'msys64\\usr\\bin',
    'msys64\\mingw64\\bin'
)

function Count-PathMatches {
    param([string]$Scope)
    $cur = [Environment]::GetEnvironmentVariable('Path', $Scope)
    if (-not $cur) { return 0 }
    $parts = $cur -split ';'
    $count = 0
    foreach ($p in $parts) {
        foreach ($pat in $removePatterns) {
            if ($p -match [Regex]::Escape($pat)) { $count++; break }
        }
    }
    return $count
}

$machinePathHits = Count-PathMatches -Scope 'Machine'
$userPathHits    = Count-PathMatches -Scope 'User'

# Compose welcome summary
$lines = @()
$lines += "This uninstaller will attempt to remove the following:"
if ($hasChocoMakePkg) { $lines += " - GNU Make (Chocolatey package)" }
if ($hasChocoCli)     { $lines += " - Chocolatey CLI (choco.exe)" }
if (-not $hasChocoCli -and $chocoFolderExists) { $lines += " - Chocolatey folder present (no CLI) at: $chocoRoot" }
if ($makePath)        { $lines += " - make.exe at: $makePath" }
if (($machinePathHits + $userPathHits) -gt 0) {
    $lines += " - PATH entries to clean: Machine=$machinePathHits, User=$userPathHits"
}
$lines += "Optional:"
if ($chocoFolderExists) { $lines += " - Remove Chocolatey folder and variables (recommended if broken)" }
if ($lines.Count -eq 2) { $lines += " - Nothing obvious detected (will still clean PATH if needed)" }

$welcomeText = ($lines -join "`n")

# --- Welcome and confirmation ----------------------------------------------
Add-Type -AssemblyName PresentationFramework
$welcome = [System.Windows.MessageBox]::Show(
    $welcomeText + "`n`nContinue?",
    "GNU Make Uninstaller",
    [System.Windows.MessageBoxButton]::YesNo,
    [System.Windows.MessageBoxImage]::Information
)
if ($welcome -ne [System.Windows.MessageBoxResult]::Yes) { exit 0 }

# --- Progress UI ------------------------------------------------------------
$steps = 5  # choco make, path machine, path user, optional choco folder, final verify
$ui = New-ProgressForm -Title "GNU Make Uninstaller" -Max $steps
$ui.Form.Show()
Update-ProgressForm -Ui $ui -Step 0 -Total $steps -Message "Starting uninstallation..."

# --- Result tracking --------------------------------------------------------
$report = New-Object System.Collections.Generic.List[string]
function Add-Ok($m){ $report.Add("[OK]  "   + $m) | Out-Null }
function Add-Fail($m){ $report.Add("[FAIL] " + $m) | Out-Null }
function Add-Info($m){ $report.Add("[INFO] " + $m) | Out-Null }

$step = 0

# 1) Uninstall Make via Chocolatey (if CLI and package exist)
$step++; Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Removing Make via Chocolatey..."
try {
    if ($hasChocoCli -and $hasChocoMakePkg) {
        choco uninstall make -y --no-progress | Out-Null
        Add-Ok "Removed Make via Chocolatey"
    } elseif ($hasChocoCli -and -not $hasChocoMakePkg) {
        Add-Info "Chocolatey CLI detected but Make package folder not found"
    } else {
        Add-Info "Chocolatey CLI not available; skipping choco uninstall"
    }
} catch { Add-Fail "Chocolatey uninstall failed: $($_.Exception.Message)" }

# 2) Clean PATH (Machine)
$step++; Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Cleaning PATH (Machine)..."
try {
    $current = [Environment]::GetEnvironmentVariable('Path','Machine')
    if ($current) {
        $new = ($current -split ';') | Where-Object {
            $keep = $true
            foreach ($pat in $removePatterns) { if ($_ -match [Regex]::Escape($pat)) { $keep = $false; break } }
            $keep
        }
        [Environment]::SetEnvironmentVariable('Path', ($new -join ';'), 'Machine')
        Add-Ok "Cleaned Machine PATH"
    } else {
        Add-Info "Machine PATH empty or not readable"
    }
} catch { Add-Fail "Failed to clean Machine PATH: $($_.Exception.Message)" }

# 3) Clean PATH (User)
$step++; Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Cleaning PATH (User)..."
try {
    $current = [Environment]::GetEnvironmentVariable('Path','User')
    if ($current) {
        $new = ($current -split ';') | Where-Object {
            $keep = $true
            foreach ($pat in $removePatterns) { if ($_ -match [Regex]::Escape($pat)) { $keep = $false; break } }
            $keep
        }
        [Environment]::SetEnvironmentVariable('Path', ($new -join ';'), 'User')
        Add-Ok "Cleaned User PATH"
    } else {
        Add-Info "User PATH empty or not readable"
    }
} catch { Add-Fail "Failed to clean User PATH: $($_.Exception.Message)" }

# 4) Optional: remove Chocolatey folder and env vars (safe, keeps PS alive)
$step++; Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Optional: remove Chocolatey..."
try {
    if (Test-Path $chocoRoot) {
        $ans = [System.Windows.MessageBox]::Show(
            "Do you want to completely remove Chocolatey (C:\ProgramData\chocolatey)?",
            "GNU Make Uninstaller",
            [System.Windows.MessageBoxButton]::YesNo,
            [System.Windows.MessageBoxImage]::Question
        )
        if ($ans -eq [System.Windows.MessageBoxResult]::Yes) {
            # Attempt normal deletion first
            try { Remove-Item -Recurse -Force $chocoRoot -ErrorAction Stop } catch {}

            # If folder still exists (likely locked DLL), do a deep clean via cmd
            if (Test-Path $chocoRoot) {
                cmd.exe /c "takeown /f `"$chocoRoot`" /r /d y >nul 2>&1 && icacls `"$chocoRoot`" /grant administrators:F /t >nul 2>&1 && rd /s /q `"$chocoRoot`""
                Start-Sleep -Seconds 1
            }

            [Environment]::SetEnvironmentVariable('ChocolateyInstall',$null,'Machine')
            [Environment]::SetEnvironmentVariable('ChocolateyInstall',$null,'User')

            if (-not (Test-Path $chocoRoot)) {
                Add-Ok "Chocolatey fully removed (including helpers and DLL)."
            } else {
                Add-Fail "Chocolatey directory could not be fully removed — manual cleanup may be needed."
            }
        } else {
            Add-Info "Chocolatey retained by user choice."
        }
    } else {
        Add-Info "Chocolatey folder not found."
    }
} catch { Add-Fail "Chocolatey removal step failed: $($_.Exception.Message)" }

# 5) Final verification of make.exe on PATH
$step++; Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Verifying result..."
$finalMake = Get-MakePath
if ($finalMake) { Add-Info ("make.exe still present at: " + $finalMake) } else { Add-Ok "make.exe not found on PATH" }

# Close progress window
Close-ProgressForm -Ui $ui

# --- Final summary ----------------------------------------------------------
Add-Type -AssemblyName PresentationFramework
$summary = ($report -join "`n")
[System.Windows.MessageBox]::Show(
    $summary + "`n`nOperation complete. You may restart Windows to finalize cleanup.",
    "GNU Make Uninstaller - Summary",
    [System.Windows.MessageBoxButton]::OK,
    [System.Windows.MessageBoxImage]::Information
) | Out-Null

# exit 0
