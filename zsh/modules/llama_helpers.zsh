# llama.cpp helper manager
# 목적:
# - brew 설치본 / git 빌드본 llama.cpp 실행을 헷갈리지 않게 분리한다.
# - 모델 파일을 ~/models/<모델폴더>/<모델파일.gguf> 구조로 한 곳에서 관리한다.
# - 파일명이나 폴더명만 입력해도 모델을 찾아서 cli / server를 실행할 수 있게 한다.
# - 모델 추가 / 이동 / 삭제 / 목록 조회 / 서버 포트 확인 / 서버 종료를 한 모듈에서 처리한다.

#========명령어 설명==========
# llamahelp
#   사용 가능한 llama 헬퍼 명령어와 예시를 출력한다.
#
# llamastatus
#   brew판 / git판 실행 파일 경로, 버전, 모델 저장소 상태를 출력한다.
#
# llmodels
#   현재 ~/models 아래에 있는 GGUF 모델 목록을 깔끔하게 출력한다.
#
# llwhere "모델파일명 또는 폴더명"
#   입력한 모델명이 실제 어떤 파일 경로로 해석되는지 출력한다.
#
# llbc "모델명" [추가 llama-cli 옵션]
#   brew 설치본 llama-cli를 실행한다.
#
# llbs "모델명" [포트번호] [추가 llama-server 옵션]
#   brew 설치본 llama-server를 실행한다.
#   기본 포트는 8080이다.
#
# llgc "모델명" [추가 llama-cli 옵션]
#   git 빌드본 llama-cli를 실행한다.
#
# llgs "모델명" [포트번호] [추가 llama-server 옵션]
#   git 빌드본 llama-server를 실행한다.
#   기본 포트는 8081이다.
#
# llpull "hf_repo" "파일명.gguf" ["저장폴더명"]
#   Hugging Face 공개 모델 파일을 ~/models 아래로 바로 다운로드한다.
#
# lladd "/경로/모델.gguf" ["저장폴더명"]
#   이미 가지고 있는 로컬 GGUF 파일을 ~/models 아래로 복사한다.
#
# llimport "파일명.gguf" ["저장폴더명"]
#   Hugging Face 캐시에 이미 받아진 GGUF 파일을 ~/models 아래로 복사한다.
#
# llrm "모델파일명 또는 폴더명"
#   모델 파일 또는 모델 폴더를 삭제한다.
#   폴더명을 주면 그 폴더 전체를 삭제한다.
#
# llmv "원본" "새폴더명" ["새파일명.gguf"]
#   모델 파일을 다른 폴더로 이동하거나 파일명을 바꾼다.
#
# llmv "기존폴더명" "새폴더명"
#   모델 폴더 이름 자체를 바꾼다.
#
# llports
#   현재 실행 중인 llama-server 관련 포트 / PID / 명령을 출력한다.
#
# llstop
#   실행 중인 llama-server를 종료한다.
#
# llstop brew
#   brew 기본 포트(8080)를 사용 중인 서버를 종료한다.
#
# llstop git
#   git 기본 포트(8081)를 사용 중인 서버를 종료한다.
#
# llstop all
#   현재 실행 중인 llama-server 프로세스를 전부 종료한다.
#
# llstop 8080
#   지정한 포트를 점유한 서버를 종료한다.
#
# llstop <PID>
#   지정한 PID를 종료한다.

#========전역 설정==========

typeset -g LLAMA_MODELS_DIR="${HOME}/models"

typeset -g LLAMA_BREW_CLI="/usr/local/bin/llama-cli"
typeset -g LLAMA_BREW_SERVER="/usr/local/bin/llama-server"

typeset -g LLAMA_GIT_CLI="${HOME}/llama.cpp/build/bin/llama-cli"
typeset -g LLAMA_GIT_SERVER="${HOME}/llama.cpp/build/bin/llama-server"

typeset -g LLAMA_GIT_VULKAN_CLI="${HOME}/llama.cpp/build-vulkan/bin/llama-cli"
typeset -g LLAMA_GIT_VULKAN_SERVER="${HOME}/llama.cpp/build-vulkan/bin/llama-server"

