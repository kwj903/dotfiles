# Purpose: 짧은 alias만 모아 둔 파일이다.
# 로직이 있는 함수는 functions.zsh에, 장비/경로 의존 alias는 local.zsh에 둔다.

# File listing aliases
alias ls="eza"
alias ll="eza -la"
alias tree="eza --tree"

# Content viewing and search aliases
alias cat="bat --paging=never"
alias grep="rg"

# Workflow aliases
alias g="lazygit"
alias j="just"
alias w="watchexec"
alias hf="hyperfine"

# Session aliases
alias ta='tmux new -As work'

# Local server inspection aliases
# 고정 포트를 빠르게 확인하거나 종료할 때 쓴다.
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'

# Fixed port lookup aliases
alias port3000='lsof -nP -iTCP:3000 -sTCP:LISTEN'
alias port5000='lsof -nP -iTCP:5000 -sTCP:LISTEN'
alias port8000='lsof -nP -iTCP:8000 -sTCP:LISTEN'
alias port8080='lsof -nP -iTCP:8080 -sTCP:LISTEN'

# Process lookup aliases
alias pyp='pgrep -af python'
alias uvp='pgrep -af uvicorn'
alias djangop='pgrep -af manage.py'
alias nodep='pgrep -af node'

# Fixed port kill aliases
alias kill3000='kill -9 $(lsof -t -i:3000)'
alias kill5000='kill -9 $(lsof -t -i:5000)'
alias kill8000='kill -9 $(lsof -t -i:8000)'
alias kill8080='kill -9 $(lsof -t -i:8080)'

# Fixed port health check aliases
alias check3000='curl -I http://localhost:3000'
alias check5000='curl -I http://localhost:5000'
alias check8000='curl -I http://localhost:8000'
alias check8080='curl -I http://localhost:8080'

# Fixed port combined status aliases
alias status3000="echo '--- PORT 3000 ---' && lsof -nP -iTCP:3000 -sTCP:LISTEN && echo && curl -I http://localhost:3000"
alias status8000="echo '--- PORT 8000 ---' && lsof -nP -iTCP:8000 -sTCP:LISTEN && echo && curl -I http://localhost:8000"
