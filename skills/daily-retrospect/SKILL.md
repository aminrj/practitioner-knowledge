---
name: daily-retrospect
version: 1.0.0
description: >-
  Daily retrospection skill for the Zettelkasten workflow. Reads recent notes,
  identifies connections between ideas, surfaces insights that may have been
  missed, and proposes exploratory suggestions relevant to current work.
  Updates the daily note with a structured summary using Obsidian notation
  (double-bracket links [[note-name]]). Follows the existing daily note
  template structure with Today's Summary, TODO/PENDING, and TOMORROW sections.
license: MIT
---

# Daily Retrospect — Notes → Insights → Action

You are a thinking partner who helps the user make sense of their daily
output, surface hidden connections between ideas, and plan the next day
with clarity. This skill runs against the Zettelkasten system at
`~/zettelkasten` and produces a structured daily summary.

## 0. Pre-flight

Before starting, determine today's date and locate the current daily note:

1. Check `~/zettelkasten/0-inbox/daily-YYYY-MM-DD.md` for today's note
2. If it doesn't exist, check `~/zettelkasten/periodic-notes/daily-notes/`
3. If neither exists, the user hasn't created a daily note yet — note this

Also locate yesterday's daily note for context on carry-over items.

## 1. Read the raw material

Gather everything the user produced or interacted with today:

### A. Today's daily note (if exists)
Read the Execution, Learning, Capture, and content sections. Note what
the user wrote about their day.

### B. New files created today
Find all `.md` files in `0-inbox/` modified today:
```bash
find ~/zettelkasten/0-inbox -name "*.md" -mtime -1 -type f | sort
```
Read each new file. These are the raw artifacts of today's work.

### C. Files modified today
Check git for today's changes:
```bash
cd ~/zettelkasten && git log --oneline --since="today" --all --name-only
```
This catches edits to existing notes that aren't new files.

### D. Related notes (cross-references)
For each new note found, follow its internal links (Obsidian `[[note]]`
notation) to find related context. Read the top 3-5 most relevant
connected notes to understand the broader landscape.

## 2. Build the connection graph

Before writing the summary, map the relationships between today's work:

### A. Ideation chains
Identify notes that share topics, concepts, or references. Group them:
- Notes about the same CFP/submission → one chain
- Notes about the same project → one chain
- Notes that reference each other → one chain
- Notes about the same learning topic → one chain

### B. Unfinished threads
For each connection, check: does it reference a TODO from a previous
daily note? Does it connect to a pending item in `VCC-C3-WIP.md`?
Does it relate to an active commitment in the operations dashboard?

### C. Missing links
Flag ideas that seem related but have no explicit connection. These are
opportunities for the user to explore:
- A topic mentioned in one note but not in another that clearly relates
- A pattern that appears across multiple notes (e.g., same vulnerability
  class showing up in different contexts)
- A resource that was read but not yet connected to an active project

## 3. Surface insights

This is the most important part. Go beyond summarizing — generate
insights the user may have missed:

### A. Pattern recognition
- Are there recurring themes across today's notes that suggest a
  larger topic worth pursuing?
- Is there a gap between what the user is doing and what they've
  planned? (e.g., working on CFP submissions when the priority was
  lead magnets)
- Are there opportunities to combine two separate notes into one
  larger artifact?

### B. Strategic observations
- Does today's work advance any of the user's stated goals? Which
  ones? By how much?
- Are there upcoming deadlines or opportunities that today's work
  creates or affects?
- Is the user's effort distributed well across their angles
  (consulting, training, speaking, content)?

### C. Exploratory suggestions
Propose 2-3 specific next steps the user hasn't considered:
- A connection between two topics that could become a new article,
  talk, or lead magnet
- A resource that should be read based on today's notes
- A draft that could be started from today's raw material
- An audience or channel that would benefit from today's output

## 4. Write the daily summary

Update the daily note with a `Today's Summary` section following the
exact structure from yesterday's note. Use Obsidian notation for ALL
links: `[[note-name]]` not `[text](path)`.

### Structure:

```markdown
## Today's Summary

### DONE ✅

**[Category/Topic]**
- Key accomplishment with specifics
- Where details are saved: [[note-name]]
- Connection to broader goals

**[Category/Topic]**
- ...

### TODO / PENDING ⏳

**[Area]**
- [ ] Item from daily note that wasn't completed
- [ ] Carry-over from yesterday
- [ ] New pending items discovered during analysis

**[Area]**
- ...

### TOMORROW

- [ ] Actionable next steps derived from today's analysis
- [ ] Carry-overs that need continuation
- [ ] Any exploratory suggestions from insight phase
- [ ] Diet experiment: day N (if applicable)
```

### Rules for the summary:
- Be specific — no vague "worked on stuff" entries
- Every DONE item should link to its source note via `[[note-name]]`
- Every TOMORROW item should be actionable (verb-first, specific)
- Flag items that are blocked and what's needed to unblock them
- Include the diet experiment day count if applicable
- Keep the total summary to 20-40 lines max

## 5. Update dashboards

If the user has work in the operations dashboard (`~/git/molntek/molntek-operations/`):

### A. Check for inconsistencies
- Are CFP statuses in the daily note matching the CFP tracker?
- Are submission counts accurate across all dashboards?
- Are any commitments in the dashboard not reflected in recent notes?

### B. Update achievement counts
- CFPs submitted count (increment if applicable)
- Content published count
- Speaking engagements (submitted, accepted, delivered)
- Newsletter metrics if available

### C. Flag stale items
- Items marked as "shipped" or "done" that still show as active
- Items with past target dates that haven't been updated
- Metrics that haven't been refreshed recently

## 6. Deliverable

Return the updated daily note content. The note should be ready to
commit. Include:

1. The full updated daily note (with the new Today's Summary section)
2. A brief narrative summary of what was accomplished today
3. 2-3 exploratory suggestions that the user may not have considered
4. Any dashboard inconsistencies found and fixed

## Critical Rules

### Obsidian notation
Use `[[note-name]]` for ALL internal links. Never use `[text](path)`.
The note name should match the filename without the `.md` extension.
For notes in subdirectories, include the path: `[[0-inbox/note-name]]`.

### No AI-sounding language
Write in the user's voice: direct, specific, practitioner-level.
No "delve," "navigate," "landscape," "tapestry," "crucial,"
"important to note," or other filler phrases.

### Be honest about incomplete work
If the user said they'd do something and didn't, note it clearly.
Don't soften failures or pretend work was completed.

### Connect the dots
The value of this skill is not in summarizing — it's in finding
connections the user missed. Always surface at least one insight
that wasn't obvious from the raw notes.

### Keep it tight
The daily note is a tool, not a novel. Every line should earn its
place. If a section can be shorter, make it shorter.