typeset -g LLAMA_SERVER_HOST_DEFAULT="127.0.0.1"
typeset -g LLAMA_BREW_SERVER_PORT_DEFAULT="8080"
typeset -g LLAMA_GIT_SERVER_PORT_DEFAULT="8081"
typeset -g LLAMA_GIT_VULKAN_SERVER_PORT_DEFAULT="8082"

[[ -d "$LLAMA_MODELS_DIR" ]] || mkdir -p "$LLAMA_MODELS_DIR"

#========내부 출력 헬퍼==========

_llama_echo_ok() {
  echo "[llama] $*"
}

_llama_echo_err() {
  echo "[llama] $*" >&2
}

#========내부 경로 헬퍼==========

_llama_models_dir() {
  echo "$LLAMA_MODELS_DIR"
}

_llama_hf_cache_dir() {
  echo "${HOME}/.cache/huggingface/hub"
}

_llama_brew_cli_path() {
  echo "$LLAMA_BREW_CLI"
}

_llama_brew_server_path() {
  echo "$LLAMA_BREW_SERVER"
}

_llama_git_cli_path() {
  echo "$LLAMA_GIT_CLI"
}

_llama_git_server_path() {
  echo "$LLAMA_GIT_SERVER"
}

_llama_git_vulkan_cli_path() {
  echo "$LLAMA_GIT_VULKAN_CLI"
}

_llama_git_vulkan_server_path() {
  echo "$LLAMA_GIT_VULKAN_SERVER"
}

_llama_exec_exists() {
  local path="$1"
  [[ -x "$path" ]]
}

_llama_require_exec() {
  local label="$1"
  local path="$2"

  if ! _llama_exec_exists "$path"; then
    _llama_echo_err "${label} 실행 파일이 없습니다: $path"
    return 1
  fi
}

#========내부 공용 헬퍼==========

_llama_confirm() {
  local prompt="$1"
  local answer

  printf "%s [y/N]: " "$prompt"
  read answer

  [[ "$answer" == "y" || "$answer" == "Y" ]]
}

_llama_cleanup_empty_parent_dir() {
  local dir="$1"

  [[ -d "$dir" ]] || return 0
  [[ "$dir" == "$(_llama_models_dir)" ]] && return 0

  if [[ -z "$(find "$dir" -mindepth 1 -maxdepth 1 2>/dev/null)" ]]; then
    rmdir "$dir" 2>/dev/null
  fi
}

_llama_find_gguf_in_dir() {
  local dir="$1"

  [[ -d "$dir" ]] || return 1
  find "$dir" -maxdepth 1 -type f -name '*.gguf' 2>/dev/null | sort
}

_llama_resolve_model_from_folder() {
  local folder_name="$1"
  local model_dir
  local matches
  local count

  model_dir="$(_llama_models_dir)/$folder_name"
  [[ -d "$model_dir" ]] || return 1

  matches="$(_llama_find_gguf_in_dir "$model_dir")"
  count="$(printf "%s\n" "$matches" | sed '/^$/d' | wc -l | tr -d ' ')"

  if [[ "$count" == "1" ]]; then
    printf "%s\n" "$matches"
    return 0
  fi

  if [[ "$count" -gt 1 ]]; then
    _llama_echo_err "폴더 안에 GGUF 파일이 여러 개 있습니다. 파일명을 직접 지정하세요: $folder_name"
    printf "%s\n" "$matches" >&2
    return 1
  fi

  return 1
}

_llama_resolve_model_by_filename() {
  local query="$1"
  find "$(_llama_models_dir)" -type f \( -name "$query" -o -name "${query}.gguf" \) 2>/dev/null | sort
}

_llama_resolve_model_by_partial() {
  local query="$1"
  find "$(_llama_models_dir)" -type f -name '*.gguf' 2>/dev/null | grep -iF -- "$query" | sort
}

