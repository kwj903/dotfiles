# Purpose: Vulkan SDK 환경 로드와 llama.cpp Vulkan 빌드 헬퍼

use_vulkan() {
  local sdk_root sdk_script

  sdk_root="${VULKAN_HOME:-$HOME/VulkanSDK}"
  sdk_script="$(find "$sdk_root" -path "*/setup-env.sh" 2>/dev/null | sort -V | tail -n 1)"

  if [[ -z "$sdk_script" ]]; then
    echo "[vulkan] setup-env.sh를 찾지 못했습니다: $sdk_root" >&2
    return 1
  fi

  source "$sdk_script"

  echo "[vulkan] loaded: $sdk_script"
  echo "[vulkan] VULKAN_SDK=${VULKAN_SDK:-<not set>}"
}

vulkan_path() {
  local sdk_root
  sdk_root="${VULKAN_HOME:-$HOME/VulkanSDK}"
  find "$sdk_root" -path "*/setup-env.sh" 2>/dev/null | sort -V | tail -n 1
}

vulkan_status() {
  echo "VULKAN_HOME=${VULKAN_HOME:-<not set>}"
  echo "VULKAN_SDK=${VULKAN_SDK:-<not set>}"
  command -v vulkaninfo >/dev/null 2>&1 && echo "vulkaninfo=$(command -v vulkaninfo)" || echo "vulkaninfo not found"
}

llama_vulkan_build() {
  use_vulkan || return 1
  cd "$HOME/llama.cpp" || return 1

  cmake -B build-vulkan -G Ninja \
    -DGGML_VULKAN=ON \
    -DGGML_METAL=OFF \
    -DCMAKE_BUILD_TYPE=Release || return 1

  cmake --build build-vulkan -j --target llama-cli llama-server
}

llama_vulkan_clean() {
  cd "$HOME/llama.cpp" || return 1
  rm -rf build-vulkan
  echo "[vulkan] removed: $HOME/llama.cpp/build-vulkan"
}