#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OH_MY_ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
P10K_DIR="$OH_MY_ZSH_DIR/custom/themes/powerlevel10k"
FZF_TAB_FILE=""
MISE_BREW_BIN=""

if command -v brew >/dev/null 2>&1; then
  FZF_TAB_PREFIX="$(brew --prefix fzf-tab 2>/dev/null || true)"
  FZF_TAB_FILE="$FZF_TAB_PREFIX/share/fzf-tab/fzf-tab.zsh"

  MISE_BREW_PREFIX="$(brew --prefix mise 2>/dev/null || true)"
  MISE_BREW_BIN="$MISE_BREW_PREFIX/bin/mise"
fi

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "[OK] $1"
  else
    echo "[MISSING] $1"
  fi
}

check_file() {
  if [[ -e "$1" ]]; then
    echo "[OK] $2"
  else
    echo "[MISSING] $2"
  fi
}

check_mise_runtime() {
  local tool="$1"
  local expected_prefix="$2"
  local resolved_path

  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "[MISSING] $tool"
    return
  fi

  resolved_path="$(command -v "$tool")"
  if [[ "$resolved_path" == "$HOME/.local/share/mise/installs/$expected_prefix"* ]]; then
    echo "[OK] $tool -> $resolved_path"
  else
    echo "[WARN] $tool is not from mise: $resolved_path"
  fi
}

echo "=== macOS dotfiles health check ==="
check_cmd git
check_cmd brew
check_cmd zsh
check_cmd fzf
check_cmd rg
check_cmd bat
check_cmd eza
check_cmd zoxide
check_cmd tmux
check_cmd lazygit
check_cmd gh
check_cmd just
check_cmd delta
check_cmd watchexec
check_cmd hyperfine
check_cmd atuin
check_cmd direnv
check_cmd mise
check_cmd bun
check_cmd code

echo
echo "=== mise runtime check ==="
if [[ -x "$MISE_BREW_BIN" ]]; then
  echo "[OK] mise Homebrew binary: $MISE_BREW_BIN"
else
  echo "[MISSING] mise Homebrew binary"
fi

if [[ -L "$HOME/.config/mise/config.toml" ]]; then
  ls -l "$HOME/.config/mise/config.toml"
else
  echo "[WARN] ~/.config/mise/config.toml is not a symlink"
fi

if command -v mise >/dev/null 2>&1; then
  mise trust --show "$DOTFILES_DIR/mise/config.toml" 2>/dev/null | sed 's/^/[mise trust] /'
fi

if [[ "$(command -v mise 2>/dev/null || true)" == "$HOME/.local/bin/mise" ]]; then
  echo "[WARN] active mise is standalone: $HOME/.local/bin/mise"
fi

if command -v mise >/dev/null 2>&1; then
  mise ls --current 2>/dev/null | sed 's/^/[mise] /'
else
  echo "[MISSING] mise current tools"
fi

check_mise_runtime node node
check_mise_runtime python3 python

echo
echo "=== shell assets ==="
check_file "$OH_MY_ZSH_DIR/oh-my-zsh.sh" "oh-my-zsh"
check_file "$P10K_DIR/powerlevel10k.zsh-theme" "powerlevel10k"
check_file "$FZF_TAB_FILE" "fzf-tab"
check_file "$DOTFILES_DIR/zsh/p10k.zsh" "fallback prompt config"

echo
echo "=== symlink check ==="
if [[ -L "$HOME/.zshrc" ]]; then
  ls -l "$HOME/.zshrc"
else
  echo "[WARN] ~/.zshrc is not a symlink"
fi
