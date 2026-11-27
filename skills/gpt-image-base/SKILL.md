---
name: gpt-image-base
description: >-
  Foundational, general-purpose prompting and API parameter guide for OpenAI's
  gpt-image-2.x model family (such as gpt-image-2.6 and gpt-image-2.5 sunburst /
  flare variants, and adjacent gpt-image models). Synthesized from OpenAI's
  official prompting guides and API documentation. Use as the base skill when
  writing, reviewing, or optimizing general gpt-image prompts, choosing flare
  vs. sunburst, tuning API parameters (complexity, quality, background,
  output_format, markup, input_fidelity), generating SVG/GIF assets, or fixing
  drift in multi-turn edits.
---

# GPT-Image Base Prompting & API Spec Skill

> **Basis**: Synthesized from OpenAI's official `gpt-image` prompting guides, Cookbook patterns, and API documentation (general baseline; refine with empirical findings over time).
> **Model Scope**: Applies broadly to the **`gpt-image-2.x` family and adjacent GPT-class image models** (currently exemplified by `gpt-image-2.5` and `gpt-image-2.6` `sunburst` / `flare` variants). Core Spec prompting, text rendering, multi-image referencing, and Diff editing rules generalize across the series; features marked `2.6+` (`complexity`, `markup`, `svg`, `gif`) apply only when the target model/endpoint supports them.
> **Role**: Foundational base skill; pair or defer to specialized `gpt-image-*` domain skills (such as `gpt-image-costume-sheet`) when a dedicated vertical skill applies.

## Core Philosophy

Treat prompts as **design and layout specifications (Specs)**, not keyword lists.
- **Never** stuff legacy buzzwords (`8k`, `masterpiece`, `trending on artstation`, `hyperrealistic`, `ultra detailed`).
- **Always** separate **visual description** (in `prompt`) from **technical settings** (in API parameters).

---

## Step 1: Choose Model Variant & Core Parameters

Select the right model branch and parameters before writing the prompt. See [api-params.md](./references/api-params.md) for full parameter tables and JSON payloads.

| Need | Model Variant | `complexity` | `quality` | Notes |
| :--- | :--- | :--- | :--- | :--- |
| Rapid drafts, high volume, concept exploration | `gpt-image-2.6-flare` (or `2.5-flare`) | `low` / `medium` | `low` / `medium` | ~2x faster; validate layout quickly before final render |
| Production assets, dense text, UI, infographics | `gpt-image-2.6-sunburst` (or `2.5-sunburst`) | `high` | `high` / `xhigh` / `max` | Deeper pre-render planning; strict spatial adherence |
| Simple localized edits (color/background/sign swap) | `sunburst` (for consistency) or `flare` (for speed) | **`low`** | `medium` / `high` | Lower `complexity` prevents hallucinated extra props |
| Multi-turn iterative edits (Responses API / Edits) | `gpt-image-2.6-sunburst` | `low` / `medium` | `high` | Best identity & geometry preservation across turns |

> **Workflow rule**: Prototype cheaply on `flare` (`low`/`medium` complexity), then lock down final renders and multi-turn edits on `sunburst`.

---

## Step 2: Structure the Prompt

Use short, labeled blocks or line breaks instead of a single wall of text. Follow this top-down order:

1. **Deliverable / Use Case**: Define what the asset is for first (e.g., *e-commerce hero banner*, *3-column technical infographic*, *flat mobile app icon*).
2. **Scene & Lighting**: Concrete physical lighting, environment, and color palette (e.g., *soft natural side-lighting from a left window, warm matte limestone surface*).
3. **Subject & Action**: Primary focal point, pose, count, and key geometry.
4. **Materials & Visual Medium**: Specific textures and media (*brushed anodized aluminum*, *matte stoneware*, *risograph print*) instead of vague style adjectives.
5. **Composition & Negative Space**: Camera angle, framing, exact spatial zones, and reserved whitespace.
6. **Literal Text (if any)**: Wrap exact strings in `"double quotes"`, specify placement, font style, and contrast. For rare brand names/tricky spellings, spell letter-by-letter (`'A-R-C-H-I-V-E'`).
7. **Hard Constraints / Boundaries**: Explicitly forbid unwanted artifacts (`No watermarks, no random logos, no extra packaging`).
   - **Sunburst guardrail**: Because `sunburst` can add unrequested micro-details in dense scenes, add `minimalist, no extra micro-details or unrequested labels` when cleanliness matters.

---

## Step 3: Apply Mode-Specific Rules

Load [templates.md](./references/templates.md) for copy-pasteable prompt templates for each mode below:

- **Image Editing / Multi-Turn Consistency (Diff Format)**:
  - Split explicitly into `Only change:` and `Must preserve exactly:`.
  - Change **one variable per turn** (e.g., background first, lighting second) to prevent drift.
- **Multi-Image Reference**:
  - Explicitly bind each input by index and role: `Image 1` = product geometry/branding, `Image 2` = lighting/art direction. Never leave roles ambiguous.
- **Markup-Guided Edits (`2.6` `markup` layer)**:
  - Pass a transparent PNG annotation layer (circles, arrows, notes) to `/v1/images/edits`.
  - Keep `prompt` focused strictly on **what** to change—do not repeat spatial descriptions already shown by markup.
  - **Conflict rule**: Never combine `markup` with binary `mask`.
- **Transparent Assets (`background: "transparent"`)**:
  - Set `output_format` to `"png"` or `"webp"` (never `"jpeg"`).
  - **Conflict rule**: Remove any `"white background"` / `"solid backdrop"` wording from `prompt`.
- **Native Vector Graphics (`2.6` `output_format: "svg"`, `n: 1`)**:
  - Use geometric/path vocabulary (`flat 2D SVG icon`, `clean vector paths`, `bold geometric shapes`, `limited flat color palette`).
  - **Conflict rule**: Remove photographic/raster terms (`bokeh`, `photorealistic lighting`, `soft shadows`, `film grain`).
- **Native Animated GIFs (`2.6` `output_format: "gif"`)**:
  - Configure `frame_count` (`2–16`, default ~9) and `frame_duration_ms` (`20–2000`, default ~200).
  - Describe motion **by frame ranges** (start → peak → settle), explicitly require a **seamless loop** (`final frame transitions smoothly back into frame 1`), and explicitly specify a **solid background color** (GIF outputs are opaque by default).

---

## Step 4: Output Delivery & Pre-Flight Checklist

When delivering a prompt to the user, always provide:
1. **Recommended API Configuration** (`model`, `size`, `quality`, `complexity`, `output_format`, `background` / `input_fidelity` as relevant).
2. **Structured Prompt** (English by default for highest adherence, unless the image must render Chinese/other-language text—in which case keep exact target-language text inside `"quotes"`).
3. **Quick Verification** against these 5 checks:
   - [ ] Deliverable / use case is stated in the opening line.
   - [ ] No legacy quality buzzwords (`8k`, `masterpiece`) and no API-parameter conflicts (`white background` vs `transparent`, raster lighting vs `svg`).
   - [ ] Every literal text string is quoted with clear placement & contrast.
   - [ ] Edit prompts explicitly list `Must preserve exactly:` invariants.
   - [ ] `complexity` matches task difficulty (`low` for simple edits, `high` for dense layouts).
