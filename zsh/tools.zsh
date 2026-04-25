# Purpose: 설치된 CLI 도구의 shell hook과 integration을 초기화한다.
# completion UI와 입력 보조 플러그인은 completion.zsh에서 로드 순서를 관리한다.
export _ZO_FZF_OPTS="--height=40% --reverse"

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

# ------------------------------
# bun
# ------------------------------
if [[ -s "$HOME/.bun/_bun" ]]; then
  source "$HOME/.bun/_bun"
fi
