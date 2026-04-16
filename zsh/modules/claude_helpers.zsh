# Claude / OpenRouter helper
# 원하는 OpenRouter 모델을 임시로 지정해 Claude Code를 실행한다.

cc-or() {
  local model="$1"

  if [[ -z "$model" ]]; then
    echo "사용법: cc-or <openrouter-model-id>"
    return 1
  fi

  ANTHROPIC_BASE_URL="https://openrouter.ai/api" \
  ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY" \
  ANTHROPIC_API_KEY="" \
  ANTHROPIC_CUSTOM_MODEL_OPTION="$model" \
  ANTHROPIC_CUSTOM_MODEL_OPTION_NAME="$model" \
  ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION="OpenRouter model" \
  claude --model "$model"
}