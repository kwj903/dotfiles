# Dotfiles

내 개발 환경을 재현 가능하게 관리하기 위한 dotfiles 저장소입니다.

이 저장소는 다음 3가지 환경을 함께 다룹니다.

- **macOS + zsh**
- **Windows WSL + zsh**
- **Windows PowerShell**

핵심 목표는 같습니다.

- 새 컴퓨터에서도 빠르게 같은 작업 환경을 복원한다.
- 쉘 설정을 기능별 파일로 분리해서 관리한다.
- 장비 전용 설정과 민감 정보를 공용 설정과 분리한다.
- 설치 과정을 자동화해서 환경을 코드로 재현한다.
- macOS / WSL / Windows PowerShell을 한 저장소에서 관리한다.
- 각 환경은 자기 OS에서만 검증하고 적용한다.

---

## 1. 지원 환경

### macOS

- Shell: zsh
- 패키지 관리자: Homebrew
- 프롬프트: Powerlevel10k
- 진입점: `scripts/bootstrap-macos.sh`

### Windows WSL

- Windows 10/11 + WSL2
- Ubuntu 같은 Linux 배포판 기준
- Shell: zsh
- 패키지 관리자: `apt`
- 진입점: `scripts/bootstrap-wsl.sh`

### Windows PowerShell

- Windows Terminal + PowerShell
- 패키지 관리자: `winget`
- 진입점: `scripts/bootstrap-windows.ps1`

---

## 2. 핵심 개념

- 실제 zsh 설정 파일은 `~/.dotfiles/zsh/zshrc`
- 홈 디렉토리의 `~/.zshrc`는 심볼릭 링크
- `bootstrap` = 처음 한 번 실행하는 진입점
- `install` = 반복 적용 / 재설치
- `check` = 상태 점검
- 장비 전용 설정은 `local.*`
- 민감 정보는 `secrets.*`

macOS와 WSL은 모두 `~/.zshrc -> ~/.dotfiles/zsh/zshrc` 링크를 사용합니다.
Windows PowerShell은 `$PROFILE`을 `powershell/Microsoft.PowerShell_profile.ps1`로 연결합니다.

즉, macOS에서 Windows 스크립트를 직접 실행할 필요는 없고, 반대로 Windows에서 macOS 스크립트를 검증할 필요도 없습니다.

---

## 3. 빠른 시작

### A. macOS

#### 완전히 새 macOS 환경

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/bootstrap-macos.sh
exec zsh
```

#### 이미 Homebrew / Git이 준비된 경우

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install-macos.sh
exec zsh
```

#### 점검

```bash
~/.dotfiles/scripts/check-macos.sh
```

### B. Windows WSL

#### WSL 설치

관리자 PowerShell에서:

```powershell
wsl --install
```

재부팅 후 Ubuntu 등을 초기 설정합니다.

#### 완전히 새 WSL 환경

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/bootstrap-wsl.sh
exec zsh
```

#### 이미 기본 도구가 준비된 경우

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install-wsl.sh
exec zsh
```

#### 점검

```bash
~/.dotfiles/scripts/check-wsl.sh
```

### C. Windows PowerShell

#### 완전히 새 Windows PowerShell 환경

```powershell
git clone https://github.com/kwj903/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
.\scripts\bootstrap-windows.ps1
```

#### 이미 기본 도구가 준비된 경우

```powershell
git clone https://github.com/kwj903/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
.\scripts\install-windows.ps1
```

#### 점검

```powershell
.\scripts\check-windows.ps1
```

필요하면 실행 정책을 설정합니다.

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## 4. 저장소 구조