_llama_resolve_model() {
  local query="$1"
  local matches
  local count

  if [[ -z "$query" ]]; then
    _llama_echo_err "모델 파일명 또는 폴더명을 입력하세요."
    return 1
  fi

  # 1) 사용자가 전체 파일 경로를 직접 준 경우
  if [[ -f "$query" ]]; then
    echo "$query"
    return 0
  fi

  # 2) ~/models/<폴더명> 으로 찾기
  if matches="$(_llama_resolve_model_from_folder "$query" 2>/dev/null)"; then
    echo "$matches"
    return 0
  fi

  # 3) 정확한 파일명으로 찾기
  matches="$(_llama_resolve_model_by_filename "$query")"
  count="$(printf "%s\n" "$matches" | sed '/^$/d' | wc -l | tr -d ' ')"

  if [[ "$count" == "1" ]]; then
    printf "%s\n" "$matches"
    return 0
  fi

  # 4) 부분 일치로 찾기
  if [[ "$count" == "0" ]]; then
    matches="$(_llama_resolve_model_by_partial "$query")"
    count="$(printf "%s\n" "$matches" | sed '/^$/d' | wc -l | tr -d ' ')"
  fi

  if [[ "$count" == "1" ]]; then
    printf "%s\n" "$matches"
    return 0
  fi

  if [[ "$count" == "0" ]]; then
    _llama_echo_err "모델을 찾지 못했습니다: $query"
    _llama_echo_err "현재 모델 목록은 llmodels 로 확인하세요."
    return 1
  fi

  _llama_echo_err "여러 모델이 발견되었습니다. 더 구체적으로 입력하세요:"
  printf "%s\n" "$matches" >&2
  return 1
}

_llama_model_folder_default_name() {
  local file_path="$1"
  local base_name

  base_name="${file_path:t}"
  echo "${base_name%.gguf}"
}

_llama_model_copy_into_store() {
  local src="$1"
  local folder_name="$2"
  local base_name
  local target_dir
  local target_file

  if [[ ! -f "$src" ]]; then
    _llama_echo_err "원본 파일이 없습니다: $src"
    return 1
  fi

  base_name="${src:t}"

  if [[ "$base_name" != *.gguf ]]; then
    _llama_echo_err "GGUF 파일만 추가할 수 있습니다: $src"
    return 1
  fi

  if [[ -z "$folder_name" ]]; then
    folder_name="$(_llama_model_folder_default_name "$src")"
  fi

  target_dir="$(_llama_models_dir)/$folder_name"
  target_file="$target_dir/$base_name"

  mkdir -p "$target_dir" || return 1

  if [[ -f "$target_file" ]]; then
    _llama_echo_ok "이미 존재합니다: $target_file"
    echo "$target_file"
    return 0
  fi

  cp "$src" "$target_file" || return 1
  _llama_echo_ok "추가 완료: $target_file"
  echo "$target_file"
}

_llama_run_cli() {
  local bin="$1"
  shift

  local model_query="$1"
  shift

  local model_path

  if [[ -z "$model_query" ]]; then
    echo '사용법: <함수명> "모델파일명 또는 폴더명" [추가 llama-cli 옵션]'
    return 1
  fi

  _llama_require_exec "CLI" "$bin" || return 1

  model_path="$(_llama_resolve_model "$model_query")" || return 1
  "$bin" -m "$model_path" "$@"
}

_llama_run_server() {
  local bin="$1"
  local default_port="$2"
  shift 2

  local model_query="$1"
  shift

  local port="$default_port"
  local model_path

  if [[ -z "$model_query" ]]; then
    echo '사용법: <함수명> "모델파일명 또는 폴더명" [포트번호] [추가 llama-server 옵션]'
    return 1
  fi

  _llama_require_exec "SERVER" "$bin" || return 1

  model_path="$(_llama_resolve_model "$model_query")" || return 1

  if [[ -n "$1" && "$1" == <-> ]]; then
    port="$1"
    shift
  fi

  "$bin" -m "$model_path" --host "$LLAMA_SERVER_HOST_DEFAULT" --port "$port" "$@"
}

_llama_pids_by_port() {
  local port="$1"
  lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null | sort -u
}

