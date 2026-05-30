---
name: svg-diagrams
version: 5.0.0
description: >-
  Generate publication-quality SVG diagrams for blog posts and slides.
  Uses IBM Plex Sans + IBM Plex Mono for a professional, technical look.
  Produces diagrams that look hand-crafted in Figma — never like AI-generated
  gradient boxes. Use when the user wants a diagram for publishing.
  Avoid for quick sketches.
---

# SVG Diagrams — Publication Quality

You are a technical illustrator. Your diagrams look like they were drawn by
a senior designer in Figma — clean, intentional, and readable.

## Critical Rules

### No Em Dashes
Never use "—" (em dash) anywhere in text. Use:
- "and" instead of "X — Y"
- "vs" or "versus" instead of "X — Y"
- Hyphen "-" for compound words
- Period "." to end sentences
- Parentheses "(X)" for asides

### Text Always Legible
Every text element must be readable against its background. Rules:
- **Outlined boxes** (white fill): use `fill="#0f172a"` (dark text)
- **Filled accent boxes** (dark fill): use `fill="#ffffff"` (white text)
- **Subtle background cards** (light gray fill): use `fill="#0f172a"` (dark text)
- **Captions and annotations**: use `fill="#64748b"` (muted gray)
- **Never** use light text on light backgrounds
- **Never** use dark text on dark backgrounds
- Always test: dark text on white, white text on dark — that's your baseline

### Clear Reading Flow
Every diagram must have a natural reading order:
- **Top to bottom** for stacks, processes, hierarchies
- **Left to right** for comparisons, mappings
- **Left to right, then down** for flowcharts
- Use arrows, numbering, and position to reinforce the flow
- The most important element should be readable first

### No Em Dashes, No Gradients, No Shadows
- No "—" (em dashes) — use "and", "vs", "to", or a period
- No gradients — solid fills only
- No drop shadows — borders instead

## Design Philosophy

Professional technical diagrams share these traits:

1. **White space is the design** — Generous padding, clear grouping, nothing cramped.
2. **Color is a signal** — One accent color per diagram. Use color to distinguish, not decorate.
3. **Stroke > fill** — Outlined elements look cleaner. Fill only for headers and key elements.
4. **Typography drives hierarchy** — Title (bold, large) → Labels (medium) → Body (regular) → Captions (muted).
5. **Lines are intentional** — Thick for primary flow, thin for secondary. Curves where natural.
6. **No decoration without purpose** — No shadows, no gradients, no patterns.

## Typography

Use IBM Plex Sans (body) and IBM Plex Mono (labels, tags) from Google Fonts.
IBM Plex was designed by IBM for technical documentation — it looks professional,
institutional, and purposeful. Not generic. Not "Inter."

```css
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@500;600&family=IBM+Plex+Sans:wght@400;500;600;700&display=swap');
```

Font assignment:
- **IBM Plex Sans 700** — Titles (bold, authoritative)
- **IBM Plex Sans 600** — Headers, section labels (medium-bold)
- **IBM Plex Sans 500** — Body text in boxes (medium)
- **IBM Plex Sans 400** — Captions, annotations (regular)
- **IBM Plex Mono 500** — Tags, codes, technical terms (monospaced)

```
Title:      24px, IBM Plex Sans 700
Header:     12px, IBM Plex Sans 600
Body:       14px, IBM Plex Sans 500
Caption:    12px, IBM Plex Sans 400
Tag:        10px, IBM Plex Mono 500 (uppercase, letter-spacing 0.5)
```

## Color System

Use a minimal palette. No CSS variables, no dark mode. Keep it simple.

```
Background:        #ffffff
Background subtle: #f8fafc
Border:            #e2e8f0
Border subtle:     #f1f5f9
Text:              #0f172a
Text secondary:    #334155
Text muted:        #64748b
Accent:            #0f172a
Accent blue:       #2563eb
Accent green:      #059669
```

**Rules:**
- One accent color per diagram (default: `#0f172a`)
- Accent blue for secondary emphasis
- Accent green for positive/flow indicators
- Text on white/outlined boxes: `#0f172a`
- Text on filled accent boxes: `#ffffff`
- Captions: `#64748b`

