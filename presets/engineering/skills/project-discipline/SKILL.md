---
name: project-discipline
description: dsh-engineering-starter 框架操作手册：七阶段协议、目标锚定、init-project/doc-check/quality-gate 用法、dsh-plugin 骨架、中途需求变更协议、中断续接协议、视觉验收。新项目/新需求/需求变更/中断续接/交付前调用。
---

# project-discipline — dsh-engineering-starter 操作手册

> 本 skill 是 `skills/` 层的内容弹药：persona 只指路，细节在这里按需加载。
> 规则真源：`AGENTS.md`（协议与铁律）+ `standards/`（规范）。本 skill 不复制规则全文，只给操作路径。

## 何时调用

- 用户一句话需求要开新项目 / 加功能 / 修 Bug
- 交付前跑质量门禁
- 新会话要续接上次进度
- 生成 DSH 插件项目（`--kind dsh-plugin`）

## 0. 目标锚定（Phase 0 必做，防目标漂移）

> 来源：v2.1（2026-09-14）。扫雷会话教训：模型在第 5 次压缩后把"扫描过的其他插件"幻觉成"用户新需求"，
> 真实改了 15 个不相关文件，直到用户质问才发现。根因之一就是缺少目标项目路径的硬锚定。

1. **锁定目标项目路径**：澄清需求时同时确认「目标项目」= cwd 下的相对路径（如 `dsh-plugins/dsh-minesweeper`），
   写入 `docs/00-request/request.md` 的元数据（`## 目标项目` 段，含路径与一句话说明）。
2. **多项目联合开发**：用户要动多个项目时，显式声明「联合开发路径集合」：
   - 目标项目（写） + 联合项目（写/协作） + 参照项目（只读），分类列出；
   - 例：`目标: dsh-plugins/dsh-trading-workbench` + `参照: dsh-plugins/dsh-personal-workbench`（学习右侧栏注册模式）。
3. **路径白名单纪律**：
   - `write/edit` 只允许落在「目标项目 ∪ 联合项目」路径内；
   - 白名单之外（哪怕在工作区内）→ 只读参照；需要写入先停下、向用户说明并获确认；
   - 检查点：每次准备 write/edit 时扫一眼 `file_path` 是否在目标项目内。
4. **压缩后重申目标**：每次上下文压缩（checkpoint/compaction）后，先重读 `request.md` 的 `## 目标项目` 段，
   向用户确认"当前在做的事仍是目标项目内的吗"；发现 drift 立即停手报告，不得继续扩大。
5. **偏离即红线**：目标项目外的写操作 = 纪律事故，记录进当日进度日志（journal.sh），复盘根因。

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

## 6. 中途需求变更协议（会话中出现"新增/修改需求"时强制执行）

> 来源：v2.1（2026-09-14，铁律 17 的落地细则）。工作台插件会话的教训：中途需求口头消化、无验收基线、改完用户不满意。

1. 用户提新需求 / 修改已确认需求 → **暂停实现**，先做「变更登记」：
   - 抄用户原话进 `docs/specs/<id>/spec.md`（或 `docs/01-requirements/prd.md`）的**变更记录**：`v<x.y>（<日期>，用户反馈）` + 原话引用；
   - 更新 `tasks.md` 对应任务 DoD（受影响任务标"变更"并刷新验收标准）；
   - 新增/变更的**验收标准**写入 spec（A 编号递增），一行一标准。
2. **影响面评估**：涉及已实现代码 → 标注回归范围（哪些测试要重跑）；涉及架构决策 → 记 ADR/决策记录；跨阶段 → 回退到受影响阶段重走。
3. 变更经用户确认后（或用户明确"直接改"）才继续实现。**禁止"边听边改、口头消化"**。
4. 例外：纯文案/Bug 修复（无需求语义变化）可先改代码后补登记，但当日进度日志必须记录。

## 7. 视觉验收规则（主观标准必须证据化）

> 来源：v2.1（2026-09-14）。"高级简约/好看/流畅感"这类主观视觉标准，code-path 自证（DOM 几何/接口耗时）不足以保证满足用户。

- 涉及 UI/视觉/交互主观标准时，交付前必须产出**用户可看的证据**：
  - 截图（`vision_html_screenshot` / 平台截图）或可复现的验收步骤，`present` 给用户确认；
  - 无头浏览器 DOM 检查只作补充，不能替代视觉证据。
- 交互流畅性等可量化标准：给出改造前后对比数据（如 fetcher 调用次数、localStorage 写次数、渲染耗时）。
- 用户未确认视觉效果前，不得宣称"已优化/已高级简约"。用户说"不满意"时按 §6 变更协议重新登记。
## 8. 中断续接协议（进度真源三小节，文件形态无关）

> 来源：v2.1（2026-09-14）。解决"开发中断后下次怎么接上"：不依赖固定目录/文件名，
> 任何记进度的文件（`PROGRESS.md` / `tasks.md` / `SESSION.md` / `MEMORY.md` 中的任务清单）都适用。

1. **进度真源三小节**（约定结构，写进项目的进度文件）：
   ```
   ## ✅ 已完成（最新一批，含证据）
   ## 🔄 进行中（中断点：做到哪一步 / 卡在哪 / 还剩什么）
   ## ⏭ 下一步 + 待确认（下次会话从这里开始；含需用户拍板的事项）
   ```
2. **新会话首读**：会话开始第一件事——找到项目的进度真源文件，读 `🔄` 与 `⏭` 两节，
   向用户复述"上次进度 / 下一步 / 待确认"，**用户确认后才动手**。
3. **缺失即补**：找不到进度真源、或真源没有 `🔄`/`⏭` 小节但明显存在未完成工作
   （勾选未满 / 待办列表 / 未验证项 / 待重启生效）→ **先为用户补出这两节**再继续，
   从现有信息推断中断点，推断处标注「（推断）」；补写本身就是交接恢复的第一步。
4. **中断前必写**：任何中断（关闭会话 / 上下文压缩 / 用户离开 / 到达自然停点）前，
   必须把 `🔄` 与 `⏭` 更新为当前中断点。**写中断点比写完成更重要**。
5. **多项目工作区**（如 `dsh-plugins/`）：每个项目进度写各自目录的进度真源；
   工作区根索引文件（如 `progress.md`）只登记链接与全局事项，详情真源在各项目内；
   新会话先读根索引拿目录，再深入目标项目的真源。