_llama_stop_pid() {
  local pid="$1"

  if [[ -z "$pid" ]]; then
    _llama_echo_err "종료할 PID가 없습니다."
    return 1
  fi

  if ! ps -p "$pid" >/dev/null 2>&1; then
    _llama_echo_err "존재하지 않는 PID입니다: $pid"
    return 1
  fi

  kill "$pid" 2>/dev/null || return 1
  _llama_echo_ok "종료 요청 완료: PID $pid"
}

_llama_stop_port() {
  local port="$1"
  local pids

  pids="$(_llama_pids_by_port "$port")"

  if [[ -z "$pids" ]]; then
    _llama_echo_ok "포트 $port 를 점유 중인 LISTEN 프로세스가 없습니다."
    return 0
  fi

  while IFS= read -r pid; do
    [[ -z "$pid" ]] && continue
    _llama_stop_pid "$pid" || return 1
  done <<< "$pids"
}

#========사용자 함수==========

llamahelp() {
  cat <<'EOF'
#========llama helper 명령어==========

# 상태 / 조회
# llamahelp
#   도움말 출력
#
# llamastatus
#   brew판 / git판 실행 파일 경로, 버전, 모델 저장소 상태 출력
#
# llmodels
#   현재 ~/models 아래 GGUF 모델 목록 출력
#
# llwhere "모델파일명 또는 폴더명"
#   입력한 모델명이 실제 어떤 파일 경로로 해석되는지 출력

# 실행
# llbc "모델명"
#   brew 설치본 llama-cli 실행
#
# llbs "모델명"
#   brew 설치본 llama-server 실행 (기본 포트 8080)
#
# llbs "모델명" 8090
#   brew 설치본 서버를 원하는 포트로 실행
#
# llgc "모델명"
#   git 빌드본 llama-cli 실행
#
# llgs "모델명"
#   git 빌드본 llama-server 실행 (기본 포트 8081)
#
# llgs "모델명" 8091
#   git 빌드본 서버를 원하는 포트로 실행
#
# llgcv "모델명"
#   git Vulkan 빌드본 llama-cli 실행
#
# llgsv "모델명"
#   git Vulkan 빌드본 llama-server 실행 (기본 포트 8082)
#
# llgsv "모델명" 8092
#   git Vulkan 빌드본 서버를 원하는 포트로 실행

# 모델 추가 / 정리
# llpull "repo" "파일명.gguf"
#   Hugging Face 공개 모델을 ~/models 아래로 다운로드
#
# llpull "repo" "파일명.gguf" "폴더명"
#   원하는 폴더명으로 다운로드
#
# lladd "/경로/모델.gguf"
#   로컬 GGUF 파일을 ~/models 아래로 복사
#
# lladd "/경로/모델.gguf" "폴더명"
#   원하는 폴더명으로 복사
#
# llimport "파일명.gguf"
#   HF 캐시에 있는 GGUF 파일을 ~/models 아래로 복사
#
# llimport "파일명.gguf" "폴더명"
#   원하는 폴더명으로 복사
#
# llrm "모델파일명 또는 폴더명"
#   모델 파일 또는 폴더 삭제
#
# llmv "원본파일명" "새폴더명" ["새파일명.gguf"]
#   모델 파일을 새 폴더로 이동하거나 파일명을 바꿈
#
# llmv "기존폴더명" "새폴더명"
#   모델 폴더 이름 자체를 바꿈

# 서버 관리
# llports
#   현재 떠 있는 llama-server 관련 포트 / PID / 명령 확인
#
# llstop brew
#   brew 기본 포트(8080) 서버 종료
#
# llstop git
#   git 기본 포트(8081) 서버 종료
#
# llstop all
#   현재 떠 있는 llama-server 전체 종료
#
# llstop 8080
#   해당 포트를 점유한 서버 종료
#
# llstop <PID>
#   해당 PID 종료
#
# llstop vulkan
#   git Vulkan 기본 포트(8082) 서버 종료

# 예시
# llmodels
# llwhere "gemma-3-1b-it-Q4_K_M.gguf"
# llbc "gemma-3-1b-it-Q4_K_M.gguf"
# llbs "gemma-3-1b-it-Q4_K_M.gguf"
# llgc "gemma-3-1b-it-Q4_K_M.gguf"
# llgs "gemma-3-1b-it-Q4_K_M.gguf"
# llpull "ggml-org/gemma-3-1b-it-GGUF" "gemma-3-1b-it-Q4_K_M.gguf"
# llmv "gemma-3-1b-it-Q4_K_M.gguf" "gemma3-1b"
# llrm "gemma3-1b"
# llports
# llstop all

EOF
}

