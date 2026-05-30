---
name: svg-diagrams
version: 3.0.0
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
  }
}
```

**Rules:**
- Use CSS variables everywhere (`fill="var(--bg)"`, `stroke="var(--border)"`)
- Never hardcode colors in SVG attributes
- One accent color per diagram (default: `--accent`)
- Semantic colors for status: green (positive), red (negative), blue (info)
- In dark mode, invert: dark backgrounds, light text, brighter accents

## SVG Structure

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" width="800" height="500">
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;600;700&display=swap');

    :root {
      /* Light mode colors */
      --bg: #ffffff; --bg-subtle: #f8fafc; --border: #e2e8f0;
      --text: #0f172a; --text-secondary: #334155; --text-muted: #94a3b8;
      --accent: #0f172a; --accent-secondary: #2563eb; --accent-green: #059669;
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --bg: #0b1120; --bg-subtle: #1e293b; --border: #334155;
        --text: #f1f5f9; --text-secondary: #cbd5e1; --text-muted: #64748b;
        --accent: #f1f5f9; --accent-secondary: #60a5fa; --accent-green: #34d399;
      }
    }

    .title { font-family: 'Space Grotesk', sans-serif; font-size: 24px; font-weight: 700; fill: var(--text); }
    .subtitle { font-family: 'Space Grotesk', sans-serif; font-size: 14px; font-weight: 600; fill: var(--text-secondary); }
    .body { font-family: 'Inter', sans-serif; font-size: 13px; font-weight: 400; fill: var(--text); }
    .label { font-family: 'Space Grotesk', sans-serif; font-size: 12px; font-weight: 500; fill: var(--text-secondary); }
    .caption { font-family: 'Inter', sans-serif; font-size: 11px; font-weight: 400; fill: var(--text-muted); }
    .tag { font-family: 'Inter', sans-serif; font-size: 10px; font-weight: 500; fill: var(--text-secondary); letter-spacing: 0.5px; text-transform: uppercase; }
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
| **Filled rect** (rx=6) | Headers, key elements | `fill="var(--accent)"` with white text |
| **Filled pill** (rx=16) | Tags, badges | `fill="var(--bg-subtle)" stroke="var(--border)"` |
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
- Maintain consistent vertical rhythm (line-height ≈ 1.5)
- Elements at the same vertical position should be aligned
- Alternating patterns create visual interest (filled, outlined, filled, outlined)

## Workflow

1. **Identify the core message** — What is the ONE thing this diagram communicates?
2. **Sketch the layout** — Plan node positions, grouping, and flow. Use the spacing scale.
3. **Choose accent color** — One color for the diagram's primary signal. Everything else is neutral.
4. **Build in order** — Title → headers → nodes → connections → labels → caption.
5. **Add dark mode** — If the diagram is for a blog, always include `prefers-color-scheme`.
6. **Review** — Check against the anti-AI checklist. Remove decoration without purpose.

## Diagram Patterns

### Flowchart
```
[Node A] ──→ [Node B] ──→ [Node C]
```
- Nodes: outlined rects (rx=6), 120-160px wide
- Arrows: primary flow `stroke-width=2`, arrowheads
- Curved arrows for feedback loops
- Horizontal spacing: 80-100px between nodes

### Comparison (side-by-side)
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

### Architecture Stack
```
┌─────────────────────┐  ← Layer 1 (accent color)
│  Top Layer          │
├─────────────────────┤
│  Layer 2            │
├─────────────────────┤
│  Layer 3            │
└─────────────────────┘  ← Layer N (bg-subtle)
```
- Each layer: filled rect with accent color
- Labels inside, centered, white text on dark fills
- Cross-layer connections: dashed curved lines on the side

### Mapping (A→B)
```
[Item A] ──────── [Item X]
[Item B] ────┐    [Item Y]
             └──── [Item Z]
```
- Two columns, aligned
- Lines connect related items
- Different line styles for different relationship types
- Group related items with subtle background rectangles

### Process Flow
```
[1] ──→ [2] ──→ [3] ──→ [4]
```
- Numbered steps (circles with numbers)
- Color indicates phase
- Branching: dotted lines for alternative paths

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
10. **Over-engineering** — A simple outlined box beats a complex shaped element.

## Reference Aesthetics

Study these for the target look:
- **Stripe docs** — Clean, minimal, consistent spacing
- **Vercel blog** — Technical diagrams with clear hierarchy
- **Linear** — Product diagrams with subtle color and clean lines
- **Notion** — Simple, readable, accessible
- **Figma blog** — Process diagrams with visual rhythm
