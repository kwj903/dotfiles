$ErrorActionPreference = "Stop"

Write-Host "[install-windows] 시작"

$profileDir = Split-Path -Parent $PROFILE
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$target = "$HOME\dotfiles\powershell\Microsoft.PowerShell_profile.ps1"

if (Test-Path $PROFILE) {
    Remove-Item $PROFILE -Force
}

New-Item -ItemType SymbolicLink -Path $PROFILE -Target $target -Force | Out-Null

& "$HOME\dotfiles\scripts\check-windows.ps1"

Write-Host "완료. PowerShell을 다시 여세요."