# Purpose: 재사용 가능한 범용 shell 함수를 모아 둔 파일이다.
# 장비 경로나 개인 워크플로우에 묶인 함수는 local.zsh로 분리한다.

# Search and editor helpers
rgf() {
  rg --line-number --no-heading "$@" |
    fzf --delimiter ':' \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window=right:60% |
    awk -F: '{print $1 ":" $2}' |
    xargs -I {} sh -c 'file=$(echo {} | cut -d: -f1); line=$(echo {} | cut -d: -f2); vim +$line $file'
}

rgfv() {
  rg --line-number --no-heading "$@" |
    fzf --delimiter ':' \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window=right:60% |
    awk -F: '{print $1 ":" $2}' |
    xargs -I {} sh -c '
      file=$(echo {} | cut -d: -f1)
      line=$(echo {} | cut -d: -f2)
      code -g "$file:$line"
    '
}

# Directory navigation helpers
zi() { cd "$(zoxide query --interactive)"; }

zne() { vim "$(zoxide query --interactive)"; }

zcode() { code "$(zoxide query --interactive)"; }

# Command wrapper helpers
wrun() {
  watchexec --restart -- "$@"
}

bench() {
  hyperfine --warmup 1 "$@"
}

# Claude / OpenRouter helper
# 원하는 OpenRouter 모델을 임시로 지정해 Claude Code를 실행한다.
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

# Local server helpers
# 포트 기반 확인/종료/헬스체크를 범용 함수로 묶는다.
port() {
  if [[ -z "$1" ]]; then
    echo "사용법: port <port>"
    return 1
  fi

  lsof -nP -iTCP:"$1" -sTCP:LISTEN
}

killport() {
  if [[ -z "$1" ]]; then
    echo "사용법: killport <port>"
    return 1
  fi

  local -a pids
  pids=("${(@f)$(lsof -t -iTCP:"$1" -sTCP:LISTEN 2>/dev/null)}")

  if (( ${#pids[@]} == 0 )); then
    echo "포트 $1 에서 LISTEN 중인 프로세스가 없습니다."
    return 1
  fi

  kill -9 "${pids[@]}"
}

checkport() {
  if [[ -z "$1" ]]; then
    echo "사용법: checkport <port>"
    return 1
  fi

  curl -I "http://localhost:$1"
}

statusport() {
  if [[ -z "$1" ]]; then
    echo "사용법: statusport <port>"
    return 1
  fi

  echo "--- PORT $1 ---"
  lsof -nP -iTCP:"$1" -sTCP:LISTEN
  echo
  curl -I "http://localhost:$1"
}
