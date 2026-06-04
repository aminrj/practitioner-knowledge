---
name: svg-diagrams
version: 5.1.0
description: >-
  Generate publication-quality SVG diagrams for blog posts and slides.
  Uses system fonts (-apple-system, Segoe UI, Roboto) for zero-dependency rendering.
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

### Text Always Legible — ABSOLUTE RULE
Every text element must be readable against its background. This is non-negotiable.

**Only two patterns allowed for boxes:**
- **Outlined boxes**: `fill="#ffffff"` background + `fill="#0f172a"` text (dark on white)
- **Filled boxes**: `fill="#0f172a"` background + `fill="#ffffff"` text (white on dark)

> **SVG CSS cascade rule — root fix**: Never put `fill` inside a CSS class. Keep classes for
> fonts only (family, size, weight). Always put `fill` as a presentation attribute directly on
> each `<text>` element.
>
> When a CSS class sets `fill: #0f172a`, that class rule silently beats any `fill="..."` attribute
> you add later — so white text on a dark box becomes invisible. Removing `fill` from classes
> eliminates the conflict entirely: `fill="#ffffff"` on the element just works.
>
> ```xml
> <!-- WRONG — fill in class silently overrides the attribute -->
> .body { font-size: 13px; font-weight: 500; fill: #0f172a; }
> <text class="body" fill="#ffffff">invisible on dark box</text>
>
> <!-- CORRECT — fill only on elements, classes are font-only -->
> .body { font-size: 13px; font-weight: 500; }
> <text class="body" fill="#ffffff">visible white text</text>
> <text class="body" fill="#0f172a">visible dark text</text>
> ```

**Never use mid-tone fills** (like `#64748b`, `#94a3b8`, `#334155`, `#475569`) because:
- White text on `#64748b` is unreadable
- Dark text on `#94a3b8` is unreadable
- Any mid-tone with either text color risks poor contrast

**If you need visual hierarchy, use:**
- Filled vs outlined (not different fill colors)
- Line weight (thick vs thin strokes)
- Position (top = more important)
- Accent color on borders only

**Other text:**
- Captions/annotations: `fill="#64748b"` on `#ffffff` background
- Subtle card labels: `fill="#334155"` on `#f8fafc` background
- Arrowheads: `fill="#64748b"` on `#ffffff` background

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

Use a robust system font stack. Google Fonts `@import` inside SVG `<style>` is unreliable — many browsers reject it, causing all styles to be ignored. Use system fonts instead.

```css
font-family: -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
```

