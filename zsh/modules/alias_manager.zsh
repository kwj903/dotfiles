# Alias manager
# aliases.zsh를 섹션/주석 단위로 관리한다.

#========명령어 설명==========
# mkaliass : 섹션 + 설명 주석 + alias 추가
# rmaliass : alias 삭제
# lsaliases : 원본 그대로 보기
# showaliases : 보기 좋게 정리해서 보기
# aliasgrep : 검색
# aliassections : 허용 섹션 목록 보기
# edaliases : alias 파일 열기

#========구현 함수==========
_alias_file() {
  echo "${HOME}/.dotfiles/zsh/aliases.zsh"
}

_alias_allowed_sections() {
  cat <<'EOF'
Git
Python
Docker
Tmux
Files
macOS
Project
Network
Tools
EOF
}

_alias_section_valid() {
  local section="$1"
  _alias_allowed_sections | grep -qx "$section"
}

_alias_section_header() {
  local section="$1"
  echo "# ===== ${section} ====="
}

_alias_escape_single_quotes() {
  local value="$1"
  printf "%s" "${value//\'/\'\\\'\'}"
}

_alias_exists() {
  local name="$1"
  local alias_file
  alias_file="$(_alias_file)"

  grep -qE "^[[:space:]]*alias[[:space:]]+${name}=" "$alias_file" 2>/dev/null
}

_alias_ensure_file() {
  local alias_file
  alias_file="$(_alias_file)"
  [[ -f "$alias_file" ]] || touch "$alias_file"
}

_alias_ensure_section() {
  local section="$1"
  local alias_file
  local section_header

  alias_file="$(_alias_file)"
  section_header="$(_alias_section_header "$section")"

  if ! grep -qxF "$section_header" "$alias_file" 2>/dev/null; then
    {
      [[ -s "$alias_file" ]] && echo ""
      echo "$section_header"
      echo ""
    } >> "$alias_file"
  fi
}

_alias_backup() {
  local alias_file
  alias_file="$(_alias_file)"
  cp "$alias_file" "${alias_file}.bak"
}

aliassections() {
  _alias_allowed_sections
}

mkaliass() {
  local section="$1"
  local name="$2"
  local cmd="$3"
  local desc="$4"

  local alias_file
  local section_header
  local escaped_cmd
  local tmp_file

  if [[ -z "$section" || -z "$name" || -z "$cmd" ]]; then
    echo '사용법: mkaliass "섹션" "별칭" "명령어" "설명"'
    echo '예시: mkaliass "Git" "gs" "git status -sb" "git 상태를 짧게 확인"'
    echo
    echo '사용 가능한 섹션:'
    aliassections
    return 1
  fi

  if ! _alias_section_valid "$section"; then
    echo "허용되지 않은 섹션입니다: $section"
    echo
    echo '사용 가능한 섹션:'
    aliassections
    return 1
  fi

  alias_file="$(_alias_file)"
  section_header="$(_alias_section_header "$section")"
  escaped_cmd="$(_alias_escape_single_quotes "$cmd")"

  _alias_ensure_file

  if _alias_exists "$name"; then
    echo "이미 존재하는 alias입니다: $name"
    echo "직접 수정하거나 rmaliass로 삭제 후 다시 추가하세요."
    return 1
  fi

  _alias_ensure_section "$section"
  _alias_backup

  tmp_file="$(mktemp)"

  awk -v section_header="$section_header" \
      -v name="$name" \
      -v escaped_cmd="$escaped_cmd" \
      -v desc="$desc" '
    BEGIN {
      in_target = 0
      inserted = 0
      prev_blank = 0
    }

    function print_alias_block() {
      if (desc != "") {
        print "# " desc
      }
      print "alias " name "='\''" escaped_cmd "'\''"
      print ""
    }

    {
      if ($0 == section_header) {
        in_target = 1
        print
        next
      }

      if (in_target == 1 && $0 ~ /^# ===== .* =====$/) {
        if (inserted == 0) {
          if (prev_blank == 0) {
            print ""
          }
          print_alias_block()
          inserted = 1
        }
        in_target = 0
      }

      print

      if (in_target == 1) {
        if ($0 ~ /^[[:space:]]*$/) {
          prev_blank = 1
        } else {
          prev_blank = 0
        }
      }
    }

    END {
      if (in_target == 1 && inserted == 0) {
        if (prev_blank == 0) {
          print ""
        }
        print_alias_block()
      }
    }
  ' "$alias_file" > "$tmp_file"

  mv "$tmp_file" "$alias_file"
  source "$alias_file"

  echo "추가됨:"
  echo "  섹션: $section"
  [[ -n "$desc" ]] && echo "  설명: $desc"
  echo "  alias ${name}='${cmd}'"
}

rmaliass() {
  local name="$1"
  local alias_file
  local tmp_file

  if [[ -z "$name" ]]; then
    echo '사용법: rmaliass "별칭"'
    return 1
  fi

  alias_file="$(_alias_file)"

  if [[ ! -f "$alias_file" ]]; then
    echo "alias 파일이 없습니다: $alias_file"
    return 1
  fi

  _alias_backup
  tmp_file="$(mktemp)"

  awk -v name="$name" '
    {
      if ($0 ~ "^[[:space:]]*#[[:space:]]*.*$") {
        comment = $0
        if (getline nextline > 0) {
          if (nextline ~ "^[[:space:]]*alias[[:space:]]+" name "=") {
            if (getline thirdline > 0) {
              if (thirdline !~ "^[[:space:]]*$") {
                print thirdline
              }
            }
            next
          } else {
            print comment
            print nextline
            next
          }
        } else {
          print comment
          next
        }
      }

      if ($0 ~ "^[[:space:]]*alias[[:space:]]+" name "=") {
        if (getline nextline > 0) {
          if (nextline !~ "^[[:space:]]*$") {
            print nextline
          }
        }
        next
      }

      print
    }
  ' "$alias_file" > "$tmp_file"

  mv "$tmp_file" "$alias_file"
  unalias "$name" 2>/dev/null
  source "$alias_file"
  echo "삭제됨: $name"
}

lsaliases() {
  local alias_file
  alias_file="$(_alias_file)"

  if [[ ! -f "$alias_file" ]]; then
    echo "alias 파일이 없습니다: $alias_file"
    return 1
  fi

  cat "$alias_file"
}

showaliases() {
  local alias_file
  alias_file="$(_alias_file)"

  if [[ ! -f "$alias_file" ]]; then
    echo "alias 파일이 없습니다: $alias_file"
    return 1
  fi

  awk '
    /^# ===== .* =====$/ {
      if (printed_any == 1) {
        print ""
      }
      print $0
      printed_any = 1
      next
    }

    /^# / {
      print "  " $0
      next
    }

    /^alias / {
      print "  " $0
      next
    }

    /^[[:space:]]*$/ {
      next
    }

    {
      print "  " $0
    }
  ' "$alias_file"
}

edaliases() {
  local alias_file
  alias_file="$(_alias_file)"

  "${EDITOR:-vim}" "$alias_file"
}

aliasgrep() {
  local alias_file
  alias_file="$(_alias_file)"

  if [[ -z "$1" ]]; then
    echo '사용법: aliasgrep "검색어"'
    return 1
  fi

  grep -n --color=always -i "$1" "$alias_file"
}