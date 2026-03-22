#!/usr/bin/env bash
set -euo pipefail

echo "[install-macos] 시작"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew가 없습니다. bootstrap-macos.sh를 먼저 실행하세요."
  exit 1
fi

if [ -f "$HOME/.dotfiles/brew/Brewfile" ]; then
  brew bundle install --file="$HOME/.dotfiles/brew/Brewfile" --cleanup
else
  echo "Brewfile이 없습니다."
fi

"$HOME/.dotfiles/scripts/link-macos.sh"

mkdir -p "$HOME/.dotfiles/zsh"
touch "$HOME/.dotfiles/zsh/local.zsh"
touch "$HOME/.dotfiles/zsh/secrets.zsh"

"$HOME/.dotfiles/scripts/check-macos.sh"

echo
echo "완료. 새 셸 적용:"
echo "exec zsh"