This chain gives you:
- **macOS/iOS**: San Francisco (Apple's system font) — clean, modern, professional
- **Windows**: Segoe UI — Microsoft's system font, highly readable
- **Linux**: Roboto or system default — clean, modern
- **Fallback**: generic sans-serif

Font assignment:
- **700** — Titles (bold, authoritative)
- **600** — Headers, section labels (medium-bold)
- **500** — Body text in boxes (medium)
- **400** — Captions, annotations (regular)

Size scale:
```
Title:   24px / weight 700
Header:  12px / weight 600 / uppercase / letter-spacing 0.5px
Body:    14px / weight 500
Sub:     12px / weight 400
Caption: 12px / weight 400
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
    /* Classes encode ONLY font properties — never fill.
       Put fill as an attribute on each <text> element so colors
       are explicit and the SVG cascade cannot silently override them. */
    .title   { font-family: -apple-system,'Segoe UI',Roboto,Helvetica,Arial,sans-serif; font-size:24px; font-weight:700; }
    .header  { font-family: -apple-system,'Segoe UI',Roboto,Helvetica,Arial,sans-serif; font-size:12px; font-weight:600; letter-spacing:0.5px; text-transform:uppercase; }
    .body    { font-family: -apple-system,'Segoe UI',Roboto,Helvetica,Arial,sans-serif; font-size:14px; font-weight:500; }
    .sub     { font-family: -apple-system,'Segoe UI',Roboto,Helvetica,Arial,sans-serif; font-size:12px; font-weight:400; }
    .caption { font-family: -apple-system,'Segoe UI',Roboto,Helvetica,Arial,sans-serif; font-size:12px; font-weight:400; }
  </style>

  <rect width="800" height="500" fill="#ffffff"/>

  <!-- Title: fill attribute, not class -->
  <text x="400" y="40" class="title" fill="#0f172a" text-anchor="middle">Title</text>
  <line x1="160" y1="56" x2="640" y2="56" stroke="#f1f5f9" stroke-width="1"/>

  <!-- Dark-background box: fill="#ffffff" works because no class competes -->
  <rect x="300" y="80" width="200" height="44" rx="8" fill="#0f172a"/>
  <text x="400" y="107" class="body" fill="#ffffff" text-anchor="middle">Label on dark box</text>

  <!-- Light-background box -->
  <rect x="300" y="160" width="200" height="44" rx="8" fill="#ffffff" stroke="#e2e8f0" stroke-width="1.5"/>
  <text x="400" y="187" class="body" fill="#0f172a" text-anchor="middle">Label on light box</text>

  <!-- Caption -->
  <text x="400" y="470" class="caption" fill="#64748b" text-anchor="middle">Caption</text>
</svg>
```

**No Google Fonts.** No `@import`. No `@font-face`. System fonts only. This guarantees the SVG renders everywhere without external dependencies.

## XML Safety — ABSOLUTE RULE

SVG is XML. Any `<`, `>`, or `&` inside a `<style>` block or XML comment breaks the parser silently or throws a parse error. This causes the entire SVG to fail to render.

**Never write tag names like `<text>` or `<rect>` inside CSS comments or XML comments.**
Write "text element" or "rect element" instead.

```xml
<!-- WRONG: breaks the XML parser -->
<style>
  /* fill is set on each <text> element */
</style>

<!-- CORRECT -->
<style>
  /* fill is set on each text element */
</style>
```

Also avoid em dashes (`—`) and Unicode box-drawing characters (`═══`) in comments. Use plain ASCII only: hyphens, equals signs, pipes.

## Shapes — Use Intentionally

| Shape | When | Style |
|-------|------|-------|
| **Outlined rect** (rx=6) | Standard nodes, items | `fill="#ffffff" stroke="#e2e8f0" stroke-width="1.5"`, text `#0f172a` |
| **Filled rect** (rx=6) | Headers, key elements ONLY | `fill="#0f172a"`, text `fill="#ffffff"` as attribute (works because classes carry no fill) |
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

### Node Sizing — Compute Before You Code

**MANDATORY RULE: Never guess a box height. Calculate it from the text content it must contain.**

Every node box has a fixed anatomy. Use this formula:

```
box_height = top_pad + badge_h + badge_gap + (title_lines × title_lh) + (body_lines × body_lh) + bottom_pad

  top_pad    = 10
  badge_h    = 14   (the badge/step-label rect)
  badge_gap  = 10   (space between badge bottom and first title baseline)
  title_lh   = 18   (14px font + 4px leading)
  body_lh    = 16   (12px font + 4px leading)
  bottom_pad = 12
```

**Reference heights by content shape:**

| Badge | Title lines | Body lines | Height |
|-------|-------------|------------|--------|
| yes   | 1           | 0          | 64px   |
| yes   | 1           | 1          | 80px   |
| yes   | 1           | 2          | 96px   |
| yes   | 2           | 0          | 82px   |
| yes   | 2           | 1          | 98px   |
| yes   | 2           | 2          | 114px  |

**Then derive every y-coordinate from the box top:**

```
Let T = box rect y

badge_rect.y      = T + 10
badge_text.y      = T + 10 + 11                     (baseline inside 14px badge)
title_line_1.y    = T + 10 + 14 + 10 + 14 = T + 48  (badge bottom + gap + font ascent)
title_line_2.y    = title_line_1.y + 18
body_line_1.y     = title_last.y + 8 + 12            (gap + font ascent)
body_line_2.y     = body_line_1.y + 16
box_bottom        = T + box_height                   (all text must have baseline < box_bottom - 4)
```

**Example — badge + 2 title lines + 2 body lines, T=80:**

```
box_height   = 10 + 14 + 10 + 36 + 32 + 12 = 114px
badge_rect.y = 90, badge_text.y = 101
title_1.y    = 128, title_2.y = 146
body_1.y     = 166, body_2.y = 182
box_bottom   = 194   (body_2 baseline 182 < 190 — OK)
```

**For horizontal step chains with 5+ nodes:** the combined width of boxes plus gaps can exceed the canvas. Calculate the total span first:
`total = N_boxes × box_width + (N_boxes - 1) × gap`

If `total > canvas_width - 80` (allowing margins), either widen the canvas, reduce body lines inside boxes, or switch to a 2-row layout. Never shrink boxes until the text no longer fits.

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

## Validation Script

After saving the SVG, run this script to catch layout bugs automatically.
It checks: boxes in-bounds, no accidental overlaps, and no text bleeding outside its box.

```bash
python3 - <<'EOF' path/to/diagram.svg
import xml.etree.ElementTree as ET, sys, re

def validate(path):
    # Check for XML-unsafe content in style/comments before parsing
    with open(path, encoding='utf-8') as f:
        raw = f.read()
    style_m = re.search(r'<style>(.*?)</style>', raw, re.DOTALL)
    if style_m and ('<' in style_m.group(1) or '>' in style_m.group(1)):
        print(f'FAIL: XML-unsafe < or > inside <style> block -- will break SVG parser')
        sys.exit(1)

    root = ET.parse(path).getroot()
    W = float(root.get('width', 0))
    H = float(root.get('height', 0))
    ns = 'http://www.w3.org/2000/svg'

    # Collect content boxes (skip background and tiny badges)
    boxes = []
    for r in root.iter(f'{{{ns}}}rect'):
        x = float(r.get('x', 0))
        y = float(r.get('y', 0))
        w = float(r.get('width', 0))
        h = float(r.get('height', 0))
        if w >= W * 0.9 and h >= H * 0.9:
            continue  # background
        if w < 40 or h < 20:
            continue  # badge/decoration
        label = r.get('id') or f'rect@{x},{y}'
        boxes.append((x, y, w, h, label))

    issues = []

    # 1. Out-of-bounds check
    for (x1, y1, w1, h1, l1) in boxes:
        if x1 < 0 or y1 < 0 or x1 + w1 > W or y1 + h1 > H:
            issues.append(f'OUT OF BOUNDS  {l1}  [{x1},{y1} to {x1+w1},{y1+h1}]  canvas={W}x{H}')

    # 2. Accidental overlap check (skip intentional badge-in-box: area ratio < 0.15)
    for i, (x1, y1, w1, h1, l1) in enumerate(boxes):
        for x2, y2, w2, h2, l2 in boxes[i+1:]:
            if min(w1*h1, w2*h2) / max(w1*h1, w2*h2) < 0.15:
                continue
            if x1 < x2+w2 and x1+w1 > x2 and y1 < y2+h2 and y1+h1 > y2:
                issues.append(
                    f'OVERLAP  {l1}[{x1},{y1},{x1+w1},{y1+h1}]'
                    f'  vs  {l2}[{x2},{y2},{x2+w2},{y2+h2}]'
                )

    # 3. Text-overflow check: text baseline below its box bottom
    #    For each text element, find the smallest enclosing box (by x-range).
    #    Allow 4px below box bottom for descenders; flag anything more.
    DESCENDER_SLACK = 4
    for t in root.iter(f'{{{ns}}}text'):
        tx = float(t.get('x', 0))
        ty = float(t.get('y', 0))  # SVG y is baseline
        txt = (t.text or '').strip()
        if not txt:
            continue
        for (bx, by, bw, bh, bl) in boxes:
            # text x-center within box x-range (with 8px slack for centered text)
            if bx - 8 <= tx <= bx + bw + 8:
                box_bottom = by + bh
                if ty > box_bottom + DESCENDER_SLACK:
                    issues.append(
                        f'TEXT OVERFLOW  "{txt[:30]}"  baseline y={ty}'
                        f'  is {ty - box_bottom:.0f}px below  {bl}[bottom={box_bottom}]'
                    )

    if issues:
        print(f'FAIL  {path}  ({len(boxes)} boxes):')
        for issue in issues:
            print(' ', issue)
        sys.exit(1)
    else:
        print(f'OK  {path}  ({len(boxes)} boxes, no overlaps, no text overflow, all within {W}x{H})')

validate(sys.argv[1])
EOF
```

Replace `path/to/diagram.svg` with the actual file path:
```bash
python3 validate.py assets/diagrams/my-diagram.svg
```

**Interpreting TEXT OVERFLOW errors:** The baseline of a text element is past the box bottom. Fix by increasing `height` using the node sizing formula — never by moving text closer together.

## Workflow

1. **Identify the core message** — What is the ONE thing this diagram communicates?
2. **Choose reading flow** — Top-down, left-right, or hybrid. This determines layout.
3. **Compute box heights before touching coordinates** — For every node, list its text lines and apply the node sizing formula. Write the heights down. Never start coding with placeholder sizes.
4. **Check horizontal span for step chains** — For N boxes of width W with gap G: `span = N*W + (N-1)*G`. If `span > canvas - 80`, widen the canvas or reduce to a 2-row layout.
5. **Sketch the layout** — Plan node positions, grouping, and flow. Use the spacing scale and the heights you just computed.
6. **Choose accent color** — One color for the diagram's primary signal. Everything else is neutral.
7. **Build in order** — Follow the reading flow: title → first elements → connections → labels → caption.
8. **Run the validation script** — Catches: XML-unsafe style content, box overlaps, out-of-bounds elements, and text overflowing outside boxes. Fix every reported issue before continuing.
9. **Check every `<text>` element has an explicit `fill` attribute** — never rely on a class for fill. Dark box → `fill="#ffffff"`, light box → `fill="#0f172a"`, captions → `fill="#64748b"`.
10. **Check contrast** — Dark text on white boxes, white text on dark boxes. Always legible.
11. **Check for em dashes** — Replace any "—" with "and", "vs", "to", or a period.
12. **Review** — Check against the anti-AI checklist. Remove decoration without purpose.

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
┌─────────────────────┐  ← Layer 1 (filled, accent color)
│  Top Layer          │
├─────────────────────┤
│  Layer 2            │
├─────────────────────┤
│  Layer 3            │
└─────────────────────┘  ← Layer N (outlined, white)
```
- Layer 1: filled rect with accent color, `fill="#ffffff"` on text element
- All other layers: outlined rects with white fill, dark text
- Cross-layer connections: dashed curved lines on the side
- Caption explains each layer
- **Never use gradient fills** — filled on top, outlined below

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
- Reference in markdown or HTML using **SVG for both the display src and the popup href**:
  ```html
  <a href="/assets/diagrams/filename.svg" class="popup img-link shimmer">
    <img src="/assets/diagrams/filename.svg" alt="...">
  </a>
  ```
  Never use a separate `.png` for the href — it becomes stale the moment the SVG is updated.
  The site's custom lightbox handles SVG natively.

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
11. **Fill color in CSS classes** — Putting `fill: #0f172a` in a class silently breaks any
    per-element `fill="..."` override (the class always wins). Fix at the root: CSS classes
    carry only font properties; every `<text>` element carries its own `fill` attribute.
12. **Overlapping boxes in multi-branch flowcharts** — Before writing coordinates, calculate
    the total horizontal span of each level and verify it fits in the canvas width. For N
    sibling boxes of width W with gap G, the span is `N*W + (N-1)*G`. If branches at
    different depths share x-ranges, ensure they are also at different y-ranges (no y-overlap).
    When in doubt, widen the canvas (up to 1000px for blog posts) rather than shrinking boxes.
13. **Guessed box heights** — Never set `height` to a round number and hope the text fits.
    Use the node sizing formula. Text rendered past the box border is a broken diagram.
    The validation script's TEXT OVERFLOW check catches this — run it every time.
14. **XML-unsafe content in style or comments** — Tag names like `<text>` or `<rect>` inside
    a `<style>` block break the XML parser (the `</style>` closing tag appears to be a mismatch).
    Em dashes and Unicode box-drawing characters in XML comments can also cause parse failures.
    Write "text element" not "`<text>`", and use plain ASCII (`---`, `===`) in comments.

## Reference Aesthetics

Study these for the target look:
- **Stripe docs** — Clean, minimal, consistent spacing
- **Vercel blog** — Technical diagrams with clear hierarchy
- **Linear** — Product diagrams with subtle color and clean lines
- **Apple Human Interface Guidelines** — Clean system typography, consistent spacing
