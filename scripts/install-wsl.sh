#!/usr/bin/env bash
set -euo pipefail

echo "[install-wsl] 시작"

sudo apt update
sudo apt install -y git curl zsh fzf ripgrep bat tmux jq unzip zip

mkdir -p "$HOME/.local/bin"

if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

if ! command -v eza >/dev/null 2>&1; then
  if apt-cache show eza >/dev/null 2>&1; then
    sudo apt install -y eza
  elif apt-cache show exa >/dev/null 2>&1; then
    sudo apt install -y exa
    ln -sfn "$(command -v exa)" "$HOME/.local/bin/eza"
  else
    echo "[install-wsl] eza 또는 exa 패키지를 찾지 못했습니다."
  fi
fi

if ! command -v zoxide >/dev/null 2>&1; then
  if apt-cache show zoxide >/dev/null 2>&1; then
    sudo apt install -y zoxide
  else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  fi
fi

"$HOME/.dotfiles/scripts/link-wsl.sh"

mkdir -p "$HOME/.dotfiles/zsh"
touch "$HOME/.dotfiles/zsh/local.zsh"
touch "$HOME/.dotfiles/zsh/secrets.zsh"

chsh -s "$(command -v zsh)" || true

"$HOME/.dotfiles/scripts/check-wsl.sh"

echo
echo "완료. 새 셸 적용:"
echo "exec zsh"
