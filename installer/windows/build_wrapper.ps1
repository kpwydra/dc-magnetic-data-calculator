param(
    [string]$OutDir,
    [string]$Source,
    [string]$Output,
    [string]$Title = "Windows Utility"
)

if (-not (Test-Path $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir | Out-Null
}

try {
    if (Get-Module -ListAvailable -Name PS2EXE) {
        Import-Module PS2EXE -ErrorAction Stop
        Invoke-PS2EXE -InputFile  $Source -OutputFile $Output -Title $Title -RequireAdmin -NoConsole
        Write-Host "[OK] Build complete: $Output"
    } else {
        Write-Host "[INFO] PS2EXE not found - running script directly..."
        & $Source
    }
}
catch {
    Write-Host "[ERROR] Build failed: $($_.Exception.Message)"
    exit 1
}
