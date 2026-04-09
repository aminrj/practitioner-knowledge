#!/usr/bin/env bash
# install-skills.sh
# Symlinks every skill in skills/ into ~/.claude/skills/
# Run once after cloning, and again after adding a new skill.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="${REPO_ROOT}/skills"
SKILLS_DST="${HOME}/.claude/skills"

mkdir -p "$SKILLS_DST"

for skill_dir in "${SKILLS_SRC}"/*/; do
  skill_name=$(basename "$skill_dir")
  target="${SKILLS_DST}/${skill_name}"

  if [[ -L "$target" ]]; then
    rm "$target"
    echo "  updated: ${skill_name}"
  elif [[ -e "$target" ]]; then
    echo "  skip:    ${skill_name} (exists and is not a symlink — remove manually)"
    continue
  else
    echo "  added:   ${skill_name}"
  fi

  ln -s "${skill_dir%/}" "$target"
done

echo ""
echo "~/.claude/skills/ now contains:"
ls -la "$SKILLS_DST"
