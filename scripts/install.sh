#!/bin/bash

echo "Starting dotfiles setup..."

# Homebrew 설치 여부 확인
if ! command -v brew &> /dev/null
then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing CLI tools..."
brew bundle --file=brew/Brewfile

echo "Creating symlink for zshrc..."

ln -sf ~/.dotfiles/zsh/zshrc ~/.zshrc

echo "Reloading shell..."

source ~/.zshrc

echo "Setup complete."