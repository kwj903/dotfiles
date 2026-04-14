#!/usr/bin/env bash
set -euo pipefail

# Policy: manage language runtimes with mise, but keep shared CLI tools as independent installs when possible.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "[bootstrap] macOS 초기 설정 시작"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "이 스크립트는 macOS 전용입니다."
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools 설치가 필요합니다."
  xcode-select --install || true
  echo "설치가 끝난 뒤 다시 실행하세요."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"

"$DOTFILES_DIR/scripts/install.sh"
