#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OH_MY_ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
P10K_DIR="$OH_MY_ZSH_DIR/custom/themes/powerlevel10k"

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "[OK] $1"
  else
    echo "[MISSING] $1"
  fi
}

check_file() {
  if [[ -e "$1" ]]; then
    echo "[OK] $2"
  else
    echo "[MISSING] $2"
  fi
}

echo "=== macOS dotfiles health check ==="
check_cmd git
check_cmd brew
check_cmd zsh
check_cmd fzf
check_cmd rg
check_cmd bat
check_cmd eza
check_cmd zoxide
check_cmd tmux
check_cmd lazygit
check_cmd gh
check_cmd just
check_cmd delta
check_cmd watchexec
check_cmd hyperfine
check_cmd atuin
check_cmd direnv
check_cmd mise
check_cmd bun
check_cmd code

echo
echo "=== shell assets ==="
check_file "$OH_MY_ZSH_DIR/oh-my-zsh.sh" "oh-my-zsh"
check_file "$P10K_DIR/powerlevel10k.zsh-theme" "powerlevel10k"
check_file "$DOTFILES_DIR/zsh/p10k.zsh" "fallback prompt config"

echo
echo "=== symlink check ==="
if [[ -L "$HOME/.zshrc" ]]; then
  ls -l "$HOME/.zshrc"
else
  echo "[WARN] ~/.zshrc is not a symlink"
fi
