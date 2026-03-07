$ErrorActionPreference = "Stop"

$repo = "$HOME\dotfiles"
$profileDir = Split-Path -Parent $PROFILE
$target = "$repo\powershell\Microsoft.PowerShell_profile.ps1"

if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

if (Test-Path $PROFILE) {
    Remove-Item $PROFILE -Force
}

New-Item -ItemType SymbolicLink -Path $PROFILE -Target $target -Force
Write-Host "PowerShell profile linked: $PROFILE -> $target"