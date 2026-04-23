# Purpose: 재사용 가능한 shell 함수 모듈 로더
# 실제 구현은 ~/.dotfiles/zsh/modules/*.zsh 에 둔다.

typeset -g ZSH_DOTFILES_DIR="${HOME}/.dotfiles/zsh"
typeset -g ZSH_MODULES_DIR="${ZSH_DOTFILES_DIR}/modules"

typeset -ga ZSH_FUNCTION_MODULES=(
  search_editor
  navigation
  command_wrappers
  claude_helpers
  ports
  alias_manager
  llama_helpers
  vulkan_helpers
)

for module in "${ZSH_FUNCTION_MODULES[@]}"; do
  local_module="${ZSH_MODULES_DIR}/${module}.zsh"
  if [[ -f "$local_module" ]]; then
    source "$local_module"
  else
    echo "경고: 모듈 파일이 없습니다: $local_module" >&2
  fi
done

unset module local_module