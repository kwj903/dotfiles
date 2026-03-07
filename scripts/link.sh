mkdir -p ~/.dotfiles/scripts
cat > ~/.dotfiles/scripts/link.sh <<'EOF'
#!/usr/bin/env bash
set -e

echo "[LINK] ~/.zshrc -> ~/.dotfiles/zsh/zshrc"
ln -sfn "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"
EOF

chmod +x ~/.dotfiles/scripts/link.sh