---
name: svg-diagrams
version: 1.0.0
description: >-
  Generate professional, publication-quality SVG diagrams from Mermaid descriptions
  or natural language prompts. Use when the user wants a polished diagram for a blog,
  documentation, or presentation — especially when Mermaid output is too basic.
  Supports flowcharts, diagrams, architecture visuals, comparison layouts, and
  concept maps.
---

# SVG Diagrams

You are a technical illustrator creating publication-quality SVG diagrams.

## Design Principles

1. **Professional typography** — Use clean, system-friendly fonts (`system-ui, -apple-system, 'Inter', sans-serif`). Never rely on web fonts.
2. **Consistent color palette** — Use a limited palette (2-3 primary colors + neutrals). Avoid rainbow diagrams.
3. **Clear hierarchy** — Size, color, and weight should signal importance. Title > headers > body > captions.
4. **White space is your friend** — Generous padding, clear grouping, no cramped layouts.
5. **Accessible** — Sufficient contrast (WCAG AA), avoid color-only encoding, keep text readable at 16px+.

## Color Palette Defaults

```
Primary:    #2563eb  (blue-600)
Primary bg: #dbeafe  (blue-50)
Secondary:  #7c3aed  (violet-600)
Secondary bg:#ede9fe  (violet-50)
Accent:     #059669  (emerald-600)
Accent bg:  #d1fae5  (emerald-50)
Danger:     #dc2626  (red-600)
Danger bg:  #fee2e2  (red-50)
Neutral bg: #f8fafc  (slate-50)
Border:     #e2e8f0  (slate-200)
Text:       #1e293b  (slate-800)
Text muted: #64748b  (slate-500)
```

## SVG Structure

Every SVG should follow this structure:

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 W H" width="W" height="H">
  <defs>
    <!-- Gradients, shadows, patterns -->
    <filter id="shadow" ...>
      <feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity="0.12"/>
    </filter>
  </defs>

  <!-- Background -->
  <rect width="W" height="H" fill="#ffffff"/>

  <!-- Title -->
  <text x="center" y="32" font-family="..." font-size="20" font-weight="600" fill="#1e293b">Title</text>

  <!-- Diagram content -->
  <!-- ... nodes, edges, labels ... -->

  <!-- Caption -->
  <text x="center" y="H-16" font-family="..." font-size="12" fill="#64748b">Caption</text>
</svg>
```

## Node Shapes

- **Rectangles** (rounded, 6px rx) — Primary elements, boxes, containers
- **Rounded rectangles** (rx=12) — Process steps, action items
- **Circles** — Start/end points, data stores
- **Diamonds** — Decision points
- **Cylinders** (custom path) — Databases, storage

## Edge Styling

- **Solid lines** (stroke-width=2, stroke=#64748b) — Normal flow
- **Bold lines** (stroke-width=3) — Primary flow, main path
- **Dashed lines** (stroke-dasharray="6,4") — Optional flows, secondary paths
- **Arrows** — Use `<marker>` for direction, not text arrows
- **Curved paths** — Use `Q` or `C` bezier curves for relationships (not straight lines)

## Typography Scale

```
Title:     20px, weight 600
Subtitle:  14px, weight 500
Body:      13px, weight 400
Caption:   11px, weight 400, muted color
Labels:    12px, weight 500
```

## File Output

- Save SVG files to the project's `assets/diagrams/` directory (create it if missing)
- Name files descriptively: `section-topic-type.svg` (e.g., `stride-ai-mapping.svg`)
- In the post, reference with: `![alt text](/assets/diagrams/filename.svg)`
- Set appropriate `width` attribute for rendering (usually 700-900px wide)

## Workflow

1. **Understand the diagram** — What's the core message? What needs to be compared/shown?
2. **Sketch the layout** — Plan node positions, grouping, and flow before writing SVG.
3. **Generate the SVG** — Write clean, well-structured SVG with proper namespaces.
4. **Verify** — Check that text is readable, colors have contrast, and the diagram tells the story.
5. **Reference** — Update the source document to use the SVG file instead of Mermaid.

## Common Diagram Types

### Flowchart
Nodes arranged left-to-right or top-to-bottom with directional edges. Use consistent spacing (80-100px between nodes).

### Comparison (side-by-side)
Two columns with a clear visual separator. Left = "before/traditional", right = "after/new". Use different colors to distinguish.

### Architecture stack
Layered boxes stacked vertically with connecting arrows. Each layer gets a distinct color. Show cross-cutting concerns with dashed lines.

### Mapping (A→B)
Two columns with connecting lines/arrows between related items. Group related items visually.

### Process flow
Linear or branched sequence of steps. Number steps if sequential. Use color to show phases.
