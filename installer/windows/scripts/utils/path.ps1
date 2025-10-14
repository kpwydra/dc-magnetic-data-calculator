# 🔁 --- Environment PATH utilities -------------------------------------------
# Synchronizes the current PowerShell session's PATH variable
# with the latest Machine + User environment values.
# Example:
#   Update-EnvironmentPath

function Update-EnvironmentPath {
    try {
        $env:PATH = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' +
                    [System.Environment]::GetEnvironmentVariable('Path','User')
        Write-LogInfo "PATH variable refreshed in current session."
    } catch {
        Write-LogWarn "Failed to refresh PATH in current session: $_"
    }
}

# 🔁 --- Step 3: Update PATH --------------------------------------------------
# Adds Chocolatey and GNU Make directories to the system PATH if missing.
# Ensures the installer environment reflects updated PATH settings.
# Example:
#   Update-ProgressForm -Ui $ui -Step $step -Total $steps -Message "Updating PATH..."

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
