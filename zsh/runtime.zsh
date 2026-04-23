# Purpose: 런타임 매니저 활성화와 PATH 정리를 담당한다.
# 언어/도구 버전 선택은 mise 하나만 맡기고, 예전 매니저 흔적은 먼저 제거한다.
# 공통 환경변수나 비밀값은 이 파일에 두지 않는다.

typeset -U path PATH

# remove old manager leftovers from PATH before mise activation
path=(${path:#$HOME/.nvm/*})
path=(${path:#$HOME/.pyenv/shims})
path=(${path:#$HOME/.pyenv/bin})
path=(${path:#$HOME/.volta/bin})
path=(${path:#$HOME/.asdf/shims})
path=(${path:#$HOME/.asdf/bin})
path=(${path:#$HOME/.fnm/*})
path=(${path:#$HOME/Library/Application Support/fnm/*})
path=(${path:#$HOME/.local/share/mise/installs/*})

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# version-neutral global CLI bins should stay ahead of runtime-specific install bins
[[ -d "$HOME/.npm-global/bin" ]] && path=("$HOME/.npm-global/bin" $path)

typeset -U path PATH

export PATH

# ===== Zsh completion 초기화 =====
# completion 시스템은 한 번만 초기화한다.
if [[ -z "${DOTFILES_COMPINIT_DONE:-}" ]]; then
  autoload -Uz compinit
  compinit
  export DOTFILES_COMPINIT_DONE=1
fi

# ===== completion 동작 기본 옵션 =====
# Tab이 첫 후보를 강제로 꽂아넣으며 순환하는 동작은 끈다.
unsetopt MENU_COMPLETE

# 여러 후보가 있으면 목록/메뉴 쪽으로 동작하게 한다.
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_IN_WORD

# 메뉴 선택 UI 모듈
zmodload zsh/complist

# 메뉴형 선택 UI
zstyle ':completion:*' menu select=1
zstyle ':completion:*' list yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' verbose yes

# ===== llama helper completion =====
# compinit 이후에 로드되어야 한다.
if [[ -f "$DOTFILES_DIR/zsh/modules/llama_completions.zsh" ]]; then
  source "$DOTFILES_DIR/zsh/modules/llama_completions.zsh"
fi