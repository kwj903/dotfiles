#!/usr/bin/env bash
set -euo pipefail

echo "[link-macos] ~/.zshrc -> ~/.dotfiles/zsh/zshrc"
ln -sfn "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"