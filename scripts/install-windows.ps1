$ErrorActionPreference = "Stop"

Write-Host "[install-windows] 시작"

function Refresh-Path {
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

function Install-WithWingetIfMissing {
    param(
        [Parameter(Mandatory = $true)][string]$Command,
        [Parameter(Mandatory = $true)][string]$PackageId
    )

    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        return
    }

    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget이 필요합니다. App Installer를 먼저 설치하세요."
    }

    Write-Host "[install-windows] $PackageId 설치"
    winget install --id $PackageId --exact --accept-package-agreements --accept-source-agreements --silent
    Refresh-Path
}

Install-WithWingetIfMissing -Command "git" -PackageId "Git.Git"
Install-WithWingetIfMissing -Command "rg" -PackageId "BurntSushi.ripgrep.MSVC"
Install-WithWingetIfMissing -Command "fzf" -PackageId "junegunn.fzf"
Install-WithWingetIfMissing -Command "bat" -PackageId "sharkdp.bat"
Install-WithWingetIfMissing -Command "eza" -PackageId "eza-community.eza"
Install-WithWingetIfMissing -Command "zoxide" -PackageId "ajeetdsouza.zoxide"
Install-WithWingetIfMissing -Command "lazygit" -PackageId "JesseDuffield.lazygit"

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
