# Dotfiles

내 개발 환경을 **재현 가능하게 관리하기 위한 dotfiles 저장소**입니다.

이 저장소는 이제 **macOS 전용**이 아니라, 아래 3가지 환경을 함께 다루는 것을 목표로 합니다.

- **macOS + zsh**
- **Windows WSL + zsh**
- **Windows PowerShell**

핵심 철학은 같습니다.

- 새 컴퓨터에서도 빠르게 같은 작업 환경을 복원한다.
- 쉘 설정을 기능별 파일로 분리해서 관리한다.
- 장비 전용 설정과 민감 정보를 공용 설정과 분리한다.
- 설치 과정을 자동화해서 환경을 코드로 재현한다.
- macOS / WSL / Windows를 **공통 개념 + OS별 구현**으로 나눠 관리한다.

---

## 1. 지원 환경

### macOS

- 기기 예시: Intel MacBook Pro 2019
- Shell: zsh
- 패키지 관리자: Homebrew
- 프롬프트: Powerlevel10k
- 설정 방식: dotfiles + symlink

### Windows WSL

- Windows 10/11 + WSL2
- Ubuntu 같은 Linux 배포판 기준
- Shell: zsh
- 패키지 관리자: apt
- 목적: macOS와 최대한 비슷한 터미널 경험 재현

### Windows PowerShell

- Windows Terminal + PowerShell
- 목적: Windows 네이티브 환경에서도 비슷한 alias / function / workflow 유지

---

## 2. 저장소 목적

이 저장소의 목적은 다음과 같습니다.

1. 새 컴퓨터에서도 빠르게 같은 개발 환경을 복원한다.
2. 쉘 설정을 기능별 파일로 분리해서 관리한다.
3. 장비 전용 설정과 민감 정보를 공용 설정과 분리한다.
4. 설치 과정을 자동화해서 환경을 코드로 재현한다.
5. macOS / WSL / Windows PowerShell을 한 저장소에서 관리한다.

---

## 3. 핵심 개념

- 실제 zsh 설정 파일은 `~/.dotfiles/zsh/zshrc`
- 홈 디렉토리의 `~/.zshrc`는 심볼릭 링크
- macOS 설치는 `scripts/install.sh`
- macOS 초기 세팅은 `scripts/bootstrap.sh`
- WSL 설치는 `scripts/install-wsl.sh`
- Windows PowerShell 설치는 `powershell/install-windows.ps1`
- 점검 스크립트는 환경별로 분리될 수 있음
- 장비 전용 설정은 `local.*`
- 민감 정보는 `secrets.*`

---

## 4. 빠른 시작

### A. macOS

#### Homebrew / Git이 이미 준비된 경우

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
exec zsh
```

#### 완전히 새 macOS 환경인 경우

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/bootstrap.sh
exec zsh
```

설치 후 추가:

```bash
touch ~/.dotfiles/zsh/local.zsh
touch ~/.dotfiles/zsh/secrets.zsh
```

### B. Windows WSL

#### 1) WSL 설치

관리자 PowerShell에서:

```powershell
wsl --install
```

재부팅 후 Ubuntu 같은 배포판을 처음 설정합니다.

#### 2) dotfiles 설치

WSL 터미널 안에서:

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install-wsl.sh
exec zsh
```

설치 후 추가:

```bash
touch ~/.dotfiles/zsh/local.zsh
touch ~/.dotfiles/zsh/secrets.zsh
```

### C. Windows PowerShell

PowerShell에서:

```powershell
git clone https://github.com/kwj903/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
.\powershell\install-windows.ps1
```

필요하면 실행 정책 설정:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

PowerShell을 다시 열면 프로필이 적용됩니다.

---

## 5. 저장소 구조

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
│   ├── install-wsl.sh
│   └── link.sh
├── zsh
│   ├── aliases.zsh
│   ├── exports.zsh
│   ├── functions.zsh
│   ├── history.zsh
│   ├── keybindings.zsh
│   ├── local.zsh
│   ├── plugins.zsh
│   ├── secrets.zsh
│   ├── tools.zsh
│   └── zshrc
└── powershell
    ├── install-windows.ps1
    └── Microsoft.PowerShell_profile.ps1
```

