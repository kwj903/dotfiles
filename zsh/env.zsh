# shell environment variables and PATH
typeset -U path PATH

export EDITOR="code --wait"
export VISUAL="$EDITOR"
export PAGER="less -FRX"
export GOG_ACCOUNT=kwakwoojae@gmail.com
export BUN_INSTALL="$HOME/.bun"

add_path_if_dir() {
  [[ -d "$1" ]] && path=("$1" $path)
}

add_macos_app_cli_paths() {
  local app_root app_path cli_dir

  for app_root in /Applications "$HOME/Applications"; do
    [[ -d "$app_root" ]] || continue

    for app_path in "$app_root"/*.app; do
      [[ -d "$app_path" ]] || continue

      for cli_dir in \
        "$app_path/Contents/Resources/bin" \
        "$app_path/Contents/SharedSupport/bin" \
        "$app_path/Contents/bin"
      do
        add_path_if_dir "$cli_dir"
      done
    done
  done
}

path=(
  "$HOME/.local/bin"
  "$BUN_INSTALL/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  $path
)

add_macos_app_cli_paths

export PATH
