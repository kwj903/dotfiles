#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

backup_if_needed() {
  local target="$1"
  local source_path="$2"

  if [[ -e "$target" && ! -L "$target" ]]; then
    local backup_path="${target}.backup.$(date +%Y%m%d%H%M%S)"
    echo "[link] 기존 파일 백업: $target -> $backup_path"
    mv "$target" "$backup_path"
  fi

  ln -sfn "$source_path" "$target"
}

link_bin_commands() {
  local source_path target_path name

  if [[ ! -d "$DOTFILES_DIR/bin" ]]; then
    return
  fi

  mkdir -p "$HOME/bin"

  for source_path in "$DOTFILES_DIR"/bin/*; do
    [[ -e "$source_path" ]] || continue
    [[ -f "$source_path" ]] || continue

    name="$(basename "$source_path")"
    target_path="$HOME/bin/$name"

    echo "[link] $target_path -> $source_path"
    chmod +x "$source_path"
    backup_if_needed "$target_path" "$source_path"
  done
}

echo "[link] ~/.zshrc -> $DOTFILES_DIR/zsh/zshrc"
backup_if_needed "$HOME/.zshrc" "$DOTFILES_DIR/zsh/zshrc"

echo "[link] ~/.config/mise/config.toml -> $DOTFILES_DIR/mise/config.toml"
mkdir -p "$HOME/.config/mise"
backup_if_needed "$HOME/.config/mise/config.toml" "$DOTFILES_DIR/mise/config.toml"

link_bin_commands
