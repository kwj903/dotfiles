# llama helper completions
# 목적:
# - llama_helpers.zsh 함수들에 모델/포트/캐시 파일 completion을 붙인다.
# - 각 후보를 "하나의 선택지"로 보여주고 메뉴형으로 고를 수 있게 한다.

(( $+functions[compdef] )) || return 0

# ===== 공용 데이터 수집 =====

_llama_comp_models_root() {
  print -r -- "${LLAMA_MODELS_DIR:-$HOME/models}"
}

_llama_comp_collect_model_files() {
  local root
  root="$(_llama_comp_models_root)"
  [[ -d "$root" ]] || return 0

  find "$root" -type f -name '*.gguf' 2>/dev/null | sort
}

_llama_comp_collect_model_file_names() {
  local -a lines out
  local line
  typeset -U out

  lines=("${(@f)$(_llama_comp_collect_model_files)}")

  for line in "${lines[@]}"; do
    [[ -n "$line" ]] && out+=("${line:t}")
  done

  print -rl -- "${out[@]}"
}

_llama_comp_collect_model_folders() {
  local root
  local -a lines out
  local line rel
  typeset -U out

  root="$(_llama_comp_models_root)"
  lines=("${(@f)$(_llama_comp_collect_model_files)}")

  for line in "${lines[@]}"; do
    rel="${${line:h}#$root/}"
    [[ -n "$rel" && "$rel" != "${line:h}" ]] && out+=("$rel")
  done

  print -rl -- "${out[@]}"
}

_llama_comp_collect_hf_cache_files() {
  local cache_root
  cache_root="${HOME}/.cache/huggingface/hub"
  [[ -d "$cache_root" ]] || return 0

  find "$cache_root" -type f -name '*.gguf' 2>/dev/null | sed 's#.*/##' | sort -u
}

_llama_comp_collect_stop_targets() {
  local -a out ports
  typeset -U out

  out+=(brew git all 8080 8081 8082)

  ports=("${(@f)$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null \
    | awk '/llama-server|:8080|:8081/ {split($9,a,":"); print a[length(a)]}' \
    | sort -u)}")

  out+=("${ports[@]}")
  print -rl -- "${out[@]}"
}

# ===== 공용 completion 표시 =====

_llama_comp_show_model_refs() {
  local -a model_files model_folders
  local ret=1

  model_files=("${(@f)$(_llama_comp_collect_model_file_names)}")
  model_folders=("${(@f)$(_llama_comp_collect_model_folders)}")

  # 바로 메뉴 선택 쪽으로 유도
  compstate[insert]=menu
  compstate[list]=list

  (( ${#model_files[@]} )) && _wanted model-files expl 'model files' \
    compadd -Q -S '' -a model_files && ret=0

  (( ${#model_folders[@]} )) && _wanted model-folders expl 'model folders' \
    compadd -Q -S '' -a model_folders && ret=0

  return ret
}

_llama_comp_show_hf_cache_files() {
  local -a files
  files=("${(@f)$(_llama_comp_collect_hf_cache_files)}")

  compstate[insert]=menu
  compstate[list]=list

  (( ${#files[@]} )) && _wanted hf-cache-files expl 'hf cache gguf files' \
    compadd -Q -S '' -a files
}

_llama_comp_show_stop_targets() {
  local -a targets
  targets=("${(@f)$(_llama_comp_collect_stop_targets)}")

  compstate[insert]=menu
  compstate[list]=list

  (( ${#targets[@]} )) && _wanted stop-targets expl 'stop targets' \
    compadd -Q -S '' -a targets
}

# ===== 명령별 completion =====

# llbc / llgc / llwhere / llrm
# 첫 번째 인자: 모델 파일명 또는 모델 폴더명
_llama_complete_model_ref_cmd() {
  if (( CURRENT == 2 )); then
    _llama_comp_show_model_refs
    return
  fi
}

# llbs / llgs
# 첫 번째 인자: 모델
# 두 번째 인자: 포트
_llama_complete_server_cmd() {
  if (( CURRENT == 2 )); then
    _llama_comp_show_model_refs
    return
  fi

  if (( CURRENT == 3 )); then
    local -a ports
    ports=(8080 8081 8090 8091)

    compstate[insert]=menu
    compstate[list]=list

    _wanted llama-ports expl 'server ports' compadd -Q -S '' -a ports
    return
  fi
}

# llimport
# 첫 번째 인자: HF 캐시에 있는 gguf 파일명
_llama_complete_import_cmd() {
  if (( CURRENT == 2 )); then
    _llama_comp_show_hf_cache_files
    return
  fi
}

# lladd
# 첫 번째 인자: 로컬 gguf 파일 경로
_llama_complete_add_cmd() {
  if (( CURRENT == 2 )); then
    _files -g '*.gguf'
    return
  fi
}

# llmv
# 첫 번째 인자: 기존 모델 파일명 또는 폴더명
# 두 번째 인자: 대상 폴더명
_llama_complete_move_cmd() {
  if (( CURRENT == 2 )); then
    _llama_comp_show_model_refs
    return
  fi

  if (( CURRENT == 3 )); then
    local -a folders
    folders=("${(@f)$(_llama_comp_collect_model_folders)}")

    compstate[insert]=menu
    compstate[list]=list

    (( ${#folders[@]} )) && _wanted target-folders expl 'target folders' \
      compadd -Q -S '' -a folders
    return
  fi
}

# llstop
# 첫 번째 인자: brew / git / all / 포트
_llama_complete_stop_cmd() {
  if (( CURRENT == 2 )); then
    _llama_comp_show_stop_targets
    return
  fi
}

# ===== compdef 등록 =====

compdef _llama_complete_model_ref_cmd llbc
compdef _llama_complete_model_ref_cmd llgc
compdef _llama_complete_model_ref_cmd llgcv
compdef _llama_complete_model_ref_cmd llwhere
compdef _llama_complete_model_ref_cmd llrm

compdef _llama_complete_server_cmd llbs
compdef _llama_complete_server_cmd llgs
compdef _llama_complete_server_cmd llgsv

compdef _llama_complete_import_cmd llimport
compdef _llama_complete_add_cmd lladd
compdef _llama_complete_move_cmd llmv
compdef _llama_complete_stop_cmd llstop