typeset -U path PATH

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

export PATH