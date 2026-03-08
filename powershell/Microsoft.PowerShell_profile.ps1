$profileRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

foreach ($relativePath in @("aliases.ps1", "functions.ps1", "tools.ps1")) {
    $scriptPath = Join-Path $profileRoot $relativePath
    if (Test-Path $scriptPath) {
        . $scriptPath
    }
}
