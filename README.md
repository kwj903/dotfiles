# Dotfiles

내 macOS 개발 환경을 재현 가능하게 관리하기 위한 dotfiles 저장소.

이 저장소는 다음을 관리한다.

- zsh 설정
- Homebrew 패키지 / 앱 / VS Code 확장
- 심볼릭 링크 기반 `.zshrc` 연결
- 설치 / 점검 / 부트스트랩 스크립트
- 장비 전용 설정(`local.zsh`)과 민감 정보(`secrets.zsh`) 분리

---

## 1. 현재 기준 환경

- **기기**: Intel MacBook Pro 2019
- **OS**: macOS
- **Shell**: zsh
- **패키지 관리자**: Homebrew
- **프롬프트**: Powerlevel10k
- **설정 방식**: dotfiles + symlink

> 참고
> 이 저장소는 현재 Intel Mac 기준으로 구성되어 있다.
> Apple Silicon Mac으로 옮기면 `/usr/local` 경로 일부를 `/opt/homebrew` 기준으로 조정해야 할 수 있다.

---

## 2. 이 저장소의 목적

이 저장소의 목적은 다음과 같다.

1. 새 컴퓨터에서도 빠르게 같은 개발 환경을 복원한다.
2. 쉘 설정을 기능별 파일로 분리해서 관리한다.
3. 장비 전용 설정과 민감 정보를 공용 설정과 분리한다.
4. 설치 과정을 자동화해서 환경을 코드로 재현한다.
5. 설치 방법, 사용 방법, 운영 규칙, 문제 해결 방법을 README 하나에서 찾을 수 있게 한다.

핵심 개념:

- 실제 zsh 설정 파일은 `~/.dotfiles/zsh/zshrc`
- 홈 디렉토리의 `~/.zshrc`는 심볼릭 링크
- 일반 설치는 `scripts/install.sh`
- 초기 세팅은 `scripts/bootstrap.sh`
- 점검은 `scripts/check.sh`

---

## 3. 빠른 시작

### 방법 A. Homebrew / Git 이 이미 준비된 경우

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
exec zsh
```

### 방법 B. 완전히 새 macOS 환경인 경우

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/bootstrap.sh
exec zsh
```

설치 후 추가로 해야 하는 일:

```bash
touch ~/.dotfiles/zsh/local.zsh
touch ~/.dotfiles/zsh/secrets.zsh
```

- `local.zsh`: 장비 전용 설정
- `secrets.zsh`: API 키 / 토큰 / 비공개 환경변수

설치가 끝난 뒤 점검:

```bash
~/.dotfiles/scripts/check.sh
```

---

## 4. 저장소 구조

```text
.dotfiles
├── .gitignore
├── README.md
├── brew
│   └── Brewfile
├── scripts
│   ├── bootstrap.sh
│   ├── check.sh
│   ├── install.sh
│   └── link.sh
└── zsh
    ├── aliases.zsh
    ├── exports.zsh
    ├── functions.zsh
    ├── history.zsh
    ├── keybindings.zsh
    ├── local.zsh
    ├── plugins.zsh
    ├── secrets.zsh
    ├── tools.zsh
    └── zshrc
```

---

## 5. 파일별 역할

### zsh 설정

- `zsh/zshrc`
  - 메인 로더 파일
  - Powerlevel10k, oh-my-zsh, 나머지 설정 파일을 순서대로 로드
- `zsh/exports.zsh`
  - 환경변수와 `PATH` 설정
  - 예: `PYENV_ROOT`, `NVM_DIR`, `EDITOR`, `PAGER`
- `zsh/plugins.zsh`
  - zsh 플러그인 및 보조 기능 로딩
- `zsh/history.zsh`
  - 히스토리 관련 설정
- `zsh/aliases.zsh`
  - 자주 쓰는 alias 정의
- `zsh/functions.zsh`
  - 사용자 정의 함수 모음
  - 예: `rgf`, `rgfv`, `zi`, `zne`, `zcode`
- `zsh/keybindings.zsh`
  - 키 바인딩 설정
- `zsh/tools.zsh`
  - `fzf`, `direnv`, `pyenv`, `nvm`, `zoxide` 등 개발 도구 초기화
- `zsh/local.zsh`
  - 장비 전용 설정
  - Git 추적 제외
- `zsh/secrets.zsh`
  - 민감 정보 저장
  - Git 추적 제외

### Homebrew

- `brew/Brewfile`
  - CLI 도구, 앱(cask), VS Code 확장 설치 목록
  - `brew bundle`로 설치 재현 가능