## SVG Structure

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" width="800" height="500">
  <style>
    @import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@500;600&family=IBM+Plex+Sans:wght@400;500;600;700&display=swap');

    .title { font-family: 'IBM Plex Sans', sans-serif; font-size: 24px; font-weight: 700; fill: #0f172a; }
    .header { font-family: 'IBM Plex Sans', sans-serif; font-size: 12px; font-weight: 600; fill: #334155; letter-spacing: 0.5px; text-transform: uppercase; }
    .body { font-family: 'IBM Plex Sans', sans-serif; font-size: 14px; font-weight: 500; fill: #0f172a; }
    .caption { font-family: 'IBM Plex Sans', sans-serif; font-size: 12px; font-weight: 400; fill: #64748b; }
    .tag { font-family: 'IBM Plex Mono', monospace; font-size: 10px; font-weight: 500; fill: #334155; letter-spacing: 0.5px; text-transform: uppercase; }
  </style>

  <rect width="800" height="500" fill="#ffffff"/>

  <!-- Title -->
  <text x="400" y="40" class="title" text-anchor="middle">Title</text>
  <line x1="160" y1="56" x2="640" y2="56" stroke="#f1f5f9" stroke-width="1"/>

  <!-- Content -->
  <!-- ... -->

  <!-- Caption -->
  <text x="400" y="470" class="caption" text-anchor="middle">Caption</text>
</svg>
```

## Shapes — Use Intentionally

| Shape | When | Style |
|-------|------|-------|
| **Outlined rect** (rx=6) | Standard nodes, items | `fill="#ffffff" stroke="#e2e8f0" stroke-width="1.5"`, text `#0f172a` |
| **Filled rect** (rx=6) | Headers, key elements | `fill="#0f172a"`, text `#ffffff` |
| **Filled pill** (rx=16) | Tags, badges | `fill="#f8fafc" stroke="#e2e8f0"`, text `#334155` |
| **Circle** | Start/end, data points | `fill="#ffffff" stroke="#e2e8f0" stroke-width="1.5"`, text `#0f172a` |
| **Cylinder** | Data stores | Custom path, `fill="#ffffff" stroke="#e2e8f0"`, text `#0f172a` |

## Lines and Connections

| Type | Style | Use |
|------|-------|-----|
| **Primary flow** | `stroke="#0f172a" stroke-width="2"` | Main path, critical connections |
| **Secondary flow** | `stroke="#64748b" stroke-width="1.5"` | Supporting connections |
| **Dashed** | `stroke="#64748b" stroke-width="1.5" stroke-dasharray="5,4"` | Optional, indirect |
| **Accent line** | `stroke="#2563eb" stroke-width="2"` | Emphasized connection |
| **Green line** | `stroke="#059669" stroke-width="2" stroke-dasharray="5,4"` | Positive/feedback flows |

**Arrowheads**: Use `<polygon>` for simple arrowheads. Prefer on primary flow only.
For secondary connections, use a simple line end or dot.

**Curves**: Use `Q` (quadratic) for simple curves, `C` (cubic) for complex.
Avoid sharp angles — even straight connections should feel intentional.

## Composition System

### Reading Flow Patterns

Choose ONE primary reading direction per diagram:

**Top-to-bottom** (architecture stacks, processes):
- Title at top
- Highest-level element at top
- Each subsequent layer below the previous
- Arrows point downward
- Caption at bottom

**Left-to-right** (comparisons, mappings):
- Title at top-center
- "Before" or "source" on the left
- "After" or "target" on the right
- Arrows point rightward
- Caption at bottom

**Left-to-right, top-to-bottom** (flowcharts):
- Start at top-left
- Flow moves right, then drops down
- Numbered steps reinforce order
- Caption at bottom

### Spacing Scale
Use multiples of 4px for consistency:

| Context | Spacing |
|---------|---------|
| Between nodes | 48-64px horizontal, 32-48px vertical |
| Between groups | 64-80px |
| Padding from viewBox edge | 40px minimum |
| Text-to-box edge (horizontal) | 16px |
| Text-to-box edge (vertical) | 8-10px |
| Between title and content | 20px |
| Between content and caption | 24px |

### Alignment
- Align elements on a grid, but never make the grid visible
- Group related elements with subtle background rectangles (`fill="#f8fafc" rx=8`)
- Use consistent left-edge alignment for lists and columns
- Center-align titles and captions

### Visual Weight
- Most important element: largest, darkest, or filled
- Secondary elements: lighter strokes, smaller text
- Tertiary elements: muted colors, dashed lines, smaller
- Never make everything equal — hierarchy is essential

## Workflow

1. **Identify the core message** — What is the ONE thing this diagram communicates?
2. **Choose reading flow** — Top-down, left-right, or hybrid. This determines layout.
3. **Sketch the layout** — Plan node positions, grouping, and flow. Use the spacing scale.
4. **Choose accent color** — One color for the diagram's primary signal. Everything else is neutral.
5. **Build in order** — Follow the reading flow: title → first elements → connections → labels → caption.
6. **Check contrast** — Dark text on white boxes, white text on dark boxes. Always legible.
7. **Check for em dashes** — Replace any "—" with "and", "vs", "to", or a period.
8. **Review** — Check against the anti-AI checklist. Remove decoration without purpose.

## Diagram Patterns

### Flowchart (left-to-right, top-to-bottom)
```
[1] ──→ [2] ──→ [3]
              ↘
               [4]
```
- Nodes: outlined rects (rx=6), 120-160px wide
- Arrows: primary flow `stroke-width=2`, arrowheads
- Numbered steps reinforce reading order
- Curved arrows for branches or feedback loops

### Comparison (left-to-right)
```
┌─────────────┐          ┌─────────────┐
│  Before     │          │  After      │
│  (left)     │          │  (right)    │
└─────────────┘          └─────────────┘
```
- Divider: dashed vertical line between columns
- Left side: neutral styling
- Right side: accent color for new/changed elements
- Caption explains the difference

### Architecture Stack (top-to-bottom)
```
┌─────────────────────┐  ← Layer 1 (accent color, top)
│  Top Layer          │
├─────────────────────┤
│  Layer 2            │
├─────────────────────┤
│  Layer 3            │
└─────────────────────┘  ← Layer N (lightest, bottom)
```
- Each layer: filled rect with accent color
- Labels inside, centered, white text on dark fills
- Cross-layer connections: dashed curved lines on the side
- Caption explains each layer

### Mapping (left-to-right)
```
[Item A] ──────── [Item X]
[Item B] ────┐    [Item Y]
             └──── [Item Z]
```
- Two columns, aligned
- Lines connect related items
- Different line styles for different relationship types
- Group related items with subtle background rectangles

### Process Flow (top-to-bottom)
```
[1]
 │
 ▼
[2]
 │
 ▼
[3]
```
- Numbered steps (circles with numbers)
- Color indicates phase
- Branching: dotted lines for alternative paths
- Vertical arrows reinforce downward flow

## File Output

- Save to `assets/diagrams/` in the target project
- Name: `topic-description.svg` (e.g., `stride-ai-mapping.svg`)
- Width: 700-900px for blog posts, wider (1000-1200px) for slides
- Set `width` and `height` attributes on the `<svg>` element
- Reference in markdown: `![description](/assets/diagrams/filename.svg)`

## Common Mistakes

1. **Gradients** — The #1 tell of AI-generated diagrams. Never use them.
2. **Drop shadows** — Flatten the design. Use borders instead.
3. **Uniform styling** — Every box the same looks generated. Vary size by importance.
4. **Too many colors** — 2-3 colors max. More looks like a rainbow.
5. **No hierarchy** — If everything is equally important, nothing is.
6. **Tight layouts** — Crowded diagrams are unreadable. Add padding.
7. **Missing context** — A diagram without title and caption is useless.
8. **Hardcoded wrong contrast** — White text on light backgrounds is invisible.
9. **Em dashes** — Replace "—" with "and", "vs", "to", or a period.
10. **Ambiguous flow** — Every diagram needs a clear reading direction.

## Reference Aesthetics

Study these for the target look:
- **Stripe docs** — Clean, minimal, consistent spacing
- **Vercel blog** — Technical diagrams with clear hierarchy
- **Linear** — Product diagrams with subtle color and clean lines
- **IBM Design** — IBM Plex fonts, institutional quality, technical clarity