---

## 6. 파일별 역할

### zsh 설정

#### `zsh/zshrc`

- 메인 로더 파일
- Powerlevel10k, oh-my-zsh, 나머지 설정 파일을 순서대로 로드

#### `zsh/exports.zsh`

- 환경변수와 `PATH` 설정
- macOS / Linux(WSL) 분기 포함 가능

#### `zsh/plugins.zsh`

- zsh 플러그인 및 보조 기능 로딩

#### `zsh/history.zsh`

- 히스토리 관련 설정

#### `zsh/aliases.zsh`

- 자주 쓰는 alias 정의

#### `zsh/functions.zsh`

- 사용자 정의 함수 모음
- 예: `rgf`, `rgfv`, `zi`, `zne`, `zcode`

#### `zsh/keybindings.zsh`

- 키 바인딩 설정

#### `zsh/tools.zsh`

- `fzf`, `direnv`, `pyenv`, `nvm`, `zoxide` 등 개발 도구 초기화

#### `zsh/local.zsh`

- 장비 전용 설정
- Git 추적 제외 권장

#### `zsh/secrets.zsh`

- 민감 정보 저장
- Git 추적 제외 권장

### PowerShell 설정

#### `powershell/Microsoft.PowerShell_profile.ps1`

- PowerShell 메인 프로필
- alias, 함수, 도구 초기화가 현재 이 파일 하나에 들어 있음

### 패키지 관리

#### `brew/Brewfile`

- macOS/Homebrew 기준 설치 목록
- Windows는 별도 스크립트, WSL은 `apt` 기반 설치 스크립트로 관리

### 스크립트

#### `scripts/bootstrap.sh`

- 완전히 새 macOS 환경용 초기 진입 스크립트

#### `scripts/install.sh`

- macOS 일반 설치 / 재설치 스크립트

#### `scripts/install-wsl.sh`

- WSL 설치 스크립트

#### `powershell/install-windows.ps1`

- PowerShell 프로필 연결 스크립트

#### `scripts/link.sh`

- 심볼릭 링크 생성 스크립트

#### `scripts/check.sh`

- 설치 상태 점검 스크립트

---

## 7. 설치 후 해야 할 설정

### `zsh/local.zsh`

이 컴퓨터에서만 필요한 설정을 넣습니다.

예시:

```zsh
# iTerm2 shell integration
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh" || true

# machine-specific alias
alias myphon='ssh -p 8022 user@host'
```

### `zsh/secrets.zsh`

민감 정보는 여기에 넣고 Git에는 올리지 않습니다.

예시:

```zsh
export OPENAI_API_KEY="..."
export ANTHROPIC_API_KEY="..."
```

### PowerShell 전용 로컬 설정

필요하면 `powershell/local.ps1` 같은 파일을 따로 두고 프로필에서 불러오도록 구성할 수 있습니다.

---

## 8. 운영 원칙

- 민감 정보는 절대 Git에 올리지 않는다.
- 장비 전용 설정은 `local.*` 계열로 분리한다.
- macOS / WSL / Windows 공통 개념은 유지하되, 구현은 OS별로 나눈다.
- zsh 문법을 PowerShell에 그대로 복붙하지 않는다.
- README는 실제 구조와 항상 맞춰 둔다.

---

## 9. 추천 사용 방식

### macOS

- 주력 개발 환경
- Homebrew + zsh + Powerlevel10k

### Windows WSL

- macOS와 가장 비슷한 터미널 환경
- zsh 설정 재사용
- Linux 기반 개발 작업

### Windows PowerShell

- Windows 네이티브 작업용
- 시스템 관리, `winget`, Windows 전용 도구 실행
- zsh와 비슷한 alias / function 감각 유지
