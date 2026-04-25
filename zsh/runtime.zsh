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
