#!/usr/bin/env bash
# test-humanizer.sh — compare Claude API vs Ollama on the humanizer skill.
# Both read the SAME SKILL.md. No duplicate prompt files.
#
# Usage:
#   export ANTHROPIC_API_KEY=sk-...
#   ./tests/test-humanizer.sh
#   OLLAMA_MODEL=gemma4:27b ./tests/test-humanizer.sh "custom input text"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_FILE="${REPO_ROOT}/skills/humanizer/SKILL.md"
RESULTS_DIR="${REPO_ROOT}/tests/results"
OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5:latest}"
CLAUDE_MODEL="${CLAUDE_MODEL:-claude-sonnet-4-6}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

mkdir -p "$RESULTS_DIR"

DEFAULT_TEXT='AI-assisted security tools serve as an enduring testament to the
transformative potential of large language models in the cybersecurity landscape.
These groundbreaking solutions—nestled at the intersection of cutting-edge
research and practical application—are pivotal in helping organizations enhance
their security posture, highlighting the intricate interplay between automation
and human judgment. Additionally, they showcase the ability to identify
vulnerabilities, fostering a more robust and resilient infrastructure.'

INPUT_TEXT="${1:-$DEFAULT_TEXT}"

# Strip frontmatter — same body used for both Claude and Ollama
SYSTEM_PROMPT=$(awk 'BEGIN{n=0} /^---/{n++; next} n>=2{print}' "$SKILL_FILE")

echo "=== Humanizer comparison — ${TIMESTAMP} ==="
echo "Skill:   ${SKILL_FILE}"
echo "Claude:  ${CLAUDE_MODEL}"
echo "Ollama:  ${OLLAMA_MODEL}"
echo ""

# Claude API
echo "[1/2] Claude..."
CLAUDE_RESP=$(curl -s https://api.anthropic.com/v1/messages \
  -H "x-api-key: ${ANTHROPIC_API_KEY}" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d "$(jq -n \
    --arg m "$CLAUDE_MODEL" --arg s "$SYSTEM_PROMPT" \
    --arg u "Humanize this text:\n\n${INPUT_TEXT}" \
    '{model:$m, max_tokens:2048, system:$s,
      messages:[{role:"user",content:$u}]}')" \
  | jq -r '.content[0].text')

CLAUDE_OUT="${RESULTS_DIR}/humanizer-claude-${TIMESTAMP}.md"
printf "# Claude (%s)\n\n## Input\n%s\n\n## Output\n%s\n" \
  "$CLAUDE_MODEL" "$INPUT_TEXT" "$CLAUDE_RESP" > "$CLAUDE_OUT"
echo "  → ${CLAUDE_OUT}"

# Ollama
echo "[2/2] Ollama (${OLLAMA_MODEL})..."
OLLAMA_RESP=$(curl -s http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg m "$OLLAMA_MODEL" --arg s "$SYSTEM_PROMPT" \
    --arg u "Humanize this text:\n\n${INPUT_TEXT}" \
    '{model:$m, stream:false,
      messages:[{role:"system",content:$s},{role:"user",content:$u}]}')" \
  | jq -r '.message.content')

OLLAMA_OUT="${RESULTS_DIR}/humanizer-ollama-${OLLAMA_MODEL//[:\/]/-}-${TIMESTAMP}.md"
printf "# Ollama (%s)\n\n## Input\n%s\n\n## Output\n%s\n" \
  "$OLLAMA_MODEL" "$INPUT_TEXT" "$OLLAMA_RESP" > "$OLLAMA_OUT"
echo "  → ${OLLAMA_OUT}"

echo ""
echo "Quick quality check — known AI words remaining:"
echo "  Claude: $(echo "$CLAUDE_RESP"  | grep -oi 'testament\|pivotal\|underscore\|vibrant\|landscape\|foster\|showcase\|delve\|crucial' | wc -l)"
echo "  Ollama: $(echo "$OLLAMA_RESP"  | grep -oi 'testament\|pivotal\|underscore\|vibrant\|landscape\|foster\|showcase\|delve\|crucial' | wc -l)"
echo ""
echo "Diff:"
diff <(echo "$CLAUDE_RESP") <(echo "$OLLAMA_RESP") | head -40 || true
