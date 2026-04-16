# Command wrapper helpers

wrun() {
  watchexec --restart -- "$@"
}

bench() {
  hyperfine --warmup 1 "$@"
}