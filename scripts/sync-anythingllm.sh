#!/usr/bin/env bash
# sync-anythingllm.sh
# Reads a SKILL.md, strips frontmatter, and pushes the body as the system
# prompt of an AnythingLLM workspace via the REST API.
#
# One command to push a skill update to AnythingLLM after editing SKILL.md.
#
# Usage:
#   export ANYTHING_API_KEY=your-key
#   ./scripts/sync-anythingllm.sh humanizer my-workspace-slug
#   ./scripts/sync-anythingllm.sh security-threat-model threat-modeling
#
# Or push all skills at once (each skill maps to same-named workspace slug):
#   ./scripts/sync-anythingllm.sh --all
#
# Find your workspace slug in AnythingLLM: Settings > Workspaces > the URL slug
# Find your API key: AnythingLLM > Settings > Developer API

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ANYTHING_URL="${ANYTHING_URL:-http://localhost:3001}"
ANYTHING_API_KEY="${ANYTHING_API_KEY:-}"

if [[ -z "$ANYTHING_API_KEY" ]]; then
  echo "Error: ANYTHING_API_KEY not set"
  echo "Export it: export ANYTHING_API_KEY=your-api-key"
  echo "(Find it in AnythingLLM > Settings > Developer API)"
  exit 1
fi

push_skill() {
  local domain="$1"
  local workspace_slug="$2"
  local skill_file="${REPO_ROOT}/skills/${domain}/SKILL.md"

  if [[ ! -f "$skill_file" ]]; then
    echo "  SKIP: ${domain} — no SKILL.md at ${skill_file}"
    return
  fi

  # Strip YAML frontmatter — same logic as inject-local.sh
  local body
  body=$(awk 'BEGIN{n=0} /^---/{n++; next} n>=2{print}' "$skill_file")

  if [[ -z "$body" ]]; then
    echo "  WARN: ${domain} — frontmatter strip returned empty, using full file"
    body=$(cat "$skill_file")
  fi

  local response
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "${ANYTHING_URL}/api/v1/workspace/${workspace_slug}/update" \
    -H "Authorization: Bearer ${ANYTHING_API_KEY}" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg prompt "$body" '{openAiPrompt: $prompt}')")

  if [[ "$response" == "200" ]]; then
    echo "  OK:   ${domain} → workspace '${workspace_slug}'"
  else
    echo "  FAIL: ${domain} → workspace '${workspace_slug}' (HTTP ${response})"
    echo "        Check: slug exists, API key is valid"
  fi
}

# ── Push all skills (expects workspace slugs = skill names) ──────────────────
if [[ "${1:-}" == "--all" ]]; then
  echo "Syncing all skills to AnythingLLM (${ANYTHING_URL})..."
  echo "Workspace slugs assumed to match skill names."
  echo ""
  for skill_dir in "${REPO_ROOT}/skills"/*/; do
    domain=$(basename "$skill_dir")
    push_skill "$domain" "$domain"
  done
  echo ""
  echo "Done. If a workspace slug differs from the skill name, push individually:"
  echo "  $0 <skill-name> <workspace-slug>"
  exit 0
fi

# ── Push single skill ─────────────────────────────────────────────────────────
DOMAIN="${1:-}"
WORKSPACE_SLUG="${2:-$DOMAIN}"

if [[ -z "$DOMAIN" ]]; then
  echo "Usage:"
  echo "  $0 <skill-name> [workspace-slug]"
  echo "  $0 --all"
  echo ""
  echo "Available skills:"
  ls "${REPO_ROOT}/skills/" | sed 's/^/  /'
  exit 1
fi

echo "Syncing '${DOMAIN}' to AnythingLLM workspace '${WORKSPACE_SLUG}'..."
push_skill "$DOMAIN" "$WORKSPACE_SLUG"
