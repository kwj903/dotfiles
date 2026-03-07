# Dotfiles

내 macOS 개발 환경을 재현 가능하게 관리하기 위한 dotfiles 저장소.

이 저장소는 다음을 관리한다.

- zsh 설정
- Homebrew 패키지 / 앱 / VS Code 확장
- 심볼릭 링크 기반 `.zshrc` 연결
- 설치 / 점검 / 부트스트랩 스크립트
- 개인 장비 전용 설정(`local.zsh`)과 민감 정보(`secrets.zsh`) 분리

---

## 현재 사용 장비 정보

현재 기준 환경:

- **기기**: Intel MacBook Pro 2019
- **OS**: macOS
- **Shell**: zsh
- **패키지 관리자**: Homebrew
- **프롬프트**: Powerlevel10k
- **설정 관리 방식**: dotfiles + symlink

> 참고  
> 이 저장소는 현재 **Intel Mac 기준**으로 구성되어 있다.  
> 이후 Apple Silicon Mac으로 옮기면 `/usr/local` 관련 경로를 `/opt/homebrew` 기준으로 일부 조정해야 할 수 있다.

---

## 목적

이 저장소의 목적은 다음과 같다.

1. 새 컴퓨터에서도 빠르게 같은 개발 환경을 복원한다.
2. 쉘 설정을 한 파일이 아니라 기능별 파일로 분리해서 관리한다.
3. 개인 장비 전용 설정과 민감 정보를 공용 설정과 분리한다.
4. 설치 과정을 자동화해서 “기억”이 아니라 “코드”로 환경을 재현한다.

핵심 개념은 단순하다.

- 실제 zsh 설정 파일은 `~/.dotfiles/zsh/zshrc`
- 홈 디렉토리의 `~/.zshrc` 는 심볼릭 링크
- 설치는 `scripts/install.sh`
- 점검은 `scripts/check.sh`

---

## 저장소 구조

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