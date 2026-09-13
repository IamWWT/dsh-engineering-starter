# skills/ — 随包技能

| skill | 用途 | 调用方 |
|---|---|---|
| `project-discipline/` | 框架操作手册：init-project/七阶段/门禁/交接/dsh-plugin 骨架（重内容，按需加载） | Agent（自动或用户） |
| `grilling/` | 需求澄清方法论（设计树/前沿问题/推荐答案），MIT，源自 [mattpocock/skills](https://github.com/mattpocock/skills) | Agent / 用户 |
| `grill-me/` | grilling 的快捷入口；随包版 `disable-model-invocation: false`——工程模式 Agent 可在 Phase 0 自主调用（你个人 `~/.agents/skills/grill-me` 那份是 disable 的，仅人工 `/grill-me` 触发） | Agent + 用户 |

安装：`scripts/install-dsh.sh` 会把本目录全部 skill 拷入 `$DSH_SKILLS_DIR`（默认 `~/.agents/skills`）。
重内容放 skill、不放 preset persona / AGENTS.md——skill 目录平时只占 name+description 两行，调用才加载正文（system prompt 节约，铁律 16）。