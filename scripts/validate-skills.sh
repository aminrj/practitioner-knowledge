#!/usr/bin/env bash
# validate-skills.sh
# Single-source validation — checks skills/ only.
# No more parity checks between two directories.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"
ERRORS=0

echo "=== practitioner-knowledge validation ==="
echo ""

# 1. Every skill directory has a SKILL.md
echo "[1/3] Checking SKILL.md presence..."
for skill_dir in "${SKILLS_DIR}"/*/; do
  skill_name=$(basename "$skill_dir")
  if [[ ! -f "${skill_dir}SKILL.md" ]]; then
    echo "  FAIL: ${skill_name}/ missing SKILL.md"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK:   ${skill_name}/SKILL.md"
  fi
done
echo ""

# 2. Every SKILL.md has required frontmatter fields
echo "[2/3] Checking SKILL.md frontmatter..."
for skill_file in "${SKILLS_DIR}"/*/SKILL.md; do
  skill_name=$(basename "$(dirname "$skill_file")")
  missing=""
  for field in "^name:" "^description:"; do
    if ! grep -q "$field" "$skill_file"; then
      missing="${missing} ${field}"
    fi
  done
  if [[ -n "$missing" ]]; then
    echo "  FAIL: ${skill_name} missing frontmatter:${missing}"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK:   ${skill_name}"
  fi
done
echo ""

# 3. Frontmatter strip test — body must be non-empty after stripping
echo "[3/3] Checking frontmatter strip yields non-empty body..."
for skill_file in "${SKILLS_DIR}"/*/SKILL.md; do
  skill_name=$(basename "$(dirname "$skill_file")")
  body=$(awk 'BEGIN{n=0} /^---/{n++; next} n>=2{print}' "$skill_file")
  body_lines=$(echo "$body" | grep -c '[^[:space:]]' || true)
  if [[ "$body_lines" -lt 5 ]]; then
    echo "  FAIL: ${skill_name} body too short after frontmatter strip (${body_lines} non-empty lines)"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK:   ${skill_name} (${body_lines} non-empty lines in body)"
  fi
done
echo ""

# Summary
if [[ $ERRORS -eq 0 ]]; then
  echo "=== All checks passed ==="
  exit 0
else
  echo "=== ${ERRORS} error(s) — fix before pushing ==="
  exit 1
fi
