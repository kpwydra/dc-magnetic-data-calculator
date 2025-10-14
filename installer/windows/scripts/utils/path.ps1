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