```text
.dotfiles
├── README.md
├── brew
│   └── Brewfile
├── powershell
│   ├── aliases.ps1
│   ├── functions.ps1
│   ├── install-windows.ps1
│   ├── Microsoft.PowerShell_profile.ps1
│   └── tools.ps1
├── scripts
│   ├── bootstrap-macos.sh
│   ├── bootstrap-windows.ps1
│   ├── bootstrap-wsl.sh
│   ├── check-macos.sh
│   ├── check-windows.ps1
│   ├── check-wsl.sh
│   ├── install-macos.sh
│   ├── install-windows.ps1
│   ├── install-wsl.sh
│   ├── link-macos.sh
│   └── link-wsl.sh
└── zsh
    ├── aliases.zsh
    ├── exports.zsh
    ├── functions.zsh
    ├── history.zsh
    ├── keybindings.zsh
    ├── plugins.zsh
    ├── tools.zsh
    └── zshrc
```

`zsh/local.zsh`, `zsh/secrets.zsh`는 설치 스크립트가 로컬에서 생성하는 파일이며 저장소에는 기본 포함되지 않습니다.

---

## 5. 파일별 역할

### zsh 설정

- `zsh/zshrc`
  - 메인 로더 파일
  - `exports.zsh`, `plugins.zsh`, `history.zsh`, `aliases.zsh`, `functions.zsh`, `keybindings.zsh`, `tools.zsh`를 순서대로 로드
  - `zsh/local.zsh`, `zsh/secrets.zsh`가 있으면 함께 로드
- `zsh/exports.zsh`
  - 환경변수와 `PATH` 설정
- `zsh/plugins.zsh`
  - zsh 플러그인 관련 설정
- `zsh/history.zsh`
  - 히스토리 설정
- `zsh/aliases.zsh`
  - alias 정의
- `zsh/functions.zsh`
  - 사용자 함수 정의
- `zsh/keybindings.zsh`
  - 키 바인딩
- `zsh/tools.zsh`
  - `fzf`, `git-delta`, `atuin`, `direnv`, `zoxide` 초기화

### PowerShell 설정

- `powershell/Microsoft.PowerShell_profile.ps1`
  - 현재 PowerShell 메인 프로필
  - `aliases.ps1`, `functions.ps1`, `tools.ps1`를 로드
- `powershell/install-windows.ps1`
  - `scripts/install-windows.ps1` 호출용 래퍼
- `powershell/aliases.ps1`
  - PowerShell alias와 간단한 함수
- `powershell/functions.ps1`
  - PowerShell 함수 정의
- `powershell/tools.ps1`
  - `zoxide`, `fzf` 관련 초기화

### 패키지 관리

- `brew/Brewfile`
  - macOS용 Homebrew 패키지, cask 앱, VS Code 확장 목록
  - 예: `git`, `ripgrep`, `bat`, `eza`, `fzf`, `gh`, `lazygit`, `tmux`, `zoxide`, `just`, `git-delta`, `watchexec`, `hyperfine`, `atuin`

### macOS 스크립트

- `scripts/bootstrap-macos.sh`
  - Xcode Command Line Tools, Homebrew, Git을 확인한 뒤 설치 진입
- `scripts/install-macos.sh`
  - `brew bundle`, zsh 링크 생성, 로컬 파일 생성, 상태 점검 실행
- `scripts/check-macos.sh`
  - macOS용 명령어와 링크 상태 점검
- `scripts/link-macos.sh`
  - `~/.zshrc -> ~/.dotfiles/zsh/zshrc` 링크 생성

### WSL 스크립트

- `scripts/bootstrap-wsl.sh`
  - `git`, `curl`을 준비한 뒤 설치 진입
- `scripts/install-wsl.sh`
  - `apt`로 기본 도구 설치
  - `batcat -> bat`, `exa -> eza` fallback 처리
  - `zoxide` 설치
  - zsh 링크 생성, 로컬 파일 생성, 기본 shell 변경, 상태 점검 실행
- `scripts/check-wsl.sh`
  - WSL용 명령어와 링크 상태 점검
- `scripts/link-wsl.sh`
  - `~/.zshrc -> ~/.dotfiles/zsh/zshrc` 링크 생성

### Windows PowerShell 스크립트

- `scripts/bootstrap-windows.ps1`
  - `winget`으로 `git`을 보장한 뒤 저장소 clone 또는 최신화 후 설치 진입
- `scripts/install-windows.ps1`
  - `winget`으로 `git`, `rg`, `fzf`, `bat`, `eza`, `zoxide`, `lazygit` 설치
  - `$PROFILE`을 `powershell/Microsoft.PowerShell_profile.ps1`에 연결하고 상태 점검 실행
- `scripts/check-windows.ps1`
  - PowerShell용 명령어와 프로필 상태 점검

---

## 6. 설치 후 해야 할 설정

### `zsh/local.zsh`

장비 전용 설정을 넣습니다.

```zsh
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh" || true
alias myphon='ssh -p 8022 user@host'
```

### `zsh/secrets.zsh`

민감 정보는 여기에 넣고 Git에는 올리지 않습니다.

```zsh
export OPENAI_API_KEY="..."
export ANTHROPIC_API_KEY="..."
```

macOS와 WSL 설치 스크립트는 두 파일을 자동으로 `touch`합니다.

### 새로 추가한 CLI 빠른 사용

- `j`
  - `just` 실행 (예: `j test`)
- `w` / `wrun`
  - `watchexec` 실행 (예: `wrun "npm test"`)
- `hf` / `bench`
  - `hyperfine` 실행 (예: `bench "pytest -q" "pytest -q -n auto"`)
- `atuin`
  - 셸 히스토리 검색 강화 (`Ctrl-R`)
- `git-delta`
  - zsh 세션에서 `git diff`, `git show` 출력이 `delta` 페이저로 표시됨

---

## 7. 운영 원칙

- 민감 정보는 절대 Git에 올리지 않는다.
- 장비 전용 설정은 `local.*` 계열로 분리한다.
- 공통 개념은 유지하되 OS별 구현은 분리한다.
- `bootstrap` / `install` / `check` 역할을 섞지 않는다.
- README는 실제 구조와 항상 맞춘다.

---

## 8. 문제 해결

### PowerShell 프로필이 적용되지 않을 때

```powershell
$PROFILE
Test-Path $PROFILE
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### zsh가 기본 shell이 아닐 때

macOS / WSL에서:

```bash
chsh -s "$(command -v zsh)"
```

### WSL에서 일부 도구가 없을 때

`scripts/install-wsl.sh`는 `bat`, `eza`, `zoxide`까지 맞추려고 시도합니다. 배포판 패키지 차이로 일부가 누락되면 `check-wsl.sh` 결과를 보고 개별 설치를 보완하면 됩니다.

### macOS에서 Homebrew가 없을 때

`scripts/bootstrap-macos.sh`가 Homebrew 설치까지 처리합니다. 이미 Homebrew가 준비된 환경이라면 `scripts/install-macos.sh`만 실행하면 됩니다.

### Windows에서 명령어가 바로 안 잡힐 때

`scripts/install-windows.ps1`는 설치 후 현재 세션의 `PATH`를 다시 읽습니다. 그래도 누락되면 PowerShell 창을 다시 열고 `scripts/check-windows.ps1`를 다시 실행합니다.

---

## 9. 검증 기준

- macOS에서는 `scripts/bootstrap-macos.sh`, `scripts/install-macos.sh`, `scripts/check-macos.sh`와 zsh 설정을 기준으로 본다.
- WSL에서는 `scripts/bootstrap-wsl.sh`, `scripts/install-wsl.sh`, `scripts/check-wsl.sh`와 zsh 설정을 기준으로 본다.
- Windows에서는 `scripts/bootstrap-windows.ps1`, `scripts/install-windows.ps1`, `scripts/check-windows.ps1`와 PowerShell 프로필을 기준으로 본다.
- 다른 OS용 스크립트가 현재 OS에서 바로 실행되지 않는 것은 이 저장소의 문제로 보지 않는다.

---

## 10. 앞으로 개선할 것

- macOS / WSL / Windows용 설정 로직을 더 명확히 분리하기
- Windows 패키지 관리 자동화 보강
- 공통 개념을 더 분리할지 구조 재검토
