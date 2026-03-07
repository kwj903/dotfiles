# fzf
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}' --preview-window=right:60%"
export _ZO_FZF_OPTS="--height=40% --reverse"

if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX="$(brew --prefix fzf 2>/dev/null || brew --prefix)/opt/fzf"

  [[ -f "$FZF_PREFIX/shell/key-bindings.zsh" ]] && source "$FZF_PREFIX/shell/key-bindings.zsh"
  [[ -f "$FZF_PREFIX/shell/completion.zsh" ]] && source "$FZF_PREFIX/shell/completion.zsh"
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

if command -v brew >/dev/null 2>&1; then
  NVM_PREFIX="$(brew --prefix nvm 2>/dev/null)"
  [[ -n "$NVM_PREFIX" && -s "$NVM_PREFIX/nvm.sh" ]] && source "$NVM_PREFIX/nvm.sh"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi