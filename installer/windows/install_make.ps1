# ------------------------------------------------------------
# GNU Make Auto Setup Script for Windows
# ------------------------------------------------------------
# 1. Detects GnuWin32 make.exe
# 2. Adds it to PATH (system or user)
# 3. Launches a fresh PowerShell session
# 4. Runs "make --version" automatically
# 5. Prints success or failure message
# ------------------------------------------------------------

Write-Host "`n🔍 Searching for GnuWin32 make.exe..." -ForegroundColor Cyan

$possibleDirs = @(
    "$env:ProgramFiles (x86)\GnuWin32\bin",
    "$env:ProgramFiles\GnuWin32\bin",
    "C:\GnuWin32\bin"
)
$makePath = $possibleDirs | Where-Object { Test-Path "$_\make.exe" } | Select-Object -First 1

if (-not $makePath) {
    Write-Host "❌ Could not find make.exe. Please check that GnuWin32 is installed." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found make.exe in: $makePath" -ForegroundColor Green

function Add-ToPath($targetPath, $scope) {
    $current = [Environment]::GetEnvironmentVariable('Path', $scope)
    if ($current -notmatch [Regex]::Escape($targetPath)) {
        [Environment]::SetEnvironmentVariable('Path', "$current;$targetPath", $scope)
        Write-Host "✅ Added to $scope PATH: $targetPath" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ℹ️ Already present in $scope PATH." -ForegroundColor Yellow
        return $false
    }
}

# Try machine-level first
$added = $false
try {
    $added = Add-ToPath $makePath 'Machine'
} catch {
    Write-Host "⚠️ Not running as Administrator. Trying user-level PATH..." -ForegroundColor Yellow
    $added = Add-ToPath $makePath 'User'
}

# Launch a new PowerShell window to test
Write-Host "`n🔁 Refreshing environment..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

# Build test command
$testCmd = @"
`$ErrorActionPreference = 'SilentlyContinue'
`$ver = (& make --version) 2>&1
if (`$LASTEXITCODE -eq 0 -and `$ver -match 'GNU Make') {
    Write-Host "`n🎉 SUCCESS! GNU Make is installed and ready to use.`n" -ForegroundColor Green
    Write-Host "Version info:`n`$ver" -ForegroundColor White
    Write-Host "`nYou can now run 'make' commands from any terminal." -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "`n❌ ERROR: 'make' command not recognized." -ForegroundColor Red
    Write-Host "Please restart your computer or recheck PATH settings." -ForegroundColor Yellow
    exit 1
}
"@

# Spawn a new elevated PowerShell window for the test
Start-Process powershell -ArgumentList "-NoExit", "-Command", $testCmd
