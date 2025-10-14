# 🧰 --- Install GNU Make ---------------------------------------------
# Installs GNU Make using Chocolatey if available.
# Logs success or failure and continues gracefully if Chocolatey is missing.
# Example:
#   Install-GnuMake -Ui $ui -Step 2 -Total $steps

function Install-GnuMake {
    param(
        [Parameter(Mandatory)][object]$Ui,
        [Parameter(Mandatory)][int]$Step,
        [Parameter(Mandatory)][int]$Total
    )

    Update-ProgressForm -Ui $Ui -Step $Step -Total $Total -Message "Installing GNU Make..."
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
}
