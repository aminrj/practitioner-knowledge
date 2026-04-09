#!/usr/bin/env bash
# test-threat-model.sh — compare Claude API vs Ollama on the threat model skill.
# Both read the SAME SKILL.md.
#
# Usage:
#   export ANTHROPIC_API_KEY=sk-...
#   ./tests/test-threat-model.sh
#   OLLAMA_MODEL=gemma4:27b ./tests/test-threat-model.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_FILE="${REPO_ROOT}/skills/security-threat-model/SKILL.md"
RESULTS_DIR="${REPO_ROOT}/tests/results"
OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5:latest}"
CLAUDE_MODEL="${CLAUDE_MODEL:-claude-sonnet-4-6}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

mkdir -p "$RESULTS_DIR"

SCENARIO='DocuAssist — an MCP-enabled document management agent.
Components: agent.py (agentic loop, Qwen2.5-7B via LM Studio), mcp_file_manager.py
(FastMCP, tools: read_file, write_file, delete_file — no path sanitization),
mcp_web_search.py (fetch_url returns raw HTML including comments),
mcp_email_sender.py (send_email, no recipient allowlist).
Transport: stdio. No auth between agent and MCP servers.
User interface: POST /chat, no authentication.
Data: data/ directory with .env files, employee-records.csv, quarterly reports.'

SYSTEM_PROMPT=$(awk 'BEGIN{n=0} /^---/{n++; next} n>=2{print}' "$SKILL_FILE")
USER_MSG="Threat model this system. Skip scoping questions — assume: local deployment only, developer-only access, no multi-tenancy, employee CSV is the only PII.\n\n${SCENARIO}"

echo "=== Threat model comparison — ${TIMESTAMP} ==="
echo "Skill:   ${SKILL_FILE}"
echo "Claude:  ${CLAUDE_MODEL}"
echo "Ollama:  ${OLLAMA_MODEL}"
echo ""

echo "[1/2] Claude..."
CLAUDE_RESP=$(curl -s https://api.anthropic.com/v1/messages \
  -H "x-api-key: ${ANTHROPIC_API_KEY}" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d "$(jq -n \
    --arg m "$CLAUDE_MODEL" --arg s "$SYSTEM_PROMPT" --arg u "$USER_MSG" \
    '{model:$m, max_tokens:4096, system:$s,
      messages:[{role:"user",content:$u}]}')" \
  | jq -r '.content[0].text')

CLAUDE_OUT="${RESULTS_DIR}/threatmodel-claude-${TIMESTAMP}.md"
printf "# Threat model — Claude (%s)\n\n%s\n" "$CLAUDE_MODEL" "$CLAUDE_RESP" > "$CLAUDE_OUT"
echo "  → ${CLAUDE_OUT}"

echo "[2/2] Ollama (${OLLAMA_MODEL})..."
OLLAMA_RESP=$(curl -s http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg m "$OLLAMA_MODEL" --arg s "$SYSTEM_PROMPT" --arg u "$USER_MSG" \
    '{model:$m, stream:false,
      messages:[{role:"system",content:$s},{role:"user",content:$u}]}')" \
  | jq -r '.message.content')

OLLAMA_OUT="${RESULTS_DIR}/threatmodel-ollama-${OLLAMA_MODEL//[:\/]/-}-${TIMESTAMP}.md"
printf "# Threat model — Ollama (%s)\n\n%s\n" "$OLLAMA_MODEL" "$OLLAMA_RESP" > "$OLLAMA_OUT"
echo "  → ${OLLAMA_OUT}"

echo ""
echo "Quality check — key concepts covered:"
for term in "ASI0[12]\|goal hijack\|tool poison" "path traversal\|path sanitiz" \
            "trust boundar" "STRIDE" "exfiltrat\|send_email"; do
  C=$(echo "$CLAUDE_RESP" | grep -ic "$term" || true)
  O=$(echo "$OLLAMA_RESP" | grep -ic "$term" || true)
  echo "  '${term}':  Claude=${C}  Ollama=${O}"
done
