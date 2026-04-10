# practitioner-knowledge

Personal knowledge system for AI security practitioner work.
One source of truth. Three consumers. Zero duplication.

## How it works

Each skill lives in exactly **one file**: `skills/<name>/SKILL.md`.

That single file is consumed three ways:

| Consumer | Mechanism | What it reads |
|---|---|---|
| Claude Code | Auto-discovery via `.claude/skills/` symlink | Full SKILL.md (YAML + body) |
| Ollama / Roo Code | `scripts/inject-local.sh` strips frontmatter | Body only, as system prompt |
| AnythingLLM | `scripts/sync-anythingllm.sh` strips frontmatter | Body pushed to workspace via API |

Edit `skills/humanizer/SKILL.md` once — it's live everywhere.

## Structure

```
skills/                        ← SINGLE SOURCE OF TRUTH
  humanizer/
    SKILL.md                   ← the skill (Claude sees it + Ollama gets body)
  security-threat-model/
    SKILL.md
    references/
      prompt-template.md

.claude/
  skills -> ../skills          ← symlink; Claude Code auto-discovers skills/

scripts/
  inject-local.sh              ← strip frontmatter → Ollama
  sync-anythingllm.sh          ← strip frontmatter → AnythingLLM REST API
  new-skill.sh                 ← scaffold a single SKILL.md
  validate-skills.sh           ← check skills/ integrity

tests/
  test-humanizer.sh            ← Claude vs Ollama (reads skills/ directly)
  test-threat-model.sh
  results/                     ← gitignored outputs

.github/workflows/validate.yml ← CI: runs validate-skills.sh
```

## Quick start

```bash
# Clone and install globally for Claude Code
git clone git@github.com:aminrj/practitioner-knowledge.git
cd practitioner-knowledge
ln -s "$(pwd)/skills" ~/.claude/skills/practitioner-knowledge
# Claude Code now auto-discovers all skills in ~/.claude/skills/practitioner-knowledge/

# Run a skill against Ollama
./scripts/inject-local.sh humanizer "Humanize this text: [paste text]"
OLLAMA_MODEL=gemma4:27b ./scripts/inject-local.sh humanizer "Humanize: [text]"

# Sync a skill to AnythingLLM workspace
export ANYTHING_API_KEY=your-key
./scripts/sync-anythingllm.sh humanizer humanizer-workspace
./scripts/sync-anythingllm.sh --all    # push all skills (slugs = skill names)

# Compare Claude vs local model
export ANTHROPIC_API_KEY=sk-...
./tests/test-humanizer.sh
OLLAMA_MODEL=gemma4:27b ./tests/test-humanizer.sh

# Add a new skill (creates ONE file)
./scripts/new-skill.sh newsletter-draft "Draft an AI Security Intelligence issue"

# Validate
./scripts/validate-skills.sh
```

## Seed skills — provenance

| Skill | Source | Version |
|---|---|---|
| humanizer | [blader/humanizer](https://github.com/blader/humanizer), vetted by [trailofbits/skills-curated](https://github.com/trailofbits/skills-curated) | 2.3.0 |
| security-threat-model | [openai/skills](https://github.com/openai/skills), ported by trailofbits/skills-curated, extended with OWASP ASI01–ASI10 | 1.0.0 |

## Frontmatter strip — how it works

The YAML frontmatter (`name`, `description`, `allowed-tools`) is what Claude
Code's discovery mechanism reads. The Markdown body below the second `---` is
the actual instruction set — the system prompt.

```bash
# Strip everything between first --- and second ---, keep the rest
awk 'BEGIN{n=0} /^---/{n++; next} n>=2{print}' skills/humanizer/SKILL.md
```

The body is long enough (~480 lines for humanizer) that the 8-line frontmatter
has no meaningful effect if left in for capable models. But stripping it keeps
the injection clean for all model sizes.
