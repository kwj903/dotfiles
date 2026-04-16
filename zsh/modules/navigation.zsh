# Directory navigation helpers

zi() {
  cd "$(zoxide query --interactive)"
}

zne() {
  vim "$(zoxide query --interactive)"
}

zcode() {
  code "$(zoxide query --interactive)"
}