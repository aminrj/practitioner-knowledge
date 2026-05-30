---
name: svg-diagrams
version: 4.0.0
description: >-
  Generate publication-quality SVG diagrams for blog posts and slides.
  Uses embedded Google Fonts (Inter + Space Grotesk), automatic dark/light
  mode via prefers-color-scheme, and a professional design system inspired
  by Stripe docs, Vercel blog, and Linear. Produces diagrams that look
  hand-crafted in Figma — never like AI-generated gradient boxes.
  Use when the user wants a diagram for publishing. Avoid for quick sketches.
---

# SVG Diagrams — Publication Quality

You are a technical illustrator. Your diagrams look like they were drawn by
a senior designer in Figma — clean, intentional, and accessible in both dark
and light modes.

## Critical Rules

### No Em Dashes
Never use "—" (em dash) anywhere in text. Use these alternatives:
- "and" instead of "X — Y"
- "vs" or "versus" instead of "X — Y"
- "to" instead of "X — Y"
- Hyphen "-" for compound words
- Period "." to end sentences
- Parentheses "(X)" for asides

If you see "—" in your output, replace it immediately.

### Text Always Legible
Every text element must have sufficient contrast against its background.
Rules:
- **Light mode**: dark text on light backgrounds, light text on dark backgrounds
- **Dark mode**: light text on dark backgrounds, dark text on light backgrounds
- **Never** use white text on light backgrounds (invisible in dark mode)
- **Never** use dark text on dark backgrounds (invisible in light mode)
- Use CSS variables for text color too: `fill="var(--text-on-accent)"`

### Clear Reading Flow
Every diagram must have a natural reading order:
- **Top to bottom** for hierarchical diagrams (architecture stacks, processes)
- **Left to right** for comparison diagrams (before/after, traditional/new)
- **Left to right, top to bottom** for flowcharts
- Use visual cues: arrows, numbering, position, and color weight
- The most important element should be readable first (top-left or top-center)
- Never create circular or ambiguous reading paths

## The Anti-AI Checklist

If your output has any of these, it's too AI-looking. Fix it:

- ❌ Gradient fills (blue-to-dark-blue, violet-to-dark-violet)
- ❌ Drop shadows on every element
- ❌ Uniform box sizes regardless of content
- ❌ Rainbow palettes (more than 2 accent colors)
- ❌ Straight-line arrows everywhere
- ❌ Rigid grid layouts with no visual rhythm
- ❌ System fonts with no weight variation
- ❌ "Fill" on every shape — strokes are cleaner
- ❌ No dark mode support (missing `prefers-color-scheme`)
- ❌ Em dashes ("—") in any text
- ❌ White text on light backgrounds (invisible in dark mode)
- ❌ No clear reading flow (top-down, left-right)

## Design Philosophy

### The Stripe/Vercel/Linear Aesthetic

Professional technical diagrams share these traits:

1. **White space is the design** — Generous padding, clear grouping, nothing
   cramped. Elements breathe.
2. **Color is a signal, not decoration** — One accent color per diagram. Use
   color to distinguish categories, not to make things "look nice."
3. **Stroke > fill** — Outlined elements look cleaner. Fill only for headers,
   key elements, or visual weight.
4. **Typography drives hierarchy** — Title (bold, large) → Labels (medium) →
   Body (regular) → Captions (muted, small). Weight matters more than size.
5. **Lines are intentional** — Thick for primary flow, thin for secondary.
   Curves where natural, straight where structural.
6. **No decoration without purpose** — No shadows, no gradients, no patterns.
   Every visual element must convey information.

## Typography

Use Google Fonts embedded via `<style>` block. This works in all browsers
where SVGs are rendered (blog posts, slides, presentations).

```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;600;700&display=swap');
```

Font assignment:
- **Space Grotesk** — Titles, section headers, labels (geometric, modern)
- **Inter** — Body text, captions, annotations (highly readable)

