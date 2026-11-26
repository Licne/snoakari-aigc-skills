# GPT-Image Prompt Templates (2.5 / 2.6)

Copy and adapt the template matching the user's scenario. Replace bracketed `[placeholders]` with concrete physical descriptors.

---

## 1. E-Commerce / Product Hero Shot
*Recommended*: `gpt-image-2.6-sunburst` | `complexity: "medium"` | `quality: "high"` | `size: "1536x1024"`

```text
[Use Case]: A commercial e-commerce hero banner for a landing page.
[Scene & Lighting]: Minimalist warm-beige limestone tabletop, soft natural side-lighting from the left casting gentle, diffused shadows. Shallow depth of field with a clean, softly blurred studio backdrop.
[Subject]: A [matte charcoal-gray ceramic coffee mug] positioned slightly right of center, three-quarter front angle.
[Materials & Details]: Fine stoneware texture, crisp rim edge, subtle wisps of steam rising from black coffee inside.
[Composition & Constraints]: Reserve generous uncluttered negative space on the left 40% for website copy. Minimalist styling; no extra props, no random logos, no watermarks, no unrequested micro-details.
```

---

## 2. Infographic / Poster with Dense Typography
*Recommended*: `gpt-image-2.6-sunburst` | `complexity: "high"` | `quality: "high"` or `"xhigh"`

```text
[Use Case]: A clean, modern 3-panel horizontal infographic explaining [topic].
[Layout]: Three equal vertical columns separated by thin light-gray dividers, with a top header band and a slim bottom caption bar.
[Header]: Centered bold sans-serif title reading "[MAIN TITLE]" in dark navy on a crisp off-white background.
[Panels]:
- Panel 1 (Left): Minimalist flat editorial illustration of [visual 1]. Label below reading "[Step 1: Label]".
- Panel 2 (Center): Diagram showing [visual 2]. Label below reading "[Step 2: Label]".
- Panel 3 (Right): Visual of [visual 3]. Label below reading "[Step 3: Label]".
[Style & Palette]: Clean vector-inspired editorial style, muted slate blue, warm coral accent, off-white canvas, high-contrast legible sans-serif typography.
[Constraints]: Render every quoted text string with exact spelling and zero typos. No extra decorative text, no watermarks, no overlapping labels.
```

---

## 3. UI / App Mockup
*Recommended*: `gpt-image-2.6-sunburst` | `complexity: "high"` | `quality: "high"`

```text
[Use Case]: A high-fidelity mobile app UI screen mockup for [app purpose].
[Layout]: Single centered iOS-style screen on a clean neutral light-gray presentation backdrop.
[Sections]:
- Top bar: Left title "[Dashboard]", right minimalist bell icon.
- Hero card: Soft white rounded card showing metric "[12,480]" labeled "[Active Users]" with a clean upward emerald sparkline.
- List section: Three neatly aligned rows with circular tinted icons and short labels: "[Item A]", "[Item B]", "[Item C]".
[Style]: Modern flat SaaS design system, generous whitespace, 8px grid alignment, crisp sans-serif typography, subtle 1px borders instead of heavy drop shadows.
[Constraints]: Exact text spelling only; no gibberish placeholder text, no extra badges or cluttered overlays.
```

---

## 4. Image Editing & Multi-Turn Consistency (Diff Format)
*Recommended*: `gpt-image-2.6-sunburst` | `complexity: "low"` (for localized swap) | `input_fidelity: "high"`

```text
Only change:
- [Replace the navy blue jacket in Image 1 with a matte forest-green tailored wool jacket, keeping natural folds matching the existing lighting.]

Must preserve exactly:
- The person's facial identity, expression, hairstyle, pose, and hand positions.
- The original background architecture, camera framing, lens perspective, and lighting direction.
- Do not add any new objects, props, logos, or text.
```

---

## 5. Multi-Image Reference Composition
*Recommended*: `gpt-image-2.6-sunburst` | `complexity: "high"` | `input_fidelity: "high"`

```text
[Reference Roles]:
- Use Image 1 strictly as the product reference: preserve its exact bottle silhouette, proportions, cap material, and label typography.
- Use Image 2 strictly for art direction, color grading, and lighting mood (warm golden-hour sunlight with soft foliage shadows).

[Scene & Composition]: Place the product from Image 1 upright on a weathered pale-oak café table in the lower-center foreground, photographed at eye level with a softly blurred sunlit terrace behind it.
[Constraints]: Keep the label from Image 1 sharp and unaltered. Do not copy objects from Image 2. No extra packaging or watermarks.
```

---

## 6. Markup-Guided Edit (`gpt-image-2.6` `markup`)
*Recommended*: `gpt-image-2.6-sunburst` | `complexity: "low"` | Pass base image + transparent PNG `markup` overlay (do NOT pass `mask`).

```text
Recolor the circled ceramic vase to matte cobalt blue and remove the small spoon marked with the red X. Keep lighting, reflections, shadows, and all unmarked areas 100% identical to the original image.
```

---

## 7. Native Vector Graphic (`gpt-image-2.6` `output_format: "svg"`)
*Recommended*: `gpt-image-2.6-sunburst` | `output_format: "svg"` | `n: 1` | `complexity: "medium"`

```text
[Use Case]: A minimalist flat 2D SVG app icon for [brand/concept].
[Design]: A clean geometric [paper crane / lightning bolt / leaf] centered inside a rounded square with generous internal padding.
[Vector Style]: Bold geometric shapes, clean smooth vector paths, uniform stroke weight, strictly 3 flat solid colors ([#0F172A] deep navy, [#38BDF8] sky blue, and crisp white).
[Constraints]: Pure flat 2D vector geometry only. No gradients, no drop shadows, no photographic textures, no tiny intricate fragments.
```

---

## 8. Native Animated GIF (`gpt-image-2.6` `output_format: "gif"`)
*Recommended*: `gpt-image-2.6-sunburst` or `flare` | `output_format: "gif"` | `frame_count: 9` | `frame_duration_ms: 150`

```text
[Use Case]: A seamless looping UI micro-animation sticker of [a cheerful golden star badge].
[Background]: Solid pure white background (#FFFFFF), completely static across all frames.
[Frame-by-Frame Motion]:
- Frame 1: The badge sits upright and still at 100% scale in the center.
- Frames 2-4: The badge squashes slightly, then pops upward to 112% scale with 3 tiny minimalist sparkles radiating outward.
- Frames 5-7: The sparkles fade out as the badge gently settles with a soft elastic bounce.
- Frames 8-9: The badge returns smoothly to its exact resting position and scale, transitioning seamlessly back into Frame 1 for a clean loop.
[Style]: Clean flat vector illustration, bold crisp outlines, warm gold and amber palette. No motion blur, no background flicker.
```

---

## 9. Transparent Cutout Asset (`background: "transparent"`)
*Recommended*: `gpt-image-2.6-sunburst` or `flare` | `background: "transparent"` | `output_format: "png"` or `"webp"`

```text
[Use Case]: An isolated game/UI asset sprite with clean silhouette edges.
[Subject]: A single [stylized isometric wooden treasure chest with brass trim], centered with roughly 10% empty margin around all sides.
[Style]: Crisp stylized 3D render, soft top-left studio lighting, clean silhouette with no loose floating dust or ground shadow extending outside the object.
[Constraints]: Isolated subject only, no floor plane, no background scenery, no watermarks.
```
*(Note: Do NOT write "white background" in the prompt when `background: "transparent"` is set.)*
