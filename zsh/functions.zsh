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

zne() { nvim "$(zoxide query --interactive)"; }

zcode() { code "$(zoxide query --interactive)"; }

wrun() {
  watchexec --restart -- "$@"
}

bench() {
  hyperfine --warmup 1 "$@"
}
