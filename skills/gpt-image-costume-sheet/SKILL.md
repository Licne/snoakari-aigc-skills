---
name: gpt-image-costume-sheet
description: >-
  Specialized prompting skill originally built and verified on OpenAI
  gpt-image-2.5-sunburst (and theoretically compatible with gpt-image-2.6 and
  adjacent gpt-image-2.x models) covering four bilingual (English prompt + full
  Chinese translation) character costume workflows: (1) characterless costume
  concept breakdown sheets from text, (2) image-to-sheet costume extraction from
  a character image, (3) character-to-costume fusion dressing a character with a
  concept sheet, and (4) layer-removal / un-equipping prompts removing garments
  shown in a reference sheet from a multi-layered character illustration. Use
  whenever the user asks to design an outfit concept sheet, extract an outfit
  from a character image, dress/fuse a character with a concept sheet, or
  remove/unequip garment layers on gpt-image models.
---

# GPT-Image Costume Sheet & Character Fusion Skill

> **Verified On**: **`gpt-image-2.5-sunburst`** (battle-tested in production workflows).
> **Expected Compatibility**: Theoretically compatible with **`gpt-image-2.6-sunburst`**, `flare` variants, and other adjacent `gpt-image-2.x` models (not yet individually verified; note any version-specific parameter adjustments such as `complexity` for `2.6+`).
> **Pairs with**: `gpt-image-base` (defer general API parameter rules and non-costume prompting to `gpt-image-base`).

## Overview

This skill generates modular, production-ready prompts for four character costume workflows:
1. **Mode A — Text-to-Sheet Costume Concept Breakdown (Characterless)**: Generates an empty-body (ghost mannequin) design board from scratch displaying front/back views, customizable garment layers (from 1-piece dresses to 4+ layered outfits), selectable zoomed-in detail panels, and a color swatch bar.
2. **Mode B — Image-to-Sheet Costume Extraction (Character Image → Characterless Concept Sheet)**: Analyzes an existing character illustration and extracts/isolates ONLY the outfit, footwear, accessories, and optional props into a structured characterless costume concept breakdown sheet, stripping the human body while preserving or overriding the art style.
3. **Mode C — Character & Costume Fusion (Character + Concept Sheet → Illustration)**: Combines an existing character illustration (`Image 1`) with a costume concept sheet (`Image 2`) into a cohesive character illustration while locking identity/style (or allowing intentional overrides), stripping board UI elements, and customizing pose, extra traits, props, and framing.
4. **Mode D — Layer Removal / Un-equipping (Multi-Layered Character + Concept Sheet → Inner-Layer Illustration)**: Uses a costume concept sheet (`Image 2`) as a visual exclusion reference to selectively remove specific items—or fully remove all items shown in `Image 2`—from a multi-layered character illustration (`Image 1`), while cleanly preserving/reconstructing the inner layers underneath.

**Mandatory Output Rule**: Always output BOTH the ready-to-copy **English Prompt** (inside a fenced code block) AND a **complete Chinese translation** (`中文对照翻译`) alongside every generated prompt.

---

## Recommended API Parameters by Mode

Use `sunburst` for all four modes (strongest layout fidelity, detail-panel separation, and identity/garment preservation). Avoid `flare` for final renders in Mode B/C/D due to higher drift risk.

| Mode | Recommended Model | `size` | `quality` | `complexity` *(2.6)* | `input_fidelity` |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Mode A** (Text-to-Sheet) | `gpt-image-2.5-sunburst` / `2.6-sunburst` | `1536x1024` | `high` | `high` | — |
| **Mode B** (Image-to-Sheet) | `gpt-image-2.5-sunburst` / `2.6-sunburst` | `1536x1024` | `high` | `high` | `high` |
| **Mode C** (Character Fusion) | `gpt-image-2.5-sunburst` / `2.6-sunburst` | `1024x1536` | `high` | `medium` / `high` | `high` |
| **Mode D** (Layer Removal) | `gpt-image-2.5-sunburst` / `2.6-sunburst` | Match `Image 1` | `high` | `low` / `medium` | `high` |

