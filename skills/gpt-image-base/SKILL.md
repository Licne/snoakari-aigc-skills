---
name: gpt-image-base
description: >-
  Foundational, general-purpose prompting format and API parameter specification
  for OpenAI's gpt-image-2.x model family (such as gpt-image-2.5 and
  gpt-image-2.6 sunburst / flare variants, and adjacent gpt-image models).
  Synthesized from OpenAI's official prompting guides and API documentation. Use
  as the base skill when writing, reviewing, or optimizing general gpt-image
  prompts, choosing flare vs. sunburst, tuning or degrading API parameters
  (complexity, quality, background, output_format, markup, input_fidelity),
  handling SVG/GIF/edit modes, avoiding policy false positives, or fixing drift
  in multi-turn edits.
license: MIT
metadata:
  author: Licne
  repository: https://github.com/Licne/snoakari-aigc-skills
  version: "0.1.0"
---

# GPT-Image Base Prompting & API Spec Skill

> **Basis**: Synthesized from OpenAI's official `gpt-image` prompting guides, Cookbook patterns, and API documentation (documentation baseline; empirical findings are tracked separately in [api-params.md](./references/api-params.md)).
> **Model Scope**: Applies broadly to the **`gpt-image-2.x` family and adjacent GPT-class image models** (exemplified by `2.5` / `2.6` `sunburst` and `flare` variants). Core Spec formatting, text rendering, multi-image referencing, and Diff editing generalize across the series; features marked `2.6+` (`complexity`, `markup`, `svg`, `gif`) apply only when the target model/endpoint supports them.
> **Role**: Pure format & universal capability base skill. Keep domain-specific templates in dedicated vertical skills (`gpt-image-*`, e.g., `gpt-image-wardrobe-workflow`) and defer to them when applicable.

## Core Philosophy

Treat prompts as **design and layout specifications (Specs)**, not keyword lists.
- **Never** stuff legacy buzzwords (`8k`, `masterpiece`, `trending on artstation`, `hyperrealistic`, `ultra detailed`).
- **Always** separate **visual description** (in `prompt`) from **technical settings** (in API parameters) when the user's endpoint supports those parameters.

---

## Step 1: Choose Model Branch & Core Parameters (with Degradation Fallback)

Select the right model branch and parameters before writing the prompt. See [api-params.md](./references/api-params.md) for the full parameter matrix, conflict rules, and empirical notes.

| Need | Model Branch | `complexity` *(2.6+)* | `quality` | Notes |
| :--- | :--- | :--- | :--- | :--- |
| Rapid drafts, high volume, concept exploration | `*-flare` (e.g., `2.6-flare` / `2.5-flare`) | `low` / `medium` | `low` / `medium` | ~2x faster; validate layout quickly before final render |
| Production assets, dense text, complex layouts | `*-sunburst` (e.g., `2.6-sunburst` / `2.5-sunburst`) | `high` | `high` / `xhigh` / `max` | Deeper pre-render planning; strict spatial adherence |
| Simple localized edits (color/background/sign swap) | `*-sunburst` (consistency) or `*-flare` (speed) | **`low`** | `medium` / `high` | Lower `complexity` prevents hallucinated extra props |
| Multi-turn iterative edits (Responses API / Edits) | `*-sunburst` | `low` / `medium` | `high` | Best identity & geometry preservation across turns |

> **Workflow rule**: Prototype cheaply on `*-flare`, then lock down final renders and multi-turn edits on `*-sunburst`.

### Endpoint / Relay Degradation Strategy (Important)
Many users call `gpt-image` through `2.5`, third-party relays (中转站), or WebUIs that do **not** pass through every parameter:
1. **Respect the user's stated model & client first**—do not force `2.6`-only parameters onto a `2.5` or restricted endpoint.
2. **If `complexity` is unavailable**: omit it and tighten layout/minimalism constraints directly in the prompt.
3. **If `input_fidelity` is unavailable**: reinforce invariants explicitly in the `Must preserve exactly:` block.
4. **If `background: "transparent"` is unavailable**: fall back to specifying an explicit solid backdrop (e.g., `solid pure white background (#FFFFFF)`) for easy post-cutout.
5. **If `markup` / `svg` / `gif` is unavailable**: fall back to text-described region edits (Diff format), raster flat-vector style PNGs, or sprite-sheet descriptions respectively.

---

## Step 2: Prompt Format Specification

Use short, labeled blocks or line breaks instead of a single wall of text. Follow this top-down order:

```text
[Use Case]: <asset type / deliverable purpose>
[Scene & Lighting]: <environment, physical light direction/quality, color palette>
[Subject]: <primary focal point, count, pose, key geometry>
[Materials & Medium]: <concrete physical textures and visual medium>
[Composition & Text]: <framing, spatial zones, negative space, exact "quoted text">
[Constraints]: <explicit exclusions; add minimalism guardrails for sunburst if needed>
```