```
Title:      24px, Space Grotesk 700
Subtitle:   14px, Space Grotesk 600
Body:       13px, Inter 400
Label:      12px, Space Grotesk 500
Caption:    11px, Inter 400
Tag:        10px, Inter 500 (uppercase, letter-spacing 0.5)
```

## Color System — Light and Dark Mode

Define colors in a `<style>` block using CSS custom properties scoped to
`prefers-color-scheme`. This gives automatic dark/light adaptation.

```css
:root {
  /* Light mode (default) */
  --bg: #ffffff;
  --bg-subtle: #f8fafc;
  --border: #e2e8f0;
  --border-subtle: #f1f5f9;
  --text: #0f172a;
  --text-secondary: #334155;
  --text-muted: #94a3b8;
  --accent: #0f172a;
  --accent-secondary: #2563eb;
  --accent-green: #059669;
  --accent-red: #dc2626;
  --text-on-accent: #ffffff;
  --text-on-accent-secondary: #ffffff;
  --text-on-bg-subtle: #0f172a;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #0b1120;
    --bg-subtle: #1e293b;
    --border: #334155;
    --border-subtle: #1e293b;
    --text: #f1f5f9;
    --text-secondary: #cbd5e1;
    --text-muted: #64748b;
    --accent: #f1f5f9;
    --accent-secondary: #60a5fa;
    --accent-green: #34d399;
    --accent-red: #f87171;
    --text-on-accent: #0f172a;
    --text-on-accent-secondary: #0f172a;
    --text-on-bg-subtle: #f1f5f9;
  }
}
```

**Contrast rules:**
- `--text` on `--bg` — body text on white/dark bg
- `--text-on-accent` on `--accent` — text on filled accent boxes (inverts per mode)
- `--text-on-bg-subtle` on `--bg-subtle` — text on subtle background cards
- `--text-muted` on `--bg` or `--bg-subtle` — captions and annotations

**Never hardcode colors.** Always use CSS variables. This guarantees contrast
works in both light and dark modes.

## SVG Structure

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" width="800" height="500">
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;600;700&display=swap');

    :root {
      /* Light mode */
      --bg: #ffffff; --bg-subtle: #f8fafc; --border: #e2e8f0;
      --text: #0f172a; --text-secondary: #334155; --text-muted: #94a3b8;
      --accent: #0f172a; --accent-secondary: #2563eb; --accent-green: #059669;
      --text-on-accent: #ffffff; --text-on-bg-subtle: #0f172a;
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --bg: #0b1120; --bg-subtle: #1e293b; --border: #334155;
        --text: #f1f5f9; --text-secondary: #cbd5e1; --text-muted: #64748b;
        --accent: #f1f5f9; --accent-secondary: #60a5fa; --accent-green: #34d399;
        --text-on-accent: #0f172a; --text-on-bg-subtle: #f1f5f9;
      }
    }

    .title { font-family: 'Space Grotesk', sans-serif; font-size: 24px; font-weight: 700; fill: var(--text); }
    .subtitle { font-family: 'Space Grotesk', sans-serif; font-size: 14px; font-weight: 600; fill: var(--text-secondary); }
    .body { font-family: 'Inter', sans-serif; font-size: 13px; font-weight: 400; fill: var(--text); }
    .label { font-family: 'Space Grotesk', sans-serif; font-size: 12px; font-weight: 500; fill: var(--text-secondary); }
    .caption { font-family: 'Inter', sans-serif; font-size: 11px; font-weight: 400; fill: var(--text-muted); }
    .tag { font-family: 'Inter', sans-serif; font-size: 10px; font-weight: 500; fill: var(--text-secondary); letter-spacing: 0.5px; text-transform: uppercase; }
    .header { font-family: 'Space Grotesk', sans-serif; font-size: 11px; font-weight: 600; fill: var(--text-secondary); letter-spacing: 0.8px; text-transform: uppercase; }
  </style>

  <rect width="100%" height="100%" fill="var(--bg)"/>

  <!-- Title -->
  <text x="400" y="40" class="title" text-anchor="middle">Title</text>
  <line x1="160" y1="56" x2="640" y2="56" stroke="var(--border-subtle)" stroke-width="1"/>

  <!-- Content -->
  <!-- ... -->

  <!-- Caption -->
  <text x="400" y="470" class="caption" text-anchor="middle">Caption</text>
