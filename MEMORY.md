# MEMORY.md — dsh-engineering-starter 项目记忆（当前状态 / 待办 / 硬约束）

> Agent 与开发者共同维护。每次会话结束前更新。
> 完整工作协议 → `AGENTS.md` | 文件索引 → `docs/FILE_INDEX.md`

## 0. 新会话必读顺序

| # | 文件 | 说明 |
|---|------|------|
| 1 | `README.md` | 框架是什么（1 分钟） |
| 2 | `AGENTS.md` | 协议与铁律（全文读完） |
| 3 | 本文件 | 当前状态/待办/硬约束 |
| 4 | `docs/04-progress/SESSION.md` | 最近交接单（若存在，先恢复进度再动手） |
| 5 | `docs/00-request/request.md` | 当前需求与假设（若有进行中任务） |

## 1. 当前状态

| 项目 | 状态 |
|------|------|
| **v2.0 DSH 专属重构**（2026-09-13 完成） | ✅ 完成：preset/skills/scaffold(双 kind)/scripts 全部落地，doc-check + quality-gate 全绿；`install-dsh.sh` 实跑成功（preset→`~/.dsh-dev/.agent-presets/engineering/`，旧版备份 `.bak-20260913-211243`；skills→`~/.agents/skills/`，新会话已识别 grill-me/grilling/project-discipline）；仓库已推送 `github.com/IamWWT/dsh-engineering-starter`（私有，Apache-2.0） |
| 验收测试 | 待办：用户开新工程模式会话发"开发 dsh-minesweeper 扫雷插件"（规格见 `docs/00-request/minesweeper-request.md`），3084 临时实例验收 → 用户确认 → 3082 |
| 复盘 | ✅ `docs/06-experience/2026-09-13-dsh-v2-rebuild.md`（踩坑 5 条 + 设计决策 + 验证清单） |
| 血缘 | v1 = project-framework-aistarter（opscrew 实战提炼，Claude Code 兼容层）；v2.0 = DSH 专属重写，v1 仓库已弃用并将删除 |

### v2.0 变更清单（相对 v1）

- 移除 CLAUDE.md 与 Claude Code/Codex 兼容层 → 协议入口统一 `AGENTS.md`（DSH 原生）
- 新增 `presets/engineering/`（薄 persona + 工具集），`scripts/install-dsh.sh` 一键安装
- 新增 skills：`grill-me`（Phase 0 强制澄清）+ `grilling`（方法论，MIT）+ `project-discipline`
- `init-project.sh --kind generic|dsh-plugin`；`scaffold/kinds/dsh-plugin/`（dsh 字段/双 tsconfig/build.mjs 产物门禁/SDD 三件套/冒烟）
- 铁律新增 #16（system prompt 节约）#17（需求先 grill-me 澄清）
- `doc-check.sh` 新增 AGENTS.md 体量检查；`project-lib.sh` FILE_INDEX 生成去 CLAUDE.md

## 2. 待办（Pending）

| # | 事项 | 优先级 |
|---|------|:---:|
| 1 | ~~推送新 GitHub 仓库 `IamWWT/dsh-engineering-starter`~~ | ✅ 2026-09-13 已推送（私有，Apache-2.0） |
| 2 | ~~运行 `scripts/install-dsh.sh`~~ | ✅ 2026-09-13 已装（preset→`~/.dsh-dev/.agent-presets/engineering/`，skills→`~/.agents/skills/`，旧版有 `.bak` 备份） |
| 3 | 用户验收新仓库后删除旧仓库 `IamWWT/project-framework-aistarter`（不可逆，需用户最终口头确认） | P0（等用户点头） |
| 4 | 验收测试：新工程模式会话开发 `dsh-minesweeper`（触发语"开发 dsh-minesweeper 扫雷插件"，3084 临时实例 → 用户验收 → 3082） | P1 |
| 5 | 复盘：v2.0 部分 ✅（`docs/06-experience/2026-09-13-dsh-v2-rebuild.md`）；扫雷验收结论待验收后补 | P1 |

## 3. 硬约束（违反即错）

| # | 规则 |
|---|------|
| 1 | 文档与实现一致；未实现标"规划中/未实现" |
| 2 | 源码禁硬编码密钥/IP/端口；凭证默认空 |
| 3 | 文件变更必查 `docs/FILE_INDEX.md` |
| 4 | 破坏性操作（删仓库/删数据/覆盖）先用户确认，且保留回滚路径 |
| 5 | 证据=真实命令输出，禁止虚构 |
| 6 | **3082 生产红线**：未经验证的插件改动禁止上 3082；一律先 3084 临时实例 |
| 7 | 规则单一真源：协议全文只在 AGENTS.md；preset persona 不复制规则（铁律 4/16） |

## 4. 经验速查（详见 docs/06-experience/）

- 大项目文档最易腐烂：靠"单一真源 + FILE_INDEX + 写后即验"防。
- Agent 最易虚报完成：靠"证据落盘 + 诚实纪律"防。
- 经验不沉淀 = 每次重来：任务后记经验，一般性教训提升为铁律。
- （v2.0 新增）system prompt 是稀缺预算：persona 只放入口纪律，重内容走文件/skill 渐进加载。
- （v2.0 新增）需求一句话里藏着大量未说出口的假设：先 grill-me 再动手，返工率显著下降。