llamastatus() {
  echo "=== llama.cpp 상태 ==="
  echo
  echo "[brew 설치본]"
  echo "cli    : $(_llama_brew_cli_path)"
  echo "server : $(_llama_brew_server_path)"
  if _llama_exec_exists "$(_llama_brew_cli_path)"; then
    "$(_llama_brew_cli_path)" --version 2>/dev/null | sed 's/^/  /'
  else
    echo "  설치되지 않았거나 실행 파일이 없습니다."
  fi

  echo
  echo "[git 빌드본]"
  echo "cli    : $(_llama_git_cli_path)"
  echo "server : $(_llama_git_server_path)"
  if _llama_exec_exists "$(_llama_git_cli_path)"; then
    "$(_llama_git_cli_path)" --version 2>/dev/null | sed 's/^/  /'
  else
    echo "  빌드되지 않았거나 실행 파일이 없습니다."
  fi

  echo
  echo "[git Vulkan 빌드본]"
  echo "cli    : $(_llama_git_vulkan_cli_path)"
  echo "server : $(_llama_git_vulkan_server_path)"
  if _llama_exec_exists "$(_llama_git_vulkan_cli_path)"; then
  "$(_llama_git_vulkan_cli_path)" --version 2>/dev/null | sed 's/^/  /'
  else
  echo "  Vulkan 빌드가 없거나 실행 파일이 없습니다."
  fi

  echo
  echo "[모델 저장소]"
  echo "dir    : $(_llama_models_dir)"
  if [[ -d "$(_llama_models_dir)" ]]; then
    local count
    count="$(find "$(_llama_models_dir)" -type f -name '*.gguf' 2>/dev/null | wc -l | tr -d ' ')"
    echo "count  : ${count}개"
  else
    echo "count  : 0개"
  fi
}

llmodels() {
  local model_dir
  local files
  local count
  local file
  local size
  local folder

  model_dir="$(_llama_models_dir)"

  if [[ ! -d "$model_dir" ]]; then
    echo "모델 저장소가 없습니다: $model_dir"
    return 1
  fi

  files="$(find "$model_dir" -type f -name '*.gguf' 2>/dev/null | sort)"
  count="$(printf "%s\n" "$files" | sed '/^$/d' | wc -l | tr -d ' ')"

  if [[ "$count" == "0" ]]; then
    echo "등록된 GGUF 모델이 없습니다."
    return 0
  fi

  printf '%-42s %-8s %s\n' "FILE" "SIZE" "FOLDER"
  printf '%-42s %-8s %s\n' "------------------------------------------" "--------" "------------------------------"

  while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    size="$(du -h "$file" | awk '{print $1}')"
    folder="${file:h}"
    folder="${folder#$model_dir/}"
    printf '%-42s %-8s %s\n' "${file:t}" "$size" "$folder"
  done <<< "$files"
}

llwhere() {
  if [[ -z "$1" ]]; then
    echo '사용법: llwhere "모델파일명 또는 폴더명"'
    return 1
  fi

  _llama_resolve_model "$1"
}

