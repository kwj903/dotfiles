$ErrorActionPreference = "Stop"

Write-Host "[bootstrap-windows] 시작"

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

    Write-Host "[bootstrap-windows] $PackageId 설치"
    winget install --id $PackageId --exact --accept-package-agreements --accept-source-agreements --silent
    Refresh-Path
}

Install-WithWingetIfMissing -Command "git" -PackageId "Git.Git"

if (!(Test-Path "$HOME\dotfiles")) {
    git clone https://github.com/kwj903/dotfiles.git "$HOME\dotfiles"
} else {
    git -C "$HOME\dotfiles" pull --ff-only
}

& "$HOME\dotfiles\scripts\install-windows.ps1"
