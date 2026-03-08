$env:FZF_DEFAULT_OPTS = "--height 40% --reverse"

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