> In **Mode D** on `gpt-image-2.6-sunburst`, keep `complexity` at `low` or `medium` so the model does not over-plan or hallucinate extra accessories while reconstructing inner layers.

---

## Workflow Decision Tree

Determine which mode(s) the user requests:
- **Mode A (Text-to-Sheet)**: Designing a new outfit from description ("设计一套衣服", "服饰概念图").
- **Mode B (Image-to-Sheet Extraction)**: Extracting an outfit from an uploaded/existing character image into a standalone costume sheet ("从人设图提取服饰", "以人物图生服饰概念图", "把人物身上的衣服拆成设定板").
  - Also distinguish whether the user wants:
    - a **Direct Image-to-Image Extraction Prompt** (to upload their character image directly to the image model), OR
    - a **Visual Reverse-Engineered Text-to-Sheet Prompt** (after analyzing the image, write concrete garment descriptions for text-to-image generation), OR **a reusable general template** with `[placeholders]`.
- **Mode C (Character + Sheet Fusion)**: Dressing a character with an existing costume sheet ("把这套衣服穿到角色上", "融合立绘").
- **Mode D (Layer Removal / Un-equipping)**: Removing specific or all garments depicted in `Image 2` from a multi-layered character in `Image 1` ("去掉图1中穿的图2外套/衣服", "脱掉外层服装只保留内搭", "指定去除某件衣服" / "全量去除").
- **Combined Pipelines**: Output each requested stage in logical order (e.g., Mode B → Mode C, or Mode D → Mode C).

Before generating, inspect [modules-guide.md](./references/modules-guide.md) when detailed options for art styles, garment layer patterns, detail panel presets, extraction guardrails, safety-filter word substitutions, or fusion pose/trait options are needed.

---

## Mode A: Text-to-Sheet Costume Concept Breakdown (Modular Assembly)

Assemble Mode A dynamically based on the user's request. Never hardcode fixed layers (like always forcing outer + top + bottom) or fixed panel types when the outfit differs.

### 1. Core Header & Anti-Body Guardrails
Always open with a clear no-character declaration and background setting:
- **Canvas**: `A professional 2D [Art Style] costume concept design sheet (wardrobe breakdown sheet) on a clean [Background Color/Texture, e.g., crisp off-white / light cool-grey / warm ivory paper-textured] background, displaying ONLY clothing, accessories, and optional props—strictly NO character, NO human body, NO skin, and NO face.`
- **Display Mode**: Default to `Invisible ghost mannequin style (3D hollow clothing silhouette showing natural worn volume and realistic cloth folds)`. Support alternatives if requested (e.g., `flat lay display`, `floating layered presentation`).
- **Main Views**: Default to `front three-quarter view and back view side-by-side`. Adjust if user requests front-only, 3-view, or inner/outer split views.

### 2. Art Style Slot (Fully Customizable)
Adapt the `- Art Style & Rendering:` block to match whatever style the user specifies (default to **Modern Anime Cel-Shaded** if unspecified). Refer to [modules-guide.md](./references/modules-guide.md) for ready-to-use style blocks.

### 3. Dynamic Garment Layering (`Left Main Section`)
Build the bullet list dynamically to match the **actual garment structure** of the design (1 to 5+ layers, no fixed count):
- **1-piece / Minimal**: `* Main Dress / Jumpsuit:` + optional `* Silhouette / Hem:`
- **2-piece**: `* Top:` + `* Bottom:`
- **3-piece**: `* Outer Layer:` + `* Inner Top:` + `* Bottom:`
- **4+ layers**: `* Cloak / Cape:` + `* Outer Coat / Armor:` + `* Mid-Layer Vest / Shirt:` + `* Base Bodysuit / Bottom:` + `* Back / Waist Drapery:`
- Specify `skirt only, no shorts or pants` when the user strictly wants a pure skirt, or specify layered shorts/culottes explicitly when desired.

### 4. Selectable Right-Side Detail Panels (`Right Side Section`)
Allow **3 to 8 panels** (user-selected or smartly chosen to fit the theme) from categories in [modules-guide.md](./references/modules-guide.md): Textile Macro, VFX/Magic Aura, Collar & Neck Jewelry, Headwear/Hair/Ear, Waist & Hardware, Arm/Hand/Sleeve, Footwear & Legwear, Bag/Weapon/Prop, and Monochrome Lineart Wireframe.

