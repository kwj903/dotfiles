function ll { eza -la }
function la { eza -a }
function tree { eza --tree }
function g { lazygit }

if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias cat bat
}
