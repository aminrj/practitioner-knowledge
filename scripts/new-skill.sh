#!/usr/bin/env bash
# new-skill.sh
# Scaffolds ONE SKILL.md in skills/<n>/. That's the only file needed.
#
# Usage: ./scripts/new-skill.sh <skill-name> "One-line description"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_NAME="${1:-}"
DESCRIPTION="${2:-}"

if [[ -z "$SKILL_NAME" || -z "$DESCRIPTION" ]]; then
  echo "Usage: $0 <skill-name> \"One-line description\""
  echo "Example: $0 newsletter-draft \"Draft an AI Security Intelligence issue\""
  exit 1
fi

SKILL_DIR="${REPO_ROOT}/skills/${SKILL_NAME}"

if [[ -d "$SKILL_DIR" ]]; then
  echo "Error: skill '${SKILL_NAME}' already exists at ${SKILL_DIR}"
  exit 1
fi

mkdir -p "$SKILL_DIR"

cat > "${SKILL_DIR}/SKILL.md" << EOF
---
name: ${SKILL_NAME}
version: 0.1.0
description: >-
  ${DESCRIPTION}
allowed-tools:
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

# $(echo "${SKILL_NAME}" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

[What this skill does and the mental model behind it.]

## When to use

[Explicit trigger conditions — specific enough that the skill loads correctly
and doesn't fire on unrelated requests.]

## When NOT to use

[Explicit anti-triggers.]

## Process

1. [Step one]
2. [Step two]
3. [Step three]

## Output format

[Expected output structure.]
EOF

echo "Created: ${SKILL_DIR}/SKILL.md"
echo ""
echo "This single file is used by:"
echo "  Claude Code  — auto-discovered via .claude/skills/ symlink"
echo "  Ollama       — ./scripts/inject-local.sh ${SKILL_NAME} \"your prompt\""
echo "  AnythingLLM  — ./scripts/sync-anythingllm.sh ${SKILL_NAME} <workspace-slug>"
echo ""
echo "Next: fill in SKILL.md, then run: ./scripts/validate-skills.sh"
