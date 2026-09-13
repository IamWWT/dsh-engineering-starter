---
name: project-discipline
description: dsh-engineering-starter 框架操作手册：七阶段协议、init-project/doc-check/quality-gate 脚本用法、dsh-plugin 骨架、会话交接。新项目/新需求/交付前/跨会话续接时调用。
---

# project-discipline — dsh-engineering-starter 操作手册

> 本 skill 是 `skills/` 层的内容弹药：persona 只指路，细节在这里按需加载。
> 规则真源：`AGENTS.md`（协议与铁律）+ `standards/`（规范）。本 skill 不复制规则全文，只给操作路径。

## 何时调用

- 用户一句话需求要开新项目 / 加功能 / 修 Bug
- 交付前跑质量门禁
- 新会话要续接上次进度
- 生成 DSH 插件项目（`--kind dsh-plugin`）

## 1. 生成新项目

```bash
# 通用项目（generic）
scripts/init-project.sh <目录> --lang <java|python|rust|go|node|空=不限> --name "名称" [--git]

# DSH 插件项目（生成 package.json dsh 声明/双 tsconfig/build.mjs 产物门禁/cordis.patch.yml/SDD 骨架）
scripts/init-project.sh <目录> --kind dsh-plugin --name <插件名> [--git]
```

- 目标目录必须为空；`--name` 缺省取目录名。
- 生成物自带 AGENTS.md/docs/standards/scripts，**任何 Agent 打开即用**（自包含，不依赖框架仓库在场）。
- 框架仓库内开发：`projects/<项目名>/`；DSH 插件建议直接生成到 `dsh-plugins/` 工作区。

## 2. 七阶段速查（细节见 AGENTS.md §2）

| 阶段 | 动作 | 产物 | 验证 |
|---|---|---|---|
| P0 | grill-me 澄清（免问时走假设表）→ request.md + PRD | docs/00-request + 01 | 每个 P0 有可测验收标准 |
| P1 | 最小可行栈选型 + ADR | docs/02-design | 模块有职责与契约 |
| P2 | 里程碑 + 任务 DoD | docs/03-plan | 每批可独立验证 |
| P3 | 脚手架，空壳 build+test 通过 | 骨架 | 干净环境可复现 |
| P4 | 小批实现：契约先行→实现→测试到绿→文档 | 代码+docs/04-progress | 单测绿 |
| P5 | 按 standards 清单加固 + 证据落盘 | docs/05-testing | 清单逐项过 |
| P6 | README/运行手册/CHANGELOG/复盘/交付总结 | docs/07-ops | quality-gate 全绿 |

## 3. 质量门禁与文档检查

```bash
scripts/doc-check.sh        # FILE_INDEX 覆盖/断链/占位符/frontmatter + AGENTS.md 体积报警
scripts/quality-gate.sh     # 脚本语法 + doc-check + 构建测试自动探测（--skip-build 可跳过构建）
```

## 4. 会话交接（跨会话续接）

```bash
scripts/handoff.sh --session "..." --target "..." --done "..." --evidence "..." --blocker "..." --next "..."
scripts/journal.sh "本批内容（含失败与回退）"
scripts/experience.sh "主题" "场景" "问题" "根因" "解决"
```

- 会话结束三同步：`docs/04-progress/SESSION.md`（handoff.sh）+ 当日进度（journal.sh）+ `MEMORY.md`。
- 新会话启动：先读 SESSION.md → 向用户汇报"上次进度/下一步/待确认" → 确认后再动手。

## 5. DSH 插件项目（--kind dsh-plugin）

生成骨架按 `PLUGIN-DEV-STANDARD` 基线（若工作区存在该规范，以其为准）：
`package.json`（`dsh` 声明）+ 双 tsconfig + `scripts/build.mjs`（产物门禁：断言导出/客户端布局）+ `cordis.patch.yml` + `test/smoke-test.mjs` + `docs/specs/`（SDD 三件套骨架）。

开发循环（临时实例验证，未发布禁止上生产实例）：

```bash
pnpm check    # build(门禁) + typecheck(双端) + 冒烟
# 临时实例：DSH_HOME=$HOME/.dsh-<pkg>-test <dsh> web --port <临时端口>
# 用户确认后：link/tgz 安装到生产实例（重启需征得同意）
```