# `gpt-image-base` 使用说明

> **定位**：OpenAI **`gpt-image-2.x`** 系列及相近 GPT-Image 模型的**通用提示词与 API 参数底座**。  
> **依据与兼容说明**：本 Skill 基于 OpenAI 官方 `gpt-image` 提示词指南、Cookbook 最佳实践与 API 文档整理（属于文档驱动的通用底座，后续将随实战反馈持续迭代）。
> - **通用规范**（Spec 结构、材质/光影描述、引号文字渲染、Diff 防漂移编辑、多图参考、透明底规范）：理论上适用于整个 **`gpt-image-2.x` 系列**（如 `2.5` / `2.6` 的 `sunburst` 与 `flare` 分支，以及相近版本）。
> - **`2.6+` 专属能力**（`complexity`、`markup` 标注编辑、`output_format: "svg"` / `"gif"`）：仅在目标模型/中转站支持对应参数时启用，旧版本忽略即可。  
> **适用对象**：日常文生图、局部改图、多图参考、透明抠图、原生 SVG 图标、无缝循环 GIF 动图，以及优化已有提示词和排查参数冲突。

---

## 一、这个 Skill 能帮你做什么？

1. **按 2.5 / 2.6 规范重写或生成提示词**：自动用“结构化设计规格书（Spec）”替代过时的 `8k / masterpiece` 堆词，显著提高排版和细节可控度。
2. **自动推荐模型与 API 参数**：帮你决定用 `flare`（快）还是 `sunburst`（精），并给出配套的 `size`、`quality`、`complexity`、`background`、`output_format`、`input_fidelity` 等 JSON 参数。
3. **排查参数与 Prompt 冲突**：自动拦截常见翻车项（例如 `background: "transparent"` 时 Prompt 误写白底、`output_format: "svg"` 时误写写实光影、`markup` 与 `mask` 混用等）。
4. **内置 9 套通用模板**：覆盖电商主图、密集文字信息图/海报、UI Mockup、多轮改图 Diff、多图参考、Markup 标注编辑、原生 SVG、循环 GIF、透明抠图。

---

## 二、怎么用？（直接这样对 AI 说）

安装或挂载本仓库后，在对话中直接说出你的需求即可自动触发，无需背诵命令：

### 1. 生成新提示词 + API 参数
> “帮我写一个 `gpt-image-2.6-sunburst` 的电商护肤品主图提示词，要求极简北欧风、左侧留白加文案，把 API 参数也给我。”

### 2. 优化你手头的提示词 / 排查翻车原因
> “我用 `gpt-image-2.6` 生透明底图标但背景老是带白边，帮我检查一下这段提示词和参数哪里冲突了。”

### 3. 生成原生 SVG / 循环 GIF（`2.6` 专属）
> “帮我写一个 9 帧无缝循环的小猫挥手 GIF 贴纸提示词，顺便给 `frame_count` 和 `frame_duration_ms` 建议。”
> “帮我写一个极简扁平风格 App 图标的原生 SVG 提示词。”

### 4. 多轮改图防漂移（Diff 写法）
> “我想只把图 1 人物的外套换成墨绿色，但不要动人脸、姿势和背景，帮我写一段防漂移的编辑提示词。”

### 5. 多图参考融合
> “我要传两张图：图 1 是我的咖啡罐产品，图 2 是我想要的暖光森系画风，帮我写多图参考提示词。”

---

## 三、你会得到什么输出？

每次触发后，AI 会按固定格式交付：
1. **推荐的 API 参数配置**（模型分支、`size`、`quality`、`complexity` 等）；
2. **可直接复制的结构化英文提示词**（若画面需渲染中文文字，会保留带双引号的精准中文）；
3. **上线前 5 项冲突自检**（用途明确、无废弃画质词、无参数冲突、文字加引号、改图含保留清单）。

---

## 四、单独安装本 Skill

```bash
npx skills add Licne/snoakari-aigc-skills --skill gpt-image-base
```

> 内部文件说明：[`SKILL.md`](../../skills/gpt-image-base/SKILL.md) 为 AI 执行指令，[`references/templates.md`](../../skills/gpt-image-base/references/templates.md) 为 9 套通用模板，[`references/api-params.md`](../../skills/gpt-image-base/references/api-params.md) 为完整参数表与 JSON 示例。
