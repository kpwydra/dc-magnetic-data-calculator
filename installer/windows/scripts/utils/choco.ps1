# 🍫 --- Install or repair Chocolatey ---------------------------------
# Ensures Chocolatey is installed and functional.
# Cleans up broken installations and reinstalls if necessary.
# Example:
#   Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Ensuring Chocolatey..."

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
