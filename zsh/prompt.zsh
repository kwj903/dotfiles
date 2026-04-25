# Purpose: 프롬프트 테마 초기화를 담당한다.
# completion과 입력 보조 플러그인은 completion.zsh에서 로드 순서를 관리한다.
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
