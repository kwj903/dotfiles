# dotfiles helper completions

(( $+functions[compdef] )) || return 0

_dotfiles_comp_alias_sections() {
  if (( $+functions[_alias_allowed_sections] )); then
    _alias_allowed_sections
  else
    print -rl -- Git Python Docker Tmux Files macOS Project Network Tools
  fi
}

_dotfiles_comp_alias_names() {
  local alias_file
  alias_file="${HOME}/.dotfiles/zsh/aliases.zsh"
  [[ -f "$alias_file" ]] || return 0

  awk '
    /^[[:space:]]*alias[[:space:]]+/ {
      sub(/^[[:space:]]*alias[[:space:]]+/, "")
      sub(/=.*/, "")
      print
    }
  ' "$alias_file" | sort -u
}

_dotfiles_comp_ports() {
  local -a ports listen_ports
  typeset -U ports

  ports=(3000 5000 8000 8080 8081 8082)

  if command -v lsof >/dev/null 2>&1; then
    listen_ports=("${(@f)$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null \
      | awk 'NR > 1 { split($9, parts, ":"); print parts[length(parts)] }' \
      | sort -u)}")
    ports+=("${listen_ports[@]}")
  fi

  print -rl -- "${ports[@]}"
}

_dotfiles_complete_mkaliass() {
  local -a sections

  if (( CURRENT == 2 )); then
    sections=("${(@f)$(_dotfiles_comp_alias_sections)}")
    _describe -t alias-sections 'alias sections' sections
    return
  fi

  if (( CURRENT == 3 )); then
    _message 'alias name'
    return
  fi

  if (( CURRENT == 4 )); then
    _message 'command'
    return
  fi

  if (( CURRENT == 5 )); then
    _message 'description'
    return
  fi
}

_dotfiles_complete_rmaliass() {
  local -a aliases

  if (( CURRENT == 2 )); then
    aliases=("${(@f)$(_dotfiles_comp_alias_names)}")
    _describe -t aliases 'aliases' aliases
    return
  fi
}

_dotfiles_complete_port_arg() {
  local -a ports

  if (( CURRENT == 2 )); then
    ports=("${(@f)$(_dotfiles_comp_ports)}")
    _describe -t ports 'ports' ports
    return
  fi
}

compdef _dotfiles_complete_mkaliass mkaliass
compdef _dotfiles_complete_rmaliass rmaliass
compdef _dotfiles_complete_port_arg port killport checkport statusport
