#!/usr/bin/env bash
set -euo pipefail

echo "[1/5] 기본 패키지 설치"
sudo apt update
sudo apt install -y git curl zsh fzf ripgrep bat tmux jq unzip zip

echo "[2/5] zoxide 설치"
if ! command -v zoxide >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

echo "[3/5] dotfiles 연결"
mkdir -p "$HOME/.dotfiles"
cd "$HOME/.dotfiles"

echo "[4/5] ~/.zshrc 심볼릭 링크"
ln -sfn "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"

echo "[5/5] 기본 로컬 파일 생성"
touch "$HOME/.dotfiles/zsh/local.zsh"
touch "$HOME/.dotfiles/zsh/secrets.zsh"

chsh -s "$(command -v zsh)" || true

echo "완료. 새 셸에서 zsh를 실행하세요."