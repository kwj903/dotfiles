$ErrorActionPreference = "Stop"

Write-Host "[bootstrap-windows] 시작"

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "git이 필요합니다. winget 또는 수동 설치 후 다시 실행하세요."
    exit 1
}

if (!(Test-Path "$HOME\dotfiles")) {
    git clone https://github.com/kwj903/dotfiles.git "$HOME\dotfiles"
} else {
    git -C "$HOME\dotfiles" pull --ff-only
}

& "$HOME\dotfiles\scripts\install-windows.ps1"