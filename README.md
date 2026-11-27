# snoakari-aigc-skills

面向多模态 AIGC 模型的提示词与工作流 Agent Skill 经验库。

仓库采用 **单仓库（Monorepo）+ 模型前缀隔离 + 渐进式加载** 设计，支持按模型系列与垂直场景**自由勾选安装**，也支持整包挂载为 Antigravity 全局插件。

---

## Skill 索引

### GPT-Image 系列（`gpt-image-2.x`）

| Skill 名称 | 定位 | 适用范围与实测状态 | 使用说明 | AI 指令 | 简介 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `gpt-image-base` | 通用底座 | `gpt-image-2.x` 通用（基于官方文档整理；`2.6+` 含 `complexity`/`markup`/`svg`/`gif`） | [使用说明](./docs/skills/gpt-image-base.md) | [SKILL.md](./skills/gpt-image-base/SKILL.md) | 通用 Spec 格式规范、`flare` vs `sunburst` 选型、参数降级策略、防审核误杀与实战经验区 |
| `gpt-image-costume-sheet` | 垂直专项 | **已实测**：`gpt-image-2.5-sunburst`；**理论兼容**：`2.6` 及相近 `2.x`（未逐一实测） | [使用说明](./docs/skills/gpt-image-costume-sheet.md) | [SKILL.md](./skills/gpt-image-costume-sheet/SKILL.md) | 角色服饰四大工作流（文生服饰设定板 / 人设图提衣 / 换装融合 / 多层立绘脱层），强制中英双语对照输出 |

> 每个 Skill 的人类阅读说明统一放在仓库根目录的 `docs/skills/` 下（`skills/` 目录保持纯净，严格遵循 `agentskills.io` / OpenAI / Anthropic 规范，不放 `README.md`）。点击上方 **使用说明** 即可查看对话示例与快速上手指南。

---

## 快速选择性安装（推荐）

每个 Skill 位于 `skills/<family>-<topic>/` 且完全自包含，你可以只安装需要的模型底座和垂直专项：

### 方式 1：使用 `npx skills`（兼容 Antigravity / Claude Code / Cursor / Codex）

```bash
# 交互式勾选想要安装的 Skill
npx skills add Licne/snoakari-aigc-skills

# 或按需精准安装（示例：GPT-Image 底座 + 服饰设定板专项）
npx skills add Licne/snoakari-aigc-skills --skill gpt-image-base --skill gpt-image-costume-sheet
```

### 方式 2：手动拷贝单目录

将 `skills/` 下需要的目录直接复制到你的 Agent Skills 目录即可：
- **Antigravity 全局**：`~/.gemini/config/skills/`
- **项目工作区**：`<your-project>/.agents/skills/`

---

## 跨设备同步与开发者自用（Antigravity 整包挂载）

如果你在多台电脑间同步维护本经验库，Clone 后运行对应脚本即可将本仓库注册到 `~/.gemini/config/plugins.json`（Antigravity 官方外部插件注册机制，单一数据源：在仓库里改完即刻全局生效，无需复制，也不受 Windows 软链限制）：

```powershell
# Windows (PowerShell)
git clone https://github.com/Licne/snoakari-aigc-skills.git
cd snoakari-aigc-skills
.\scripts\link-plugin.ps1
```

```bash
# macOS / Linux
git clone https://github.com/Licne/snoakari-aigc-skills.git
cd snoakari-aigc-skills
bash ./scripts/link-plugin.sh
```

---

## 开发与贡献规范

本仓库根目录包含 [AGENTS.md](./AGENTS.md)，在任何新设备或新 AI 会话中打开本仓库时，Agent 会自动读取其中的命名规范、目录结构、底座/专项解耦规则与同步检查清单。

---

## License & 署名

本项目采用 [MIT License](./LICENSE) 开源（Copyright © 2026 Licne）。每个独立 Skill 的 `SKILL.md` Frontmatter 均附带标准 `license` 与 `metadata`（`author` / `repository` / `version`）声明；欢迎按需选用、修改或二次分发，请按 MIT 协议保留原作者署名与许可声明。
