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
