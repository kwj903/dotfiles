# manual plugin loading outside oh-my-zsh
# zsh-autosuggestions
if command -v brew >/dev/null 2>&1; then
  AUTOSUGGEST_PATH="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$AUTOSUGGEST_PATH" ]] && source "$AUTOSUGGEST_PATH"
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan,bold'
