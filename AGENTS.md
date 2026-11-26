# AGENTS.md — `snoakari-aigc-skills` 开发与维护规范

本文件供所有在本仓库中工作的 AI Agent（Antigravity / Claude Code / Cursor / Codex 等）在新设备或新会话中快速理解仓库架构、设计原则与变更规范。

---

## 1. 仓库定位与架构

`snoakari-aigc-skills` 是一个**多模态 AIGC 提示词与工作流 Skill 经验库**（与 `Licne/snoakari-gpt-image-webui` 同属 `snoakari` 系列），采用 **Monorepo + 单层平铺前缀命名**，同时兼容：
- **Antigravity Plugin**：根目录 `plugin.json` 允许整包挂载到 `~/.gemini/config/plugins/snoakari-aigc-skills`。
- **标准 Agent Skills & 选择性安装**：`skills/<skill-name>/SKILL.md` 位于第一层，兼容 `npx skills add Licne/snoakari-aigc-skills --skill <name>` 及任意 Agent 的 `skills/*/SKILL.md` 自动发现。

```text
snoakari-aigc-skills/
├── AGENTS.md                # 本文件：Agent 开发与维护规范
├── README.md                # 人类文档：Skill 索引、按需安装命令、跨设备指南
├── plugin.json              # Antigravity 插件清单（仅允许标准顶层字段）
├── scripts/
│   ├── link-plugin.ps1      # Windows 全局挂载脚本（Directory Junction）
│   └── link-plugin.sh       # macOS/Linux 全局挂载脚本（Symlink）
└── skills/
    └── <family>-<topic>/    # 所有 Skill 严格平铺于第一层
        ├── SKILL.md         # 必需：YAML Frontmatter + 精简核心指令
        └── references/      # 可选：大段模板、参数表、模块库（渐进式加载）
```

---

## 2. 命名与隔离规范（核心原则）

不同模型系列（如 `gpt-image`、`minimax-h3`、`veo`、`flux`）提示词范式互不通用，**必须通过命名前缀 + `description` 显式作用域实现隔离**：

1. **命名格式**：严格使用小写短横线 `<family>-<topic>`：
   - **系列底座**：`<family>-base`（如 `gpt-image-base`、`minimax-h3-base`），存放该系列的通用提示词结构、模型分支选型、API 参数表与通用避坑。
   - **垂直专项**：`<family>-<domain>`（如 `gpt-image-costume-sheet`、`gpt-image-ecommerce`、`minimax-h3-cinematic`），只写本领域独有工作流、模块库和安全词替换。
2. **禁止深层嵌套**：不要建 `skills/gpt-image/base/`，必须保持 `skills/<family>-<topic>/SKILL.md` 一层深度。
3. **禁止跨 Skill 重复复制底座规则**：垂直专项 Skill 开头注明 `Pairs with: <family>-base`，仅补充本领域特有的推荐 API 参数组合，不整段抄写底座的参数表。
4. **Frontmatter 规范**：每个 `SKILL.md` 仅使用标准字段：
   - `name`: 与目录名完全一致（小写短横线）。
   - `description`: 用第三人称清晰说明**适用模型系列**与**触发条件**，避免不同系列或底座与专项之间发生误触发。

---

## 3. 渐进式加载（Progressive Disclosure）规范

- `SKILL.md` 保持精简、结构化、可直接执行，避免塞入冗长的静态模板或对照表。
- 大段提示词模板、模块预设、参数 JSON 示例、安全词替换表统一放入 `references/*.md`，在 `SKILL.md` 中用相对路径（`[file.md](./references/file.md)`）按需引导读取。

---

## 4. 新增或修改 Skill 时的必做同步清单

每次新增、重命名或删除 Skill，必须同步完成以下 4 项：
1. **Skill 文件**：创建/更新 `skills/<family>-<topic>/SKILL.md` 及必要的 `references/`。
2. **更新 `README.md`**：同步更新“Skill 索引表”和对应的“选择性安装命令”示例。
3. **检查 `plugin.json`**：确认 `description`、`version`（按语义化版本递增）和 `suggestedPrompts`（最多 3 条）依然准确；**切勿**添加非标准顶层字段。
4. **Git 提交**：使用 Conventional Commits（如 `feat(skills): add minimax-h3-base`、`refactor(gpt-image-costume-sheet): refine Mode D rules`）。

---

## 5. 跨设备克隆与本地生效

在任何新电脑 clone 本仓库后，运行对应平台的挂载脚本即可将仓库直接链接为本地 Antigravity 全局插件（单一数据源，修改仓库即实时生效）：
- **Windows (PowerShell)**：`.\scripts\link-plugin.ps1`
- **macOS / Linux**：`bash ./scripts/link-plugin.sh`
