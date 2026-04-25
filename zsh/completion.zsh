# Purpose: zsh completion 초기화와 fuzzy completion UI 로드 순서를 관리한다.
# fzf-tab은 fzf와 compinit 뒤, autosuggestions 앞에서 로드되어야 한다.

_dotfiles_compinit_once() {
  if (( $+functions[compdef] )); then
    export DOTFILES_COMPINIT_DONE=1
    return 0
  fi

  autoload -Uz compinit
  compinit -i
  export DOTFILES_COMPINIT_DONE=1
}

_dotfiles_configure_completion_styles() {
  unsetopt MENU_COMPLETE
  setopt AUTO_LIST
  setopt AUTO_MENU
  setopt COMPLETE_IN_WORD
  setopt ALWAYS_TO_END

  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' special-dirs true
  zstyle ':completion:*:descriptions' format '[%d]'
  zstyle ':completion:*' matcher-list \
    'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
    'r:|=*' \
    'l:|=* r:|=*'
  zstyle ':completion:*' list-colors \
    'di=1;36' 'ln=35' 'so=32' 'pi=33' 'ex=31' \
    'bd=34;46' 'cd=34;43' 'su=30;41' 'sg=30;46' \
    'tw=30;42' 'ow=30;43'
}

_dotfiles_load_fzf_shell_integration() {
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}' --preview-window=right:60%"

  if command -v fzf >/dev/null 2>&1 && fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
    return
  fi

  if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
    return
  fi

  if command -v brew >/dev/null 2>&1; then
    local fzf_prefix
    fzf_prefix="$(brew --prefix fzf 2>/dev/null || true)"
    [[ -f "$fzf_prefix/shell/key-bindings.zsh" ]] && source "$fzf_prefix/shell/key-bindings.zsh"
    [[ -f "$fzf_prefix/shell/completion.zsh" ]] && source "$fzf_prefix/shell/completion.zsh"
  fi
}

_dotfiles_fzf_tab_file() {
  local fzf_tab_prefix

  if command -v brew >/dev/null 2>&1; then
    fzf_tab_prefix="$(brew --prefix fzf-tab 2>/dev/null || true)"
    if [[ -r "$fzf_tab_prefix/share/fzf-tab/fzf-tab.zsh" ]]; then
      print -r -- "$fzf_tab_prefix/share/fzf-tab/fzf-tab.zsh"
      return 0
    fi
  fi

  if [[ -r "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh" ]]; then
    print -r -- "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh"
    return 0
  fi

  return 1
}

_dotfiles_bind_native_menu_cancel() {
  zmodload -i zsh/complist
  bindkey -M menuselect '^[' send-break 2>/dev/null
  bindkey -M menuselect '^G' send-break 2>/dev/null
}

_dotfiles_load_completion_ui() {
  local fzf_tab_file

  _dotfiles_bind_native_menu_cancel

  if fzf_tab_file="$(_dotfiles_fzf_tab_file)"; then
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:*' fzf-flags --height=40% --reverse --border --bind=tab:accept
    zstyle ':fzf-tab:*' switch-group '<' '>'
    zstyle ':fzf-tab:complete:cd:*' fzf-preview \
      'command eza -1 --color=always "$realpath" 2>/dev/null || command ls -1 "$realpath" 2>/dev/null'

    source "$fzf_tab_file"
    export DOTFILES_FZF_TAB_LOADED=1
  else
    zstyle ':completion:*' menu select=1
    zstyle ':completion:*' list yes
    export DOTFILES_FZF_TAB_LOADED=0
  fi
}

_dotfiles_load_custom_completions() {
  local completion_file

  for completion_file in \
    "$DOTFILES_DIR/zsh/modules/dotfiles_completions.zsh" \
    "$DOTFILES_DIR/zsh/modules/llama_completions.zsh"
  do
    [[ -f "$completion_file" ]] && source "$completion_file"
  done
}

_dotfiles_load_zsh_autosuggestions() {
  local autosuggest_path

  if command -v brew >/dev/null 2>&1; then
    autosuggest_path="$(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    if [[ -f "$autosuggest_path" ]]; then
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan,bold'
      source "$autosuggest_path"
    fi
  fi
}

_dotfiles_compinit_once
_dotfiles_configure_completion_styles
_dotfiles_load_fzf_shell_integration
_dotfiles_load_completion_ui
_dotfiles_load_custom_completions
_dotfiles_load_zsh_autosuggestions

unfunction \
  _dotfiles_compinit_once \
  _dotfiles_configure_completion_styles \
  _dotfiles_load_fzf_shell_integration \
  _dotfiles_fzf_tab_file \
  _dotfiles_bind_native_menu_cancel \
  _dotfiles_load_completion_ui \
  _dotfiles_load_custom_completions \
  _dotfiles_load_zsh_autosuggestions
