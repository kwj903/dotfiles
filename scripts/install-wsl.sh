#!/usr/bin/env bash
set -euo pipefail

echo "[install-wsl] 시작"

"$HOME/.dotfiles/scripts/link-wsl.sh"

mkdir -p "$HOME/.dotfiles/zsh"
touch "$HOME/.dotfiles/zsh/local.zsh"
touch "$HOME/.dotfiles/zsh/secrets.zsh"

"$HOME/.dotfiles/scripts/check-wsl.sh"

echo
echo "완료. 새 셸 적용:"
echo "exec zsh"