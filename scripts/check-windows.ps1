$commands = @("git", "rg", "fzf", "bat", "eza", "zoxide", "lazygit")

Write-Host "=== Windows PowerShell health check ==="
foreach ($cmd in $commands) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        Write-Host "[OK] $cmd"
    } else {
        Write-Host "[MISSING] $cmd"
    }
}

Write-Host ""
Write-Host "=== profile check ==="
if (Test-Path $PROFILE) {
    Write-Host "[OK] profile exists: $PROFILE"
} else {
    Write-Host "[WARN] profile not found"
}