### 스크립트

- `scripts/bootstrap.sh`
  - 완전히 새 컴퓨터용 초기 진입 스크립트
- `scripts/install.sh`
  - 일반 설치 / 재설치 스크립트
- `scripts/link.sh`
  - 심볼릭 링크 생성 스크립트
  - 현재 연결: `~/.zshrc -> ~/.dotfiles/zsh/zshrc`
- `scripts/check.sh`
  - 설치 상태 점검 스크립트

---

## 6. 설치 후 해야 할 설정

### `zsh/local.zsh`

이 컴퓨터에서만 필요한 설정을 넣는다.

예시:

```zsh
# iTerm2 shell integration
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh" || true

# OpenClaw completion
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# machine-specific alias
alias myphon='ssh -p 8022 user@host'
```

### `zsh/secrets.zsh`

민감한 값을 넣는다.

예시:

```zsh
export OPENAI_API_KEY="..."
export SOME_PRIVATE_TOKEN="..."
```

원칙:

- 공용 설정은 Git에 올린다.
- 장비 전용 설정은 `local.zsh`에 둔다.
- 민감 정보는 `secrets.zsh`에 둔다.
- `aliases.zsh`, `exports.zsh`, `zshrc`에 개인 장비 정보나 비밀값을 직접 넣지 않는다.

---

## 7. 평소 사용 방법

### 설정 다시 적용

```bash
source ~/.zshrc
```

또는

```bash
exec zsh
```

- `source ~/.zshrc`: 현재 셸에 다시 로드
- `exec zsh`: 셸 자체를 다시 시작

### 설치 상태 점검

```bash
~/.dotfiles/scripts/check.sh
```

### 설치 다시 실행

```bash
~/.dotfiles/scripts/install.sh
```

### 변경사항 확인

```bash
cd ~/.dotfiles
git status
```

### 커밋 / 푸시

```bash
cd ~/.dotfiles
git add .
git commit -m "Update dotfiles"
git push
```

---

## 8. 주요 alias / function

### alias

```zsh
alias ls="eza"
alias ll="eza -la"
alias tree="eza --tree"
alias cat="bat --paging=never"
alias grep="rg"
alias g="lazygit"
alias tm='task-master'
alias taskmaster='task-master'
alias ta='tmux new -As work'
```

의미:

- `ls`, `ll`, `tree`: 파일 탐색
- `cat`: `bat`으로 컬러 출력
- `grep`: `ripgrep` 사용
- `g`: `lazygit` 실행
- `tm`, `taskmaster`: `task-master` 실행
- `ta`: `tmux`의 `work` 세션에 붙거나 새로 생성

### function

- `rgf`
  - `ripgrep + fzf + bat preview + vim`
- `rgfv`
  - `ripgrep + fzf + bat preview + VS Code`
- `zi`
  - `zoxide`로 디렉토리 이동
- `zne`
  - `zoxide`로 선택 후 `nvim` 열기
- `zcode`
  - `zoxide`로 선택 후 VS Code 열기

사용 예:

```bash
rgf TODO
rgfv urlpatterns
zi
zne
zcode
g
ta
```

---

## 9. 스크립트 설명

### `scripts/bootstrap.sh`

새 맥북을 처음 세팅할 때 사용한다.

역할:

- Homebrew 확인 / 설치
- Git 확인
- dotfiles clone 확인
- `scripts/install.sh` 실행

### `scripts/install.sh`

일반적인 설치 진입점이다.

역할:

- Homebrew 사용 가능 여부 확인
- `brew/Brewfile` 기반 패키지 설치
- 심볼릭 링크 생성
- health check 실행

### `scripts/link.sh`

심볼릭 링크 생성 전용 스크립트.

현재 연결:

- `~/.zshrc -> ~/.dotfiles/zsh/zshrc`

### `scripts/check.sh`

설치 상태를 점검한다.

점검 예시:

- `git`
- `brew`
- `zsh`
- `fzf`
- `rg`
- `bat`
- `eza`
- `zoxide`
- `tmux`
- `lazygit`
- `gh`
- `.zshrc` symlink 상태

---

## 10. 새 컴퓨터 복원 체크리스트

### 1단계. 저장소 클론

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2단계. 설치 실행

```bash
./scripts/install.sh
```

### 3단계. 쉘 재시작

```bash
exec zsh
```

### 4단계. 개인 파일 준비

```bash
touch ~/.dotfiles/zsh/local.zsh
touch ~/.dotfiles/zsh/secrets.zsh
```

### 5단계. 필요한 내용 입력

