#!/usr/bin/env bash
# inject-local.sh
# Strips YAML frontmatter from a SKILL.md and injects the body as a system
# prompt into any Ollama model. No duplicate prompt files needed.
#
# Usage:
#   ./scripts/inject-local.sh <skill-name> "<user prompt>"
#   OLLAMA_MODEL=gemma4:27b ./scripts/inject-local.sh humanizer "Humanize: ..."

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOMAIN="${1:-}"
PROMPT="${2:-}"
OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5:latest}"
OLLAMA_URL="${OLLAMA_URL:-http://localhost:11434}"

if [[ -z "$DOMAIN" || -z "$PROMPT" ]]; then
  echo "Usage: $0 <skill-name> <prompt>"
  echo ""
  echo "Available skills:"
  ls "${REPO_ROOT}/skills/" | sed 's/^/  /'
  exit 1
fi

SKILL_FILE="${REPO_ROOT}/skills/${DOMAIN}/SKILL.md"

if [[ ! -f "$SKILL_FILE" ]]; then
  echo "Error: No SKILL.md found for '${DOMAIN}'"
  echo "Expected: ${SKILL_FILE}"
  exit 1
fi

# Strip YAML frontmatter — everything between first --- and second ---
# What remains is the plain Markdown body: this IS the system prompt
SYSTEM_PROMPT=$(awk 'BEGIN{n=0} /^---/{n++; next} n>=2{print}' "$SKILL_FILE")

if [[ -z "$SYSTEM_PROMPT" ]]; then
  echo "Warning: frontmatter strip returned empty — using full file"
  SYSTEM_PROMPT=$(cat "$SKILL_FILE")
fi

echo "[inject-local] skill:  ${DOMAIN}"
echo "[inject-local] model:  ${OLLAMA_MODEL}"
echo "[inject-local] prompt: ${PROMPT:0:80}..."
echo ""

curl -s "${OLLAMA_URL}/api/chat" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg model  "$OLLAMA_MODEL" \
    --arg system "$SYSTEM_PROMPT" \
    --arg user   "$PROMPT" \
    '{model: $model, stream: false,
      messages: [
        {role: "system", content: $system},
        {role: "user",   content: $user}
      ]}')" \
  | jq -r '.message.content'
