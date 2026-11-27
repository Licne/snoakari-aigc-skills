# `gpt-image-base` 使用说明

> **定位**：OpenAI **`gpt-image-2.x`** 系列及相近 GPT-Image 模型的**通用提示词格式与 API 参数规范底座**。  
> **依据与兼容说明**：本 Skill 基于 OpenAI 官方 `gpt-image` 提示词指南、Cookbook 最佳实践与 API 文档整理（文档驱动基线，后续实战踩坑将持续沉淀至 `references/api-params.md` 的实战经验区）。
> - **通用规范**（Spec 结构、材质/光影具象化、引号文字渲染、Diff 防漂移编辑、多图参考、透明底规范、防审核误杀原则）：理论上适用于整个 **`gpt-image-2.x` 系列**（如 `2.5` / `2.6` 的 `sunburst` 与 `flare` 分支，以及相近版本）。
> - **`2.6+` 专属能力**（`complexity`、`markup` 标注编辑、`output_format: "svg"` / `"gif"`）：仅在目标模型/中转站支持对应参数时启用；不支持时会自动触发**降级策略**，改用纯 Prompt 等效写法。
> - **与垂直 Skill 的边界**：本底座聚焦**通用格式与能力规范**，不堆砌特定业务领域的成品模板；细分场景模板由各垂直 Skill（如 [`gpt-image-costume-sheet`](./gpt-image-costume-sheet.md)）各自维护。

---

## 一、这个 Skill 能帮你做什么？

1. **按 `2.x` 规范重写或生成结构化提示词**：用清晰的 Spec 分块替代过时的 `8k / masterpiece` 堆词，显著提高构图、排版与文字渲染可控度。
2. **推荐模型分支与 API 参数，并支持中转站/旧版降级**：帮你选择 `*-flare`（快）或 `*-sunburst`（精），给出配套参数；如果你使用的中转站或 WebUI 不支持 `complexity` / `input_fidelity` / `transparent` 等参数，会自动提供降级替代方案。
3. **排查参数与 Prompt 冲突**：自动拦截高频翻车项（如 `background: "transparent"` 时误写白底、`output_format: "svg"` 时误写写实光影、`markup` 与 `mask` 混用等）。
4. **规避常见审核误杀**：在改图、去物、局部替换时自动采用中性的图形资产术语，降低 `content_policy_violation` 误报率。

---

## 二、怎么用？（直接这样对 AI 说）

安装或挂载本仓库后，在对话中直接说出你的需求即可自动触发：

### 1. 生成结构化提示词 + 参数（支持指定版本或中转站限制）
> “帮我写一个 `gpt-image-2.5-sunburst` 的极简咖啡杯产品图提示词，左侧留白放文案；我用的中转站不支持 `complexity` 参数。”

### 2. 优化已有提示词 / 排查翻车原因
> “我生透明底图标时背景老是带白边，帮我按 `gpt-image-base` 规范检查一下这段提示词和参数哪里冲突了。”

### 3. 多轮改图防漂移（Diff 写法）
> “我想只把图 1 人物的外套换成墨绿色，但不要动人脸、姿势和背景，帮我写一段防漂移的编辑提示词。”

### 4. 多图参考绑定
> “我要传两张图：图 1 是我的产品，图 2 是我想要的暖光画风，帮我写一段不会把图 2 物体抄过来的多图参考提示词。”

### 5. `2.6+` 专属模式（Markup / 原生 SVG / 循环 GIF）
> “帮我写一个 9 帧无缝循环的小猫挥手 GIF 贴纸提示词，顺便给 `frame_count` 和 `frame_duration_ms` 建议。”
> “帮我写一个极简扁平风格 App 图标的原生 SVG 提示词。”

---

## 三、你会得到什么输出？

1. **适配你当前环境的 API 参数配置**（明确标出哪些属于 `2.6+` 可选参数）；
2. **可直接复制的结构化英文提示词**（若画面需渲染中文文字，会保留带双引号的精准中文）；
3. **中文要点说明**（清晰解释结构与参数选型，复杂提示词或你要求时会附带完整中文对照翻译）。

---

## 四、单独安装本 Skill

```bash
npx skills add Licne/snoakari-aigc-skills --skill gpt-image-base
```

> 内部文件说明：[`SKILL.md`](../../skills/gpt-image-base/SKILL.md) 为 AI 执行指令，[`references/api-params.md`](../../skills/gpt-image-base/references/api-params.md) 为参数矩阵、冲突避坑、JSON 示例与实战经验沉淀区。