- `local.zsh`: 장비 전용 설정
- `secrets.zsh`: API 키 / 토큰

### 6단계. 상태 점검

```bash
~/.dotfiles/scripts/check.sh
```

### 7단계. 필요 시 zsh 재적용

```bash
source ~/.zshrc
```

---

## 11. 점검 및 문제 해결

### 1) `.zshrc` 링크 확인

```bash
ls -l ~/.zshrc
```

정상 예시:

```text
/Users/kwj903/.zshrc -> /Users/kwj903/.dotfiles/zsh/zshrc
```

### 2) 스크립트 문법 검사

```bash
bash -n ~/.dotfiles/scripts/install.sh
bash -n ~/.dotfiles/scripts/bootstrap.sh
bash -n ~/.dotfiles/scripts/link.sh
bash -n ~/.dotfiles/scripts/check.sh
```

출력이 없으면 문법상 정상이다.

### 3) `permission denied`

해결:

```bash
chmod +x ~/.dotfiles/scripts/check.sh
chmod +x ~/.dotfiles/scripts/install.sh
chmod +x ~/.dotfiles/scripts/link.sh
chmod +x ~/.dotfiles/scripts/bootstrap.sh
```

### 4) `.zshrc` 링크가 깨졌거나 없음

```bash
ln -sfn ~/.dotfiles/zsh/zshrc ~/.zshrc
ls -l ~/.zshrc
```

### 5) `source ~/.zshrc` 후 에러 발생

확인할 것:

- 존재하지 않는 파일을 직접 `source`하고 있지 않은지
- `local.zsh`, `secrets.zsh`를 optional 로딩하고 있는지
- `source "~/.dotfiles/..."`처럼 `~`를 따옴표 안에 넣지 않았는지

권장 형태:

```zsh
[[ -f "$file" ]] && source "$file"
```

### 6) `brew bundle` 관련 오류

확인할 것:

- Homebrew 설치 여부
- `brew/Brewfile` 경로
- 최근 Homebrew 변경 사항

### 7) `.DS_Store` 정리

```bash
find ~/.dotfiles -name .DS_Store -delete
```

### 8) `local.zsh` / `secrets.zsh`가 Git에 올라감

```bash
git rm --cached zsh/secrets.zsh zsh/local.zsh
git commit -m "Stop tracking local and secret files"
git push
```

### 9) 줄바꿈 경고 (`LF will be replaced by CRLF`)

줄바꿈 포맷 관련 경고다.
macOS 사용에는 큰 문제가 없는 경우가 많다.

### 10) GitHub push 시 macOS 키체인 비밀번호 창이 뜸

보통 `git-credential-osxkeychain`이 키체인 자격 증명을 읽으려 할 때 뜨는 정상적인 보안 확인 창이다.

---

## 12. Git 추적 제외 규칙

`.gitignore`에는 최소한 아래 항목이 있어야 한다.

```gitignore
zsh/secrets.zsh
zsh/local.zsh
.DS_Store
*.zwc
.vscode/
```

설명:

- `secrets.zsh`: 민감 정보 보호
- `local.zsh`: 장비 전용 설정 보호
- `.DS_Store`: macOS 잡파일
- `*.zwc`: zsh 캐시 파일
- `.vscode/`: 편집기 로컬 설정

주의:

- `.gitignore`에 적어도 이미 추적 중인 파일은 자동으로 제외되지 않는다.
- 이미 추적 중이었다면 `git rm --cached`로 제거해야 한다.

---

## 13. 향후 확장 후보

나중에 이 저장소에 추가하면 좋은 것들:

- `.gitconfig`
- `.tmux.conf`
- Neovim 설정
- `Brewfile` 세분화
- macOS 기본 설정 자동화
- Python / Node 프로젝트용 템플릿 함수
- alias / function 문서 추가

---

## 14. 운영 원칙

이 저장소는 단순한 설정 백업이 아니라 재현 가능한 개발 환경을 코드로 관리하는 개인 인프라를 목표로 한다.

원칙:

- 환경을 기억하지 말고 기록한다.
- 반복 설치는 자동화한다.
- 공용 설정 / 장비 전용 / 민감 정보를 분리한다.
- 새 컴퓨터에서도 짧은 절차로 복원 가능해야 한다.
- 수정 후에는 README도 함께 갱신한다.
- 설치 방법과 사용 방법을 README 하나로 해결할 수 있어야 한다.

---

## 15. README 수정 후 반영

```bash
cd ~/.dotfiles
code README.md
git add README.md
git commit -m "Update README"
git push
```
