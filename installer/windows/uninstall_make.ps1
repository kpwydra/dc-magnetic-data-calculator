# ------------------------------------------------------------
# GNU Make Uninstaller for Windows
# ------------------------------------------------------------
# Safely removes GNU Make (GnuWin32) and cleans PATH entries.
# Works for both system-level and user-level PATH variables.
# Optional: Uninstalls via winget if installed that way.
# ------------------------------------------------------------

Write-Host "`n🧹 Starting GNU Make Uninstaller..." -ForegroundColor Cyan

# Define typical install locations
$possibleDirs = @(
    "$env:ProgramFiles (x86)\GnuWin32\bin",
    "$env:ProgramFiles\GnuWin32\bin",
    "C:\GnuWin32\bin"
)

# Detect existing make.exe
$makePath = $possibleDirs | Where-Object { Test-Path "$_\make.exe" } | Select-Object -First 1
if ($makePath) {
    Write-Host "🔍 Found make.exe at: $makePath" -ForegroundColor Yellow
} else {
    Write-Host "ℹ️ make.exe not found in standard locations." -ForegroundColor Gray
}

function Remove-FromPath {
    param (
        [string]$scope
    )
    $current = [Environment]::GetEnvironmentVariable('Path', $scope)
    if (-not $current) { return }

    $updated = $current
    foreach ($dir in $possibleDirs) {
        $pattern = [Regex]::Escape($dir)
        $updated = ($updated -split ';') | Where-Object {$_ -and ($_ -notmatch $pattern)} | ForEach-Object {$_}
        $updated = ($updated -join ';')
    }

    if ($updated -ne $current) {
        [Environment]::SetEnvironmentVariable('Path', $updated, $scope)
        Write-Host "✅ Removed Make paths from $scope PATH" -ForegroundColor Green
    } else {
        Write-Host "ℹ️ No Make-related entries found in $scope PATH" -ForegroundColor Yellow
    }
}

# Remove from system PATH (requires admin)
try {
    Remove-FromPath 'Machine'
} catch {
    Write-Host "⚠️ No admin rights. Skipping system PATH cleanup." -ForegroundColor Yellow
}

# Remove from user PATH
Remove-FromPath 'User'

# Uninstall via winget if available
try {
    Write-Host "`n🔍 Checking for winget package..." -ForegroundColor Cyan
    $pkg = winget list | Where-Object { $_ -match "GnuWin32.Make" }
    if ($pkg) {
        Write-Host "📦 Found winget package: GnuWin32.Make" -ForegroundColor Yellow
        winget uninstall --id GnuWin32.Make -e --silent
        Write-Host "✅ Uninstalled GnuWin32.Make via winget." -ForegroundColor Green
    } else {
        Write-Host "ℹ️ No winget package found for Make." -ForegroundColor Gray
    }
} catch {
    Write-Host "⚠️ winget not available — skipping package removal." -ForegroundColor Yellow
}

# Optionally remove leftover folder
if ($makePath -and (Test-Path $makePath)) {
    try {
        Remove-Item -Path (Split-Path $makePath -Parent) -Recurse -Force -ErrorAction Stop
        Write-Host "🗑️ Deleted folder: $(Split-Path $makePath -Parent)" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Could not delete folder (possibly in use): $(Split-Path $makePath -Parent)" -ForegroundColor Yellow
    }
}

Write-Host "`n🎯 GNU Make has been removed from this system." -ForegroundColor Cyan
Write-Host "🔁 Please restart PowerShell or your computer to apply changes." -ForegroundColor Yellow
