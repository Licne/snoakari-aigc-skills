# snoakari-aigc-skills

面向多模态 AIGC 模型的提示词与工作流 Agent Skill 经验库（与 [snoakari-gpt-image-webui](https://github.com/Licne/snoakari-gpt-image-webui) 同系列）。

仓库采用 **单仓库（Monorepo）+ 模型前缀隔离 + 渐进式加载** 设计，支持按模型系列与垂直场景**自由勾选安装**，也支持整包挂载为 Antigravity 全局插件。

---

## Skill 索引

### GPT-Image 系列（`gpt-image-2.6` / `gpt-image-2.5`）

| Skill 名称 | 定位 | 适用模型 | 说明 |
| :--- | :--- | :--- | :--- |
| [`gpt-image-base`](./skills/gpt-image-base/SKILL.md) | 通用底座 | `gpt-image-2.6` / `2.5` (`sunburst` & `flare`) | 通用 Spec 提示词结构、`flare` vs `sunburst` 选型、`complexity`/`quality`/`markup`/`svg`/`gif` 参数规范与 9 套通用模板 |
| [`gpt-image-costume-sheet`](./skills/gpt-image-costume-sheet/SKILL.md) | 垂直专项 | `gpt-image-2.5-sunburst` / `2.6-sunburst` | 角色服饰四大工作流（文生无人物服饰设定板 / 人设图提取服饰 / 角色与设定板融合 / 多层立绘脱层去衣），强制中英双语对照输出 |

> 后续将持续扩展其他垂直场景与模型系列（如 `minimax-h3-*`、`veo-*` 等）。

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

如果你在多台电脑间同步维护本经验库，Clone 后运行对应脚本即可建立目录软链（单一数据源：在仓库里改完即刻全局生效，无需手动复制）：

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
