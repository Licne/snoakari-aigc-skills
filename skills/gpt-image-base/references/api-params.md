# GPT-Image API Parameters & Conflict Reference

Keep technical controls in the API payload rather than natural-language prompt text.

---

## 1. Model Selection Matrix

| Model ID | Tier | Best Used For |
| :--- | :--- | :--- |
| `gpt-image-2.6-sunburst` | Flagship / Precision | Final production renders, dense typography, infographics, multi-turn edit consistency, SVG/GIF/Markup |
| `gpt-image-2.6-flare` | Speed / High-Throughput | Rapid prototyping (~2x faster), layout exploration, batch drafts, simple icons/stickers |
| `gpt-image-2.5-sunburst` | Previous Flagship | Stable 2.5 production pipelines |
| `gpt-image-2.5-flare` | Previous Speed | Fast 2.5 iteration pipelines |

---

## 2. Core Parameters

| Parameter | Values | Default | Guidance |
| :--- | :--- | :--- | :--- |
| `prompt` | Up to 32,000 chars | — | Structured Spec; avoid legacy buzzwords (`8k`, `masterpiece`). |
| `size` | `1024x1024`, `1536x1024`, `1024x1536`, `auto` | `auto` | Always set explicitly for deterministic aspect ratio. |
| `quality` | `auto`, `low`, `medium`, `high`, `xhigh`, `max` | `auto` | Governs fine texture & small-letter legibility. Relative to model tier (`flare` `high` ≠ `sunburst` `high`). |
| `complexity` *(2.6)* | `low`, `medium`, `high` | `high` | Pre-render layout planning depth. Drop to `low` for simple edits to avoid over-generation; keep `high` for dense layouts/tables/menus. |
| `background` | `auto`, `opaque`, `transparent` | `auto` | Use `transparent` for native RGBA cutouts. Requires `png` or `webp`. |
| `output_format` | `png`, `webp`, `jpeg`, `svg` *(2.6)*, `gif` *(2.6)* | `png` | `svg` requires `n=1` on `/v1/images/generations`. `gif` defaults to opaque background. |
| `input_fidelity` | `low`, `high` | — | Edits/reference tasks: set `high` to strictly preserve faces, logos, and product geometry. |
| `frame_count` *(2.6 GIF)* | `2` – `16` | ~`9` | Total frames in animated GIF output. |
| `frame_duration_ms` *(2.6 GIF)* | `20` – `2000` | ~`200` | Milliseconds per frame in GIF output. |

---

## 3. Common Parameter vs. Prompt Conflicts (Avoid!)

1. **`background: "transparent"` + `"white background"` in prompt** → Model fights the alpha channel; omit backdrop color from prompt and use `output_format: "png"` or `"webp"` (never `"jpeg"`).
2. **`output_format: "svg"` + photographic terms** → Terms like `photorealistic`, `bokeh`, `film grain`, `soft shadows` degrade clean vector paths.
3. **`markup` + `mask` together** → Unsupported on `/v1/images/edits`; pick either visual `markup` overlay OR binary `mask`.
4. **High `complexity` on tiny edits** → Causes `sunburst` to over-plan and inject unrequested details; drop `complexity` to `"low"` for single-variable swaps.
5. **Omitting background color on `output_format: "gif"`** → GIF route defaults to opaque rendering; explicitly state the exact solid background color in the prompt so it blends with the target UI.

---

## 4. Example API Payloads

### A. Production Static Image (`sunburst`)
```json
{
  "model": "gpt-image-2.6-sunburst",
  "prompt": "...",
  "size": "1536x1024",
  "quality": "high",
  "complexity": "high",
  "output_format": "png",
  "n": 1
}
```

### B. Transparent Cutout Asset
```json
{
  "model": "gpt-image-2.6-sunburst",
  "prompt": "...",
  "size": "1024x1024",
  "quality": "high",
  "complexity": "low",
  "background": "transparent",
  "output_format": "png",
  "n": 1
}
```

### C. Native Vector SVG (`2.6`)
```json
{
  "model": "gpt-image-2.6-sunburst",
  "prompt": "...",
  "quality": "high",
  "complexity": "medium",
  "output_format": "svg",
  "n": 1
}
```

### D. Native Looping GIF (`2.6`)
```json
{
  "model": "gpt-image-2.6-sunburst",
  "prompt": "...",
  "size": "1024x1024",
  "quality": "medium",
  "complexity": "medium",
  "output_format": "gif",
  "frame_count": 9,
  "frame_duration_ms": 150,
  "n": 1
}
```
