# interactive shell aliases only
alias ls="eza"
alias ll="eza -la"
alias tree="eza --tree"

# convenience overrides for interactive use
alias cat="bat --paging=never"
alias grep="rg"

alias g="lazygit"
alias j="just"
alias w="watchexec"
alias hf="hyperfine"

# tmux alias 모음
alias ta='tmux new -As work'

# 클로드 코드 오픈 라이터 관련 alias
cc-or() {
  local model="$1"
  if [[ -z "$model" ]]; then
    echo "사용법: cc-or <openrouter-model-id>"
    return 1
  fi

  ANTHROPIC_BASE_URL="https://openrouter.ai/api" \
  ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY" \
  ANTHROPIC_API_KEY="" \
  ANTHROPIC_CUSTOM_MODEL_OPTION="$model" \
  ANTHROPIC_CUSTOM_MODEL_OPTION_NAME="$model" \
  ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION="OpenRouter model" \
  claude --model "$model"
}


# ===== gstack toggle (fixed) =====

GSTACK_REPO="$HOME/workspace/archive/ai-work-data/gstack-claude-symlink/gstack"
GSTACK_ON_DIR="$HOME/.claude/skills"
GSTACK_OFF_DIR="$HOME/.claude/skills.off"

typeset -ga GSTACK_ITEMS
GSTACK_ITEMS=(
  autoplan
  benchmark
  browse
  canary
  careful
  codex
  connect-chrome
  cso
  design-consultation
  design-html
  design-review
  design-shotgun
  document-release
  freeze
  gstack-upgrade
  guard
  investigate
  land-and-deploy
  learn
  office-hours
  plan-ceo-review
  plan-design-review
  plan-eng-review
  qa
  qa-only
  retro
  review
  setup-browser-cookies
  setup-deploy
  ship
  unfreeze
)

gstack-on() {
  mkdir -p "$GSTACK_ON_DIR" "$GSTACK_OFF_DIR"

  # OFF 쪽에 남아 있는 gstack 루트 링크 제거
  rm -f "$GSTACK_OFF_DIR/gstack"

  # ON 쪽에 gstack 루트 링크 재생성
  ln -sfn "$GSTACK_REPO" "$GSTACK_ON_DIR/gstack"

  local name
  for name in "${GSTACK_ITEMS[@]}"; do
    if [[ -e "$GSTACK_OFF_DIR/$name" || -L "$GSTACK_OFF_DIR/$name" ]]; then
      mv "$GSTACK_OFF_DIR/$name" "$GSTACK_ON_DIR/"
    fi
  done

  echo "gstack ON"
  echo "Claude Code를 완전히 재시작한 뒤 /skills 로 확인하세요."
}

gstack-off() {
  mkdir -p "$GSTACK_ON_DIR" "$GSTACK_OFF_DIR"

  local name
  for name in "${GSTACK_ITEMS[@]}"; do
    if [[ -e "$GSTACK_ON_DIR/$name" || -L "$GSTACK_ON_DIR/$name" ]]; then
      mv "$GSTACK_ON_DIR/$name" "$GSTACK_OFF_DIR/"
    fi
  done

  # 루트 gstack 링크는 OFF 상태에서 아예 제거
  rm -f "$GSTACK_ON_DIR/gstack"
  rm -f "$GSTACK_OFF_DIR/gstack"

  echo "gstack OFF"
  echo "Claude Code를 완전히 재시작한 뒤 /skills 로 확인하세요."
}

gstack-status() {
  echo "== ON_DIR =="
  if [[ -L "$GSTACK_ON_DIR/gstack" || -e "$GSTACK_ON_DIR/gstack" ]]; then
    echo "ON  - gstack"
  fi
  for name in "${GSTACK_ITEMS[@]}"; do
    [[ -e "$GSTACK_ON_DIR/$name" || -L "$GSTACK_ON_DIR/$name" ]] && echo "ON  - $name"
  done

  echo
  echo "== OFF_DIR =="
  if [[ -L "$GSTACK_OFF_DIR/gstack" || -e "$GSTACK_OFF_DIR/gstack" ]]; then
    echo "OFF - gstack"
  fi
  for name in "${GSTACK_ITEMS[@]}"; do
    [[ -e "$GSTACK_OFF_DIR/$name" || -L "$GSTACK_OFF_DIR/$name" ]] && echo "OFF - $name"
  done
}

# -----------------------------
# Local server check / manage
# -----------------------------

# 전체 LISTEN 서버 보기
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'

# 자주 쓰는 포트 확인
alias port3000='lsof -nP -iTCP:3000 -sTCP:LISTEN'
alias port5000='lsof -nP -iTCP:5000 -sTCP:LISTEN'
alias port8000='lsof -nP -iTCP:8000 -sTCP:LISTEN'
alias port8080='lsof -nP -iTCP:8080 -sTCP:LISTEN'

# 프로세스 찾기
alias pyp='pgrep -af python'
alias uvp='pgrep -af uvicorn'
alias djangop='pgrep -af manage.py'
alias nodep='pgrep -af node'

# 포트 종료
alias kill3000='kill -9 $(lsof -t -i:3000)'
alias kill5000='kill -9 $(lsof -t -i:5000)'
alias kill8000='kill -9 $(lsof -t -i:8000)'
alias kill8080='kill -9 $(lsof -t -i:8080)'

# 응답 확인
alias check3000='curl -I http://localhost:3000'
alias check5000='curl -I http://localhost:5000'
alias check8000='curl -I http://localhost:8000'
alias check8080='curl -I http://localhost:8080'

# 포트 확인 + 응답 확인
alias status3000="echo '--- PORT 3000 ---' && lsof -nP -iTCP:3000 -sTCP:LISTEN && echo && curl -I http://localhost:3000"
alias status8000="echo '--- PORT 8000 ---' && lsof -nP -iTCP:8000 -sTCP:LISTEN && echo && curl -I http://localhost:8000"