**Default Clean Grid Rule (No Callout Lines)**: Present right-side detail panels as a **clean, self-contained modular grid** (`neat grid of standalone inset boxes with no connecting lines, no pointer arrows, and no crossing callout lines`). Only add pointer/callout lines if the user explicitly asks for them.

### 5. Palette & Cleanup Rules
- Include `- Theme & Palette:` with explicit primary, secondary, accent, and hardware colors (and negative color constraints if requested).
- Include `Color Swatch Bar:` matching the exact number of palette colors (typically 4–6 swatches).
- End with layout hygiene: `Clean anime/graphic production art sheet layout, crisp thin panel borders, no connecting pointer lines between panels, zero messy text paragraphs or garbled labels.`

---

## Mode B: Image-to-Sheet Costume Extraction (Character Image → Concept Sheet)

Use Mode B when the user feeds an existing character image to an image-to-image model to isolate and extract the outfit into a concept sheet (or asks for a reusable extraction prompt template).

### Key Technical & Safety Principles
1. **Never use stripping verbs**: Avoid `undress`, `strip`, `take off`, `remove clothes from her`. Always phrase as asset extraction: `Analyze the provided character illustration and isolate/extract ONLY the complete outfit, footwear, and wearable accessories into a standalone wardrobe breakdown sheet`.
2. **Aggressive Ghost-Body Removal**: Image-to-image models strongly retain faces, necks, and limbs unless explicitly blocked. Always enforce:
   - `COMPLETELY OMIT the character, face, hair, head, neck, hands, legs, and all human skin.`
   - `Render NO human figure and NO solid mannequin—present the extracted garments in an invisible ghost mannequin style (hollow 3D clothing silhouette floating with natural worn volume).`
   - `Leave the interior of collars, sleeves, skirts, and stockings completely hollow and empty matching the background.`
3. **Flexible Style Lock vs. Style Override**:
   - Default: lock the reference image's exact linework, shading, and color fidelity.
   - Override option: allow shifting the extracted sheet into another style (e.g., `re-render in semi-painted style` or `clean flat production sheet`).
4. **Adaptive Layer & Panel Extraction**:
   - Let the model reconstruct all visible layers (1 to 5+ pieces) AND logically infer a consistent **back view** from the front design.
   - Support **user-pinned highlight items** (small accessories like hairpins, garter clasps, hidden inner layers, or VFX that image models often overlook) as an optional slot inside the detail panels.
   - Exclude skin tones and hair colors from the extracted `Color Swatch Bar`.
5. **Customizable Panel Count & Types (No Pointer Lines by Default)**:
   - Default to 5–6 panels (Textile/Pattern, Collar/Neckwear, Head/Hair Accessories, Hardware/Waist/Props, Footwear/Legwear, optional Wireframe/VFX), customizable from 3 to 8 panels.
   - Arrange panels in a **clean standalone grid without pointer lines or callout arrows** unless the user explicitly asks for connecting lines.

---

## Mode C: Character & Costume Fusion (Customizable Assembly)

Use Mode C when combining `Image 1` (character base) and `Image 2` (costume concept sheet) or applying direct outfit changes onto a character base.

### Modular Structure
1. **Identity & Style Lock (`From Image 1`)**:
   - Default: lock face, hairstyle, hair color, eye details, body proportions, and exact art style (`linework thickness, coloring, and shading technique`) of `Image 1`.
   - **Optional Overrides**: Support hairstyle overrides, expression overrides, or style shift overrides.
2. **Costume & Element Extraction (`From Image 2`)**:
   - Transfer the exact garments, inner layers, footwear, jewelry, bags, VFX, or weapons shown in `Image 2`.
   - **Optional Additions / Omissions**: Explicitly add non-sheet character traits (e.g., horns, tail, wings) or exclude unwanted sheet items (e.g., `omit the hat`).
