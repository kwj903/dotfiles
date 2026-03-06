export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}' --preview-window=right:60%"

export _ZO_FZF_OPTS='--height=40% --reverse'

[[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]] && \
source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"