Key formatting rules:
1. **Concrete physicality over buzzwords**: Describe real light, surfaces, and media (*soft natural side-lighting from the left*, *matte stoneware*, *flat vector geometry*).
2. **Aspect ratio over pixel dimensions**: Preserve the user's requested **aspect ratio** (common ratios: `1:1`, `3:2`, `2:3`, `16:9`, `9:16`, `4:3`, `3:4`, `21:9`, or any custom ratio) instead of hardcoding fixed pixel resolutions, so prompts stay portable across 1K / 2K / 4K endpoints.
3. **Literal text**: Wrap exact rendered strings in `"double quotes"`, specify placement, font style, and contrast. Spell rare brand names/tricky words letter-by-letter (`'A-R-C-H-I-V-E'`).
4. **Sunburst over-detailing guardrail**: Because `*-sunburst` can inject unrequested micro-details in dense scenes, append `minimalist, no extra micro-details or unrequested labels` when cleanliness matters.

---

## Step 3: Mode-Specific Format Rules

- **Image Editing / Multi-Turn Consistency (Diff Skeleton)**:
  Change **one variable per turn** and explicitly split changes from invariants:
  ```text
  Only change:
  - <single targeted modification>

  Must preserve exactly:
  - <identity, pose, framing, lighting direction, background, text/logos>
  - Do not add any new objects, props, or text.
  ```
- **Multi-Image Reference**:
  Bind every input image by index and strict role (`Image 1` = subject/product geometry & branding; `Image 2` = lighting/art direction only; do not copy objects from `Image 2`).
- **Transparent Assets (`background: "transparent"`)**:
  Requires `output_format: "png"` or `"webp"` (never `"jpeg"`). **Never** write `"white background"` in the prompt when `background: "transparent"` is active.
- **Markup-Guided Edits (`2.6+` `markup`)**:
  Pass base image + transparent PNG annotation layer to `/v1/images/edits`. Keep `prompt` focused strictly on **what** to change (location is handled visually). **Never** combine `markup` with binary `mask`.
- **Native Vector Graphics (`2.6+` `output_format: "svg"`, `n: 1`)**:
  Use pure geometric/path vocabulary (`flat 2D SVG`, `clean vector paths`, `bold geometric shapes`, limited flat colors). **Remove** photographic/raster words (`bokeh`, `photorealistic lighting`, `soft shadows`, `film grain`).
- **Native Animated GIFs (`2.6+` `output_format: "gif"`)**:
  Set `frame_count` (`2–16`, default ~9) and `frame_duration_ms` (`20–2000`, default ~200). Describe motion **by frame ranges**, explicitly require a **seamless loop** (`final frame transitions smoothly back into frame 1`), and explicitly specify a **solid background color** (GIF outputs default to opaque).

---

## Step 4: Universal Content Policy Guardrails

To minimize false-positive `content_policy_violation` rejections on GPT-class commercial image models:
- **Use neutral asset/editing verbs**: Prefer `isolate`, `omit`, `replace`, `recolor`, `unequip`, `toggle off` over ambiguous physical/destructive verbs (`strip`, `undress`, `rip`, `tear`).
- **Avoid restricted IP & likenesses**: Do not request trademarked brand logos (unless editing the user's own uploaded asset) or identifiable real-person likenesses.
- **Keep negative phrasing clean**: State positive visual intent first (`clean intact inner garment`, `plain unbranded packaging`) rather than repeating sensitive words inside `"no ..."` clauses.

---

## Step 5: Output Delivery & Pre-Flight Checklist

When delivering a prompt to the user, always provide:
1. **Recommended API Configuration** (matching the user's model/endpoint; clearly mark `2.6+`-only fields as optional if the user's version is unspecified).
2. **Copy-Ready Structured Prompt** (English by default for highest adherence; keep exact target-language rendered text inside `"double quotes"`).
3. **Chinese User Friendliness**: When communicating in Chinese, briefly summarize the key structure and parameter choices in Chinese alongside the English prompt (and provide a full `中文对照翻译` if the prompt is complex or the user requests it).
4. **Pre-Flight Check** (verify silently or concisely):
   - [ ] Deliverable/use case is stated first; no legacy quality buzzwords (`8k`, `masterpiece`).
   - [ ] No parameter-vs-prompt conflicts (`transparent` vs `white background`, `svg` vs raster lighting, `markup` + `mask`).
   - [ ] Every literal text string is quoted with placement & contrast.
   - [ ] Edit prompts explicitly list `Must preserve exactly:` invariants.
   - [ ] Neutral, policy-safe phrasing is used.