3. **Sheet UI Cleanup (Critical)**:
   - Always include: `Do NOT include any layout frames, callout lines, inset zoom boxes, back-view duplicates, or color swatches from Image 2—render ONLY the single character wearing the complete outfit.`
4. **Pose, Action & Weapon Handling**:
   - Customize posture, weight shift, gaze, expression, hand interactions, and motion.
   - **Occlusion Guard**: Always include `(not blocking her torso or face)` when holding weapons or posing arms.
5. **Atmosphere, Lighting & Framing**:
   - Default to full-body reusable sprite (`Even studio lighting on a clean solid pure white / light grey background`, generous margins). Allow switching to dramatic splash-art lighting and environmental backgrounds on request.

---

## Mode D: Layer Removal / Un-equipping (Character + Exclusion Sheet)

Use Mode D when `Image 1` is a character wearing multiple layers (e.g., 4–6+ pieces) and `Image 2` is a concept design sheet representing outer garment(s) or accessory layer(s) to be removed from `Image 1`.

### Key Technical & Safety Principles
1. **Treat `Image 2` Strictly as an Exclusion Mask (Never Fuse or Draw Board UI)**:
   - Explicitly tell the model NOT to add `Image 2`'s clothes or layout boxes onto `Image 1`. Instead, `Image 2` serves purely to identify **which outer items on `Image 1` should be unequipped / hidden**.
2. **Use Game-Asset Layer-Toggle Phrasing (Anti-Policy Violation)**:
   - Avoid `undress`, `strip`, `take off her clothes`, or `naked`. Use `toggle off / unequip / omit the specified outer garment layer(s)` and `render the character in her intact underlying inner layers`.
3. **Support Both Sub-Modes**:
   - **Sub-mode D1 — Selective Item Removal (指定去除)**: Remove ONLY the user-specified item(s) from `Image 2` (e.g., outer coat/cloak/hat/belt) while keeping all other layers on `Image 1` (including any other layers that happen to appear in `Image 2`) intact.
   - **Sub-mode D2 — Full Sheet Removal (全量去除)**: Remove EVERY garment, accessory, and footwear item depicted in `Image 2` from `Image 1`, leaving only the inner layers of `Image 1` that are NOT part of `Image 2`.
4. **Inner-Layer Reconstruction & Consistency**:
   - Clearly preserve the visible inner layers from `Image 1` (e.g., mid-layer vest, inner shirt, inner dress, base skirt) AND naturally reconstruct the parts that were previously occluded by the removed outer layer (such as shoulders, upper sleeves, collar, waistline, or back drape).
   - Provide an optional `[Hidden Inner-Layer Details]` slot in case the user wants to specify what the concealed parts look like (e.g., sleeveless vs. short-sleeve inner shirt).
5. **Pose Preservation vs. Natural Adjustment**:
   - Default to **preserving `Image 1`'s exact pose, framing, lighting, and background** (ideal for RPG paper-doll / multi-state layer sprites), OR allow optional pose relaxation (e.g., dropping arms naturally if the character was holding a cape/coat).

---

## Content Policy & Safety Guardrails

For GPT-class commercial image models (`gpt-image-2.5-sunburst`, `gpt-image-2.6-sunburst`), avoid combinations that trigger false-positive `content_policy_violation` errors:
- Avoid `school uniform` + `skirt removed` / `panties` / `torn` / `ripped` / `succubus` / `lingerie` / `undress` / `strip`.
- Use safe, accurate equivalents from [modules-guide.md](./references/modules-guide.md).

---

## Output Format Standard

When responding to the user with generated prompts:
1. Briefly note the recommended API configuration (model, `size`, `quality`, `complexity`, `input_fidelity`) and any extracted/chosen design highlights (palette, layer count, selected detail panels, or style).
2. Present each prompt inside a clean **English Prompt** code block (`markdown` or `text`) ready for one-click copy.
3. Immediately follow each English prompt with a **`中文对照翻译`** block translating every section faithfully so the user can verify and tweak every detail easily.
4. If the user asks for reusable templates rather than a filled design, provide the modular `[placeholder]` templates plus concise option lists, also with full Chinese translations.
