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