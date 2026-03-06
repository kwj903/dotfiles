typeset -U path PATH

export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"

export EDITOR="code --wait"
export VISUAL="$EDITOR"
export PAGER="less -FRX"

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

[[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" "$PYENV_ROOT/shims" $path)

export PATH