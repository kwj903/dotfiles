# Purpose: interactive zsh 키 바인딩만 정의한다.
# 편집기/프롬프트 설정과 분리해서, 입력 동작만 여기서 관리한다.
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
