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
. "$PSScriptRoot\utils\logging.ps1"
. "$PSScriptRoot\utils\ui_helpers.ps1"
. "$PSScriptRoot\utils\path.ps1"
. "$PSScriptRoot\utils\forms.ps1"
. "$PSScriptRoot\utils\choco.ps1"
. "$PSScriptRoot\steps\gnu_make.ps1"

# --- Entry Point ------------------------------------------------------------
try {
    Write-Host "🔧 Starting MagBridge Installer..."
    Initialize-Environment
    Show-WelcomeForm
    Start-InstallationProcess
    Install-GnuMake -Ui $ui -Step 2 -Total $steps
    Show-FinalSummary
    Write-Host "✅ Installer finished."
    Close-ProgressForm -Ui $ui
} catch {
    Write-Host "❌ Fatal error: $($_.Exception.Message)"
    exit 1
}