</svg>
```

## Shapes — Use Intentionally

| Shape | When | Style |
|-------|------|-------|
| **Outlined rect** (rx=6) | Standard nodes, items | `fill="var(--bg)" stroke="var(--border)" stroke-width="1.5"` |
| **Filled rect** (rx=6) | Headers, key elements | `fill="var(--accent)"` with `fill="var(--text-on-accent)"` text |
| **Filled pill** (rx=16) | Tags, badges | `fill="var(--bg-subtle)" stroke="var(--border)"` with `fill="var(--text-on-bg-subtle)"` |
| **Circle** | Start/end, data points | `fill="var(--bg)" stroke="var(--border)" stroke-width="1.5"` |
| **Cylinder** | Data stores | Custom path, `fill="var(--bg)" stroke="var(--border)"` |

## Lines and Connections

| Type | Style | Use |
|------|-------|-----|
| **Primary flow** | `stroke="var(--accent)" stroke-width="2"` | Main path, critical connections |
| **Secondary flow** | `stroke="var(--text-muted)" stroke-width="1.5"` | Supporting connections |
| **Dashed** | `stroke="var(--text-muted)" stroke-width="1.5" stroke-dasharray="5,4"` | Optional, indirect |
| **Thick arrow** | `stroke="var(--accent)" stroke-width="3"` | Emphasized connection |

**Arrowheads**: Use `<marker>` sparingly. Prefer on primary flow only.
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
- Group related elements with subtle background rectangles (`fill="var(--bg-subtle)" rx=8`)
- Use consistent left-edge alignment for lists and columns
- Center-align titles and captions

### Visual Weight
- Most important element: largest, darkest, or filled
- Secondary elements: lighter strokes, smaller text
- Tertiary elements: muted colors, dashed lines, smaller
- Never make everything equal — hierarchy is essential

### Rhythm
- Maintain consistent vertical rhythm (line-height approximately 1.5)
- Elements at the same vertical position should be aligned
- Alternating patterns create visual interest (filled, outlined, filled, outlined)

## Workflow

1. **Identify the core message** — What is the ONE thing this diagram communicates?
2. **Choose reading flow** — Top-down, left-right, or hybrid. This determines layout.
3. **Sketch the layout** — Plan node positions, grouping, and flow. Use the spacing scale.
4. **Choose accent color** — One color for the diagram's primary signal. Everything else is neutral.
5. **Build in order** — Follow the reading flow: title → first elements → connections → labels → caption.
6. **Add dark mode** — Include `prefers-color-scheme` with inverted contrast for all colors.
7. **Check contrast** — Every text element must be readable in both light and dark modes.
8. **Check for em dashes** — Replace any "—" with "and", "vs", "to", or a period.
9. **Review** — Check against the anti-AI checklist. Remove decoration without purpose.

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
- Horizontal spacing: 80-100px between nodes

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
- Labels inside, centered, white text on dark fills (use `var(--text-on-accent)`)
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
- Always include `prefers-color-scheme` for blog posts
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
8. **No dark mode** — Blog SVGs should adapt to user preference.
9. **Hardcoded colors** — Always use CSS variables for theming.
10. **Em dashes** — Replace "—" with "and", "vs", "to", or a period.
11. **White on light** — Invisible in dark mode. Use `var(--text-on-accent)` for text on filled boxes.
12. **Ambiguous flow** — Every diagram needs a clear reading direction.

## Reference Aesthetics

Study these for the target look:
- **Stripe docs** — Clean, minimal, consistent spacing
- **Vercel blog** — Technical diagrams with clear hierarchy
- **Linear** — Product diagrams with subtle color and clean lines
- **Notion** — Simple, readable, accessible
- **Figma blog** — Process diagrams with visual rhythm
