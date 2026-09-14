# skills/ — 随包技能

| skill | 用途 | 调用方 |
|---|---|---|
| `project-discipline/` | 框架操作手册：init-project/七阶段/门禁/交接/dsh-plugin 骨架（重内容，按需加载） | Agent（自动或用户） |
| `grilling/` | 需求澄清方法论（设计树/前沿问题/推荐答案），MIT，源自 [mattpocock/skills](https://github.com/mattpocock/skills) | Agent / 用户 |
| `grill-me/` | grilling 的快捷入口；随包版 `disable-model-invocation: false`——工程模式 Agent 可在 Phase 0 自主调用（你个人 `~/.agents/skills/grill-me` 那份是 disable 的，仅人工 `/grill-me` 触发） | Agent + 用户 |

安装：本目录随 `presets/engineering/` 一起由 `scripts/install-dsh.sh` 装入 `$DSH_HOME/.agent-presets/engineering/skills/`，
由 preset 的 `skill-filesystem` 行以 **preset 层（scoped）** 注册——工程模式会话内 shadow 全局同名技能，
模式外不受影响；不写 `~/.agents/skills`，用户全局技能根原样保留（2026-09-14 起）。
重内容放 skill、不放 preset persona / AGENTS.md——skill 目录平时只占 name+description 两行，调用才加载正文（system prompt 节约，铁律 16）。