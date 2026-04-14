# TOOLS.md

개인 로컬 개발환경 운영 기준 문서.

## 런타임 관리 원칙

- 언어 런타임 버전은 `mise`로 관리한다.
- 현재 기본 런타임:
  - `node = 24`
  - `python = 3.12`
- 셸 PATH에서 특정 `mise install` 버전 경로를 직접 우선 노출하지 않는다.
- 런타임 선택은 `mise activate`가 담당한다.

## CLI 도구 설치 원칙

### 1) 런타임
- `node`, `python` 같은 언어 런타임만 `mise`로 관리

### 2) 독립 CLI
- 가능하면 Homebrew, cask, 공식 standalone 설치 사용
- 현재 예시:
  - `gh`
  - `uv`
  - `codex`
  - `claude`
  - `bun`

### 3) Node 전역 CLI
- `npm -g`가 필요하면 `~/.npm-global` prefix를 사용
- 목적: 특정 Node 버전 install 디렉터리에 CLI가 묶이지 않게 하기
- 현재 `~/.npm-global`로 분리한 CLI:
  - `gemini`
  - `qwen`
  - `kilo`, `kilocode`
  - `serve`

### 4) Python CLI
- 기본은 `uv` 중심
- 프로젝트 의존성은 프로젝트 내부에 설치
- 전역 Python CLI는 꼭 필요할 때만 별도 관리

## OpenClaw 관련 주의

- 현재 OpenClaw는 `mise` 의존 설치가 아니라 독립 설치로 유지한다.
- CLI wrapper는 `~/.npm-global/bin/openclaw`, 실제 런타임/패키지는 `~/.local/share/openclaw-install` 아래에 둔다.
- gateway / launchd 서비스는 새 설치 경로를 가리키도록 유지하고, 사용 중일 때는 무심코 재설치하지 않는다.

## PATH 운영 원칙

- 기본 PATH와 런타임 선택 책임을 분리한다
- dotfiles는 기본 PATH와 환경변수만 관리한다
- 런타임 버전 선택은 `mise`만 담당한다
- 예전 매니저 흔적(`fnm`, `asdf`, `volta`, `pyenv`)은 PATH에서 제거한다

## 기억할 것

- `mise`는 런타임 관리자
- 공용 CLI는 독립 설치 우선
- Node 전역 CLI는 `~/.npm-global`
- 프로젝트 도구는 프로젝트 로컬 설치 우선