llpull() {
  local repo="$1"
  local remote_filename="$2"
  local folder_name="${3:-${repo:t}}"

  local target_dir
  local target_file
  local tmp_file
  local url

  if [[ -z "$repo" || -z "$remote_filename" ]]; then
    echo '사용법: llpull "hf_repo" "gguf_filename" ["저장폴더명"]'
    echo '예시: llpull "ggml-org/gemma-3-1b-it-GGUF" "gemma-3-1b-it-Q4_K_M.gguf"'
    return 1
  fi

  target_dir="$(_llama_models_dir)/$folder_name"
  target_file="$target_dir/${remote_filename:t}"
  tmp_file="${target_file}.part"
  url="https://huggingface.co/${repo}/resolve/main/${remote_filename}?download=true"

  mkdir -p "$target_dir" || return 1

  if [[ -f "$target_file" ]]; then
    _llama_echo_ok "이미 존재합니다: $target_file"
    echo "$target_file"
    return 0
  fi

  _llama_echo_ok "다운로드 시작: $repo / $remote_filename"

  if [[ -n "${HF_TOKEN:-}" ]]; then
    curl -fL --progress-bar \
      -H "Authorization: Bearer ${HF_TOKEN}" \
      "$url" -o "$tmp_file" || {
        rm -f "$tmp_file"
        _llama_echo_err "다운로드 실패: $url"
        return 1
      }
  else
    curl -fL --progress-bar \
      "$url" -o "$tmp_file" || {
        rm -f "$tmp_file"
        _llama_echo_err "다운로드 실패: $url"
        return 1
      }
  fi

  mv "$tmp_file" "$target_file" || return 1
  _llama_echo_ok "저장 완료: $target_file"
  echo "$target_file"
}

lladd() {
  local src="$1"
  local folder_name="$2"

  if [[ -z "$src" ]]; then
    echo '사용법: lladd "/경로/모델.gguf" ["저장폴더명"]'
    return 1
  fi

  _llama_model_copy_into_store "$src" "$folder_name"
}

llimport() {
  local filename="$1"
  local folder_name="$2"
  local src

  if [[ -z "$filename" ]]; then
    echo '사용법: llimport "gguf_파일명" ["저장폴더명"]'
    return 1
  fi

  src="$(find "$(_llama_hf_cache_dir)" -type f -name "$filename" 2>/dev/null | head -n 1)"

  if [[ -z "$src" ]]; then
    _llama_echo_err "HF 캐시에서 파일을 찾지 못했습니다: $filename"
    return 1
  fi

  _llama_model_copy_into_store "$src" "$folder_name"
}

llbc() {
  _llama_run_cli "$(_llama_brew_cli_path)" "$@"
}

llbs() {
  _llama_run_server "$(_llama_brew_server_path)" "$LLAMA_BREW_SERVER_PORT_DEFAULT" "$@"
}

llgc() {
  _llama_run_cli "$(_llama_git_cli_path)" "$@"
}

llgs() {
  _llama_run_server "$(_llama_git_server_path)" "$LLAMA_GIT_SERVER_PORT_DEFAULT" "$@"
}

llgcv() {
  use_vulkan || return 1
  _llama_run_cli "$(_llama_git_vulkan_cli_path)" "$@"
}

llgsv() {
  use_vulkan || return 1
  _llama_run_server "$(_llama_git_vulkan_server_path)" "$LLAMA_GIT_VULKAN_SERVER_PORT_DEFAULT" "$@"
}

llrm() {
  local query="$1"
  local exact_folder
  local resolved_file
  local parent_dir

  if [[ -z "$query" ]]; then
    echo '사용법: llrm "모델파일명 또는 폴더명"'
    return 1
  fi

  exact_folder="$(_llama_models_dir)/$query"

  # 정확히 폴더명이면 폴더 전체 삭제
  if [[ -d "$exact_folder" ]]; then
    if ! _llama_confirm "모델 폴더 전체를 삭제할까요? $exact_folder"; then
      _llama_echo_ok "삭제를 취소했습니다."
      return 0
    fi

    rm -rf "$exact_folder" || return 1
    _llama_echo_ok "폴더 삭제 완료: $exact_folder"
    return 0
  fi

  # 아니면 모델 파일로 해석해서 파일만 삭제
  resolved_file="$(_llama_resolve_model "$query")" || return 1

  if ! _llama_confirm "모델 파일을 삭제할까요? $resolved_file"; then
    _llama_echo_ok "삭제를 취소했습니다."
    return 0
  fi

  rm -f "$resolved_file" || return 1
  _llama_echo_ok "파일 삭제 완료: $resolved_file"

  parent_dir="${resolved_file:h}"
  _llama_cleanup_empty_parent_dir "$parent_dir"
}

