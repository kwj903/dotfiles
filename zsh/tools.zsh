# fzf
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}' --preview-window=right:60%"
export _ZO_FZF_OPTS="--height=40% --reverse"

if [[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

if [[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
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

if [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
  source "/usr/local/opt/nvm/nvm.sh"
fi

if [[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ]]; then
  source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi