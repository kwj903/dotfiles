#!/usr/bin/env bash
set -euo pipefail

echo "[bootstrap-wsl] 시작"

sudo apt update
sudo apt install -y git curl zsh fzf ripgrep bat tmux jq unzip zip

if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/kwj903/dotfiles.git "$HOME/.dotfiles"
else
  git -C "$HOME/.dotfiles" pull --ff-only
fi

chmod +x "$HOME/.dotfiles"/scripts/*.sh
"$HOME/.dotfiles/scripts/install-wsl.sh"