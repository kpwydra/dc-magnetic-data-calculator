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

# 🔍 --- Step 4: Verify GNU Make ----------------------------------------------
# Checks whether GNU Make is available and functioning.
# Runs 'make --version' and logs the result.
# Example:
#   Verify-GnuMake -Ui $ui -Step 4 -Total $steps

function Verify-GnuMake {
    param(
        [Parameter(Mandatory)][object]$Ui,
        [Parameter(Mandatory)][int]$Step,
        [Parameter(Mandatory)][int]$Total
    )

    Update-ProgressForm -Ui $Ui -Step $Step -Total $Total -Message "Verifying GNU Make..."
    try {
        Update-EnvironmentPath
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
}
