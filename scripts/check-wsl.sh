#!/usr/bin/env bash
set -euo pipefail

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "[OK] $1"
  else
    echo "[MISSING] $1"
  fi
}

echo "=== WSL dotfiles health check ==="
check_cmd git
check_cmd zsh
check_cmd fzf
check_cmd rg
check_cmd bat
check_cmd eza
check_cmd zoxide
check_cmd tmux