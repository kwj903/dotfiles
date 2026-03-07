typeset -U path PATH

export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"
export EDITOR="code --wait"
export VISUAL="$EDITOR"
export PAGER="less -FRX"

case "$(uname -s)" in
  Darwin)
    path=(
      "$HOME/.local/bin"
      "/usr/local/bin"
      "/usr/local/sbin"
      "/usr/bin"
      "/bin"
      "/usr/sbin"
      "/sbin"
      $path
    )
    ;;
  Linux)
    path=(
      "$HOME/.local/bin"
      "$HOME/.local/share/pnpm"
      "/usr/local/bin"
      "/usr/bin"
      "/bin"
      $path
    )
    ;;
esac

[[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" "$PYENV_ROOT/shims" $path)
export PATH