# fzf
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

# direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# pyenv
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
elif command -v brew >/dev/null 2>&1; then
  NVM_PREFIX="$(brew --prefix nvm 2>/dev/null || true)"
  [[ -n "$NVM_PREFIX" && -s "$NVM_PREFIX/nvm.sh" ]] && source "$NVM_PREFIX/nvm.sh"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi