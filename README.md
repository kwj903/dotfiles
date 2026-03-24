# Dotfiles

새 맥에서 이 저장소 하나만 clone한 뒤 빠르게 같은 작업 환경을 복원하기 위한 macOS 전용 dotfiles입니다.

핵심 원칙은 다음과 같습니다.

- 대상 OS는 macOS 하나로 고정한다.
- `zsh` 설정은 기능별 파일로 나눠서 읽기 쉽게 유지한다.
- 새 맥에서는 `clone -> bootstrap`만으로 기본 환경이 올라오게 한다.
- 장비 전용 설정과 비밀값은 공용 설정과 분리한다.
- 현재 터미널이 깨질 수 있는 하드코딩 경로와 OS 분기는 최소화한다.

## 빠른 시작

완전히 새 macOS라면:

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/bootstrap.sh
exec zsh
```

이미 Homebrew가 준비된 macOS라면:

```bash
git clone https://github.com/kwj903/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
exec zsh
```

설치 상태를 다시 확인하려면:

```bash
~/.dotfiles/scripts/check.sh
```

## 설치 흐름

- `scripts/bootstrap.sh`
  - Xcode Command Line Tools와 Homebrew를 확인한 뒤 `install.sh`를 호출합니다.
- `scripts/install.sh`
  - `Brewfile` 기준으로 CLI, 앱, VS Code 확장을 설치합니다.
  - `oh-my-zsh`, `powerlevel10k`, `bun`이 없으면 함께 설치합니다.
  - `~/.zshrc`를 이 저장소의 `zsh/zshrc`로 연결합니다.
  - `zsh/local.zsh`, `zsh/secrets.zsh`가 없으면 example 파일로 초기화합니다.
- `scripts/check.sh`
  - 주요 명령, 프롬프트 자산, 심볼릭 링크 상태를 점검합니다.

## 저장소 구조

```text
.dotfiles
├── .gitignore
├── Brewfile
├── README.md
├── scripts
│   ├── bootstrap.sh
│   ├── check.sh
│   ├── install.sh
│   └── link.sh
└── zsh
    ├── aliases.zsh
    ├── env.zsh
    ├── functions.zsh
    ├── history.zsh
    ├── keybindings.zsh
    ├── local.zsh.example
    ├── p10k.zsh
    ├── prompt.zsh
    ├── runtime.zsh
    ├── secrets.zsh.example
    ├── tools.zsh
    └── zshrc
```

## zsh 로딩 구조

- `zsh/zshrc`
  - 실제 진입점입니다.
  - `env -> prompt -> history -> aliases -> functions -> keybindings -> tools -> runtime -> secrets -> local` 순서로 로드합니다.
- `zsh/env.zsh`
  - 공통 환경변수와 macOS용 `PATH`를 설정합니다.
- `zsh/prompt.zsh`
  - `oh-my-zsh`, `powerlevel10k`, `zsh-autosuggestions`를 설정합니다.
- `zsh/tools.zsh`
  - `fzf`, `delta`, `atuin`, `direnv`, `zoxide`, `bun` completion을 초기화합니다.
- `zsh/runtime.zsh`
  - `mise`를 활성화하고 예전 버전 매니저 흔적을 정리합니다.
- `zsh/local.zsh`
  - iTerm integration, 로컬 alias, 개인 도구 completion처럼 장비 전용 설정을 둡니다.
- `zsh/secrets.zsh`
  - 비밀값만 둡니다.
- `~/.p10k.zsh`
  - 존재하면 이 파일이 우선 적용됩니다.
  - 없으면 저장소의 `zsh/p10k.zsh` fallback 설정이 사용됩니다.

## 로컬 파일 정책

다음 파일은 Git에 올리지 않습니다.

- `zsh/local.zsh`
- `zsh/secrets.zsh`

초기 템플릿은 아래 파일을 기준으로 생성됩니다.

- `zsh/local.zsh.example`
- `zsh/secrets.zsh.example`

## Brewfile 원칙

`Brewfile`은 새 맥에서 바로 필요한 도구를 재현하는 기준 파일입니다.

- CLI 도구
  - `git`, `ripgrep`, `bat`, `eza`, `fzf`, `gh`, `tmux`, `zoxide`, `atuin`, `direnv`, `mise`, `just`, `git-delta`, `watchexec`, `hyperfine`
- 앱
  - `visual-studio-code`, `raycast`, `tailscale-app`
- 폰트
  - `font-meslo-lg-nerd-font`
- VS Code 확장
  - 현재 사용하는 확장 목록을 그대로 설치합니다.

`brew bundle`은 기본적으로 설치와 동기화만 수행하고, 패키지 정리는 강제로 하지 않습니다.

## 운영 메모

- `~/.zshrc`가 일반 파일로 이미 있으면 `scripts/link.sh`가 백업한 뒤 심볼릭 링크로 교체합니다.
- Apple Silicon을 기준으로 `/opt/homebrew/bin`을 우선 `PATH`에 넣고, Intel 경로 `/usr/local/bin`도 함께 포함합니다.
- 저장소 공통 설정에는 macOS 외 OS 분기를 두지 않습니다.
- 개인 도구 전용 alias나 completion은 공용 파일이 아니라 `zsh/local.zsh`에 둡니다.

## 문제 해결

기본 shell이 `zsh`가 아니라면:

```bash
chsh -s "$(command -v zsh)"
```

Homebrew가 설치되었는데 명령이 안 잡히면:

```bash
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
```

설치 후 새 셸에 반영하려면:

```bash
exec zsh
```
