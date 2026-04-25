#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OH_MY_ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
P10K_DIR="$OH_MY_ZSH_DIR/custom/themes/powerlevel10k"

ensure_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "이 스크립트는 macOS 전용입니다."
    exit 1
  fi
}

ensure_brew_in_path() {
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"
}

install_oh_my_zsh_if_missing() {
  if [[ -d "$OH_MY_ZSH_DIR" ]]; then
    return
  fi

  echo "[install] oh-my-zsh 설치"
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_DIR"
}

install_powerlevel10k_if_missing() {
  if [[ -d "$P10K_DIR" ]]; then
    return
  fi

  echo "[install] powerlevel10k 설치"
  mkdir -p "$(dirname "$P10K_DIR")"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
}

install_bun_if_missing() {
  if command -v bun >/dev/null 2>&1; then
    return
  fi

  echo "[install] bun 설치"
  curl -fsSL https://bun.sh/install | bash
}

seed_local_files() {
  if [[ ! -f "$DOTFILES_DIR/zsh/local.zsh" ]]; then
    cp "$DOTFILES_DIR/zsh/local.zsh.example" "$DOTFILES_DIR/zsh/local.zsh"
  fi

  if [[ ! -f "$DOTFILES_DIR/zsh/secrets.zsh" ]]; then
    cp "$DOTFILES_DIR/zsh/secrets.zsh.example" "$DOTFILES_DIR/zsh/secrets.zsh"
  fi
}

install_mise_runtimes() {
  if ! command -v mise >/dev/null 2>&1; then
    echo "[install] mise가 PATH에 없어 런타임 설치를 건너뜁니다."
    return 1
  fi

  if [[ -f "$DOTFILES_DIR/mise/config.toml" ]]; then
    echo "[install] mise config trust"
    mise trust --yes "$DOTFILES_DIR/mise/config.toml"
  fi

  echo "[install] mise 런타임 설치"
  mise install
}

echo "[install] macOS dotfiles 설치 시작"

ensure_macos
ensure_brew_in_path

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew가 없습니다. scripts/bootstrap.sh를 먼저 실행하세요."
  exit 1
fi

brew bundle --file="$DOTFILES_DIR/Brewfile"

install_oh_my_zsh_if_missing
install_powerlevel10k_if_missing
install_bun_if_missing

"$DOTFILES_DIR/scripts/link.sh"
install_mise_runtimes
seed_local_files
"$DOTFILES_DIR/scripts/check.sh"

echo
echo "완료. 새 셸 적용:"
echo "exec zsh"
