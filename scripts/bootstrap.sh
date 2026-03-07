#!/usr/bin/env bash
set -e

echo "Bootstrapping development environment..."

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"

if ! command -v git >/dev/null 2>&1; then
  echo "Installing git..."
  brew install git
fi

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Cloning dotfiles..."
  git clone https://github.com/kwj903/dotfiles.git "$HOME/.dotfiles"
fi

cd "$HOME/.dotfiles"
chmod +x scripts/install.sh scripts/link.sh scripts/check.sh
./scripts/install.sh

echo "Bootstrap finished."