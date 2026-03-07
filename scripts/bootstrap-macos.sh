#!/usr/bin/env bash
set -euo pipefail

echo "[bootstrap-macos] 시작"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools 설치가 필요합니다."
  xcode-select --install || true
  echo "설치 후 다시 실행하세요."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"

if ! command -v git >/dev/null 2>&1; then
  echo "git 설치 중..."
  brew install git
fi

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "dotfiles clone 중..."
  git clone https://github.com/kwj903/dotfiles.git "$HOME/.dotfiles"
else
  echo "dotfiles 이미 존재. 최신화 중..."
  git -C "$HOME/.dotfiles" pull --ff-only
fi

chmod +x "$HOME/.dotfiles"/scripts/*.sh
"$HOME/.dotfiles/scripts/install-macos.sh"