llmv() {
  local src_query="$1"
  local new_folder="$2"
  local new_filename="$3"

  local exact_folder
  local target_folder_dir

  local resolved_file
  local src_parent
  local src_basename
  local dst_file

  if [[ -z "$src_query" || -z "$new_folder" ]]; then
    echo '사용법 1: llmv "원본파일명 또는 폴더명" "새폴더명" ["새파일명.gguf"]'
    echo '사용법 2: llmv "기존폴더명" "새폴더명"'
    return 1
  fi

  exact_folder="$(_llama_models_dir)/$src_query"

  # 정확한 폴더명이면 폴더 자체 이름 변경
  if [[ -d "$exact_folder" && -z "$new_filename" ]]; then
    target_folder_dir="$(_llama_models_dir)/$new_folder"

    if [[ -e "$target_folder_dir" ]]; then
      _llama_echo_err "대상 폴더가 이미 존재합니다: $target_folder_dir"
      return 1
    fi

    mv "$exact_folder" "$target_folder_dir" || return 1
    _llama_echo_ok "폴더 이름 변경 완료: $exact_folder -> $target_folder_dir"
    return 0
  fi

  # 아니면 모델 파일 이동 / 파일명 변경
  resolved_file="$(_llama_resolve_model "$src_query")" || return 1
  src_parent="${resolved_file:h}"
  src_basename="${resolved_file:t}"

  target_folder_dir="$(_llama_models_dir)/$new_folder"
  mkdir -p "$target_folder_dir" || return 1

  if [[ -z "$new_filename" ]]; then
    new_filename="$src_basename"
  fi

  if [[ "$new_filename" != *.gguf ]]; then
    _llama_echo_err "새 파일명은 .gguf 로 끝나야 합니다: $new_filename"
    return 1
  fi

  dst_file="$target_folder_dir/$new_filename"

  if [[ -e "$dst_file" ]]; then
    _llama_echo_err "대상 파일이 이미 존재합니다: $dst_file"
    return 1
  fi

  mv "$resolved_file" "$dst_file" || return 1
  _llama_echo_ok "모델 이동 완료: $resolved_file -> $dst_file"

  _llama_cleanup_empty_parent_dir "$src_parent"
}

llports() {
  local out

  echo "=== llama-server 포트 상태 ==="
  echo

  out="$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | grep -E "llama-server|:${LLAMA_BREW_SERVER_PORT_DEFAULT}|:${LLAMA_GIT_SERVER_PORT_DEFAULT}|:${LLAMA_GIT_VULKAN_SERVER_PORT_DEFAULT}")"

  if [[ -z "$out" ]]; then
    echo "실행 중인 llama-server 관련 LISTEN 프로세스를 찾지 못했습니다."
    return 0
  fi

  echo "$out"
}

llstop() {
  local target="${1:-all}"
  local pids

  case "$target" in
    brew)
      _llama_stop_port "$LLAMA_BREW_SERVER_PORT_DEFAULT"
      ;;
    git)
      _llama_stop_port "$LLAMA_GIT_SERVER_PORT_DEFAULT"
      ;;
    vulkan)
      _llama_stop_port "$LLAMA_GIT_VULKAN_SERVER_PORT_DEFAULT"
      ;;
    all)
      pids="$(pgrep -f 'llama-server')"
      if [[ -z "$pids" ]]; then
        _llama_echo_ok "실행 중인 llama-server 프로세스가 없습니다."
        return 0
      fi
      while IFS= read -r pid; do
        [[ -z "$pid" ]] && continue
        _llama_stop_pid "$pid" || return 1
      done <<< "$pids"
      ;;
    <->)
      if ps -p "$target" >/dev/null 2>&1; then
        _llama_stop_pid "$target"
      else
        _llama_stop_port "$target"
      fi
      ;;
    *)
      echo '사용법: llstop [brew|git|vulkan|all|포트번호|PID]'
      return 1
      ;;
  esac
}