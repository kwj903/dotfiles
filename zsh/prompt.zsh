# prompt, completion, and prompt-related plugins
export ZSH="$HOME/.oh-my-zsh"
P10K_THEME_FILE="$ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme"

if [[ -r "$P10K_THEME_FILE" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
else
  ZSH_THEME=""
fi

plugins=(git)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit -i

  for theme_file in \
    "$P10K_THEME_FILE" \
    "/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme" \
    "/usr/local/share/powerlevel10k/powerlevel10k.zsh-theme"
  do
    if [[ -r "$theme_file" ]]; then
      source "$theme_file"
      break
    fi
  done
fi

if command -v brew >/dev/null 2>&1; then
  AUTOSUGGEST_PATH="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$AUTOSUGGEST_PATH" ]] && source "$AUTOSUGGEST_PATH"
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan,bold'
