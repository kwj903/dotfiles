# 기본 별칭
function ll { eza -la }
function la { eza -a }
function tree { eza --tree }
function g { lazygit }

function rgfv {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Pattern)
    $results = rg --line-number --no-heading @Pattern |
        fzf --delimiter ':' --preview 'bat --color=always {1} --highlight-line {2}' --preview-window=right:60%

    if ($results) {
        $parts = $results -split ':', 3
        $file = $parts[0]
        $line = $parts[1]
        code -g "${file}:${line}"
    }
}

# zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# fzf 관련
$env:FZF_DEFAULT_OPTS = "--height 40% --reverse"

# 편의
Set-Alias cat bat