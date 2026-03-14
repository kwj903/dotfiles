# ------------------------------
# fzf
# ------------------------------
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}' --preview-window=right:60%"
export _ZO_FZF_OPTS="--height=40% --reverse"

if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX="$(brew --prefix fzf 2>/dev/null || true)"
  [[ -f "$FZF_PREFIX/shell/key-bindings.zsh" ]] && source "$FZF_PREFIX/shell/key-bindings.zsh"
  [[ -f "$FZF_PREFIX/shell/completion.zsh" ]] && source "$FZF_PREFIX/shell/completion.zsh"
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
elif [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi

# ------------------------------
# git-delta
# ------------------------------
if command -v delta >/dev/null 2>&1; then
  export GIT_PAGER="delta"
  export DELTA_PAGER="less -R"
fi

# ------------------------------
# atuin
# ------------------------------
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# ------------------------------
# direnv
# ------------------------------
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# ------------------------------
# zoxide
# ------------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
