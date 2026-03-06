#!/usr/bin/env bash

set -e

echo "Bootstrapping development environment..."

# Homebrew 설치
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# brew PATH 적용
eval "$(/opt/homebrew/bin/brew shellenv)"

# git 설치
if ! command -v git &> /dev/null; then
  echo "Installing git..."
  brew install git
fi

# dotfiles clone
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Cloning dotfiles..."
  git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
fi

cd ~/.dotfiles

chmod +x install.sh
./install.sh

echo "Bootstrap finished."