#!/usr/bin/env bash
set -e

echo "[1/4] Preparing Homebrew bundle..."

if command -v brew >/dev/null 2>&1; then
  echo "Homebrew found."
else
  echo "Homebrew is not installed."
  echo "Run bootstrap first."
  exit 1
fi

echo "[2/4] Installing Brew packages..."
if [ -f "$HOME/.dotfiles/brew/Brewfile" ]; then
  brew bundle --file="$HOME/.dotfiles/brew/Brewfile"
else
  echo "Brewfile not found."
fi

echo "[3/4] Creating symlinks..."
"$HOME/.dotfiles/scripts/link.sh"

echo "[4/4] Running health check..."
"$HOME/.dotfiles/scripts/check.sh"

echo
echo "Install complete."
echo "Now run: exec zsh"