# interactive workflow helpers
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

zi() { cd "$(zoxide query --interactive)"; }

zne() { vim "$(zoxide query --interactive)"; }

zcode() { code "$(zoxide query --interactive)"; }

wrun() {
  watchexec --restart -- "$@"
}

bench() {
  hyperfine --warmup 1 "$@"
}

# -----------------------------
# Local server Functions
# -----------------------------

# 특정 포트 확인
port() {
  lsof -nP -iTCP:"$1" -sTCP:LISTEN
}

# 특정 포트 종료
killport() {
  kill -9 $(lsof -t -i:"$1")
}

# 특정 포트 응답 확인
checkport() {
  curl -I "http://localhost:$1"
}

# 특정 포트 상태 한 번에 보기
statusport() {
  echo "--- PORT $1 ---"
  lsof -nP -iTCP:"$1" -sTCP:LISTEN
  echo
  curl -I "http://localhost:$1"
}
