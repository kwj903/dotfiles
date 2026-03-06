#!/usr/bin/env bash

set -e

echo "Starting dotfiles install..."

# brew bundle 사용 준비
brew tap homebrew/bundle

# Brewfile 설치
if [ -f brew/Brewfile ]; then
  echo "Installing Brew packages..."
  brew bundle --file=brew/Brewfile
fi

echo "Creating symlink for zshrc..."

ln -sf ~/.dotfiles/zsh/zshrc ~/.zshrc

echo "Reloading shell..."

source ~/.zshrc

echo "Dotfiles install complete."