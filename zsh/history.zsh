# Purpose: shell history 저장 정책과 중복 처리 방식을 정의한다.
# 프롬프트나 alias와 무관한 기록 동작만 이 파일에 둔다.
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
