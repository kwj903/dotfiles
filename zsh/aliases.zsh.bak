# Purpose: 짧은 alias만 모아 둔 파일이다.
# 로직이 있는 함수는 functions.zsh에,
# 장비/경로 의존 alias는 local.zsh에 둔다.

# ===== Git =====

# 터미널에서 lazygit을 짧게 실행
alias g="lazygit"

# git 상태를 짧게 확인
alias gs='git status -sb'

# 전체 파일 스테이징
alias ga='git add .'

# ===== Python =====

# 현재 실행 중인 Python 관련 프로세스를 확인
alias pyp='pgrep -af python'

# 현재 실행 중인 uvicorn 프로세스를 확인
alias uvp='pgrep -af uvicorn'

# 현재 실행 중인 Django manage.py 프로세스를 확인
alias djangop='pgrep -af manage.py'

# ===== Docker =====

# 현재는 Docker 관련 alias 없음

# ===== Tmux =====

# work 세션이 있으면 붙고, 없으면 새로 생성
alias ta='tmux new -As work'

# iTerm2용 tmux -CC 방식으로 work 세션에 붙거나 생성
alias tcc='tmux -CC new -A -s work'

# ===== Files =====

# 기본 ls를 eza로 대체
alias ls="eza"

# 숨김 파일 포함 상세 목록 보기
alias ll="eza -la"

# 트리 형태로 폴더 구조 보기
alias tree="eza --tree"

# cat 대신 bat으로 파일 내용을 보기 좋게 출력
alias cat="bat --paging=never"

# ===== macOS =====

# 현재는 macOS 전용 alias 없음

# ===== Project =====

# Justfile 명령을 짧게 실행
alias j="just"

# 파일 변경을 감지해 명령을 다시 실행
alias w="watchexec"

# 명령 실행 시간을 간단히 벤치마크
alias hpf="hyperfine"

# ===== Network =====

# 현재 LISTEN 중인 로컬 서버 포트를 한 번에 확인
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'

# 3000 포트를 사용 중인 프로세스 확인
alias port3000='lsof -nP -iTCP:3000 -sTCP:LISTEN'

# 5000 포트를 사용 중인 프로세스 확인
alias port5000='lsof -nP -iTCP:5000 -sTCP:LISTEN'

# 8000 포트를 사용 중인 프로세스 확인
alias port8000='lsof -nP -iTCP:8000 -sTCP:LISTEN'

# 8080 포트를 사용 중인 프로세스 확인
alias port8080='lsof -nP -iTCP:8080 -sTCP:LISTEN'

# 현재 실행 중인 Node.js 프로세스를 확인
alias nodep='pgrep -af node'

# 3000 포트를 점유한 프로세스를 강제 종료
alias kill3000='kill -9 $(lsof -t -i:3000)'

# 5000 포트를 점유한 프로세스를 강제 종료
alias kill5000='kill -9 $(lsof -t -i:5000)'

# 8000 포트를 점유한 프로세스를 강제 종료
alias kill8000='kill -9 $(lsof -t -i:8000)'

# 8080 포트를 점유한 프로세스를 강제 종료
alias kill8080='kill -9 $(lsof -t -i:8080)'

# 3000 포트 로컬 서버의 응답 헤더를 확인
alias check3000='curl -I http://localhost:3000'

# 5000 포트 로컬 서버의 응답 헤더를 확인
alias check5000='curl -I http://localhost:5000'

# 8000 포트 로컬 서버의 응답 헤더를 확인
alias check8000='curl -I http://localhost:8000'

# 8080 포트 로컬 서버의 응답 헤더를 확인
alias check8080='curl -I http://localhost:8080'

# 3000 포트의 점유 상태와 HTTP 응답을 한 번에 확인
alias status3000="echo '--- PORT 3000 ---' && lsof -nP -iTCP:3000 -sTCP:LISTEN && echo && curl -I http://localhost:3000"

# 8000 포트의 점유 상태와 HTTP 응답을 한 번에 확인
alias status8000="echo '--- PORT 8000 ---' && lsof -nP -iTCP:8000 -sTCP:LISTEN && echo && curl -I http://localhost:8000"

# ===== Tools =====

# qwen3.6 35b-a3b모델의 가장 빠른버전을llama.cpp서버로 띄움
alias llgsqwen3.6='llgs Qwen3.6-35B-A3B-IQ4_XS.gguf 8080 --n-gpu-layers 0 -fa off -t 8'

