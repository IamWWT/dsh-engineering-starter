# AGENTS.md — DSH 工程模式总纲（dsh-engineering-starter）

> 本文件是 Agent（DSH 工程模式 / 兼容 Agent）的**单一入口**。
> 用户一句话需求 → 你按本协议交付生产级项目，每一步诚实落文档。
> 给人看的：README.md（是什么）/ MANUAL.md（怎么用）。

---

## 0. 必读顺序（渐进加载，不要一次读完全部）

1. `README.md` — 框架是什么（1 分钟）
2. 本文件 — 协议与铁律（全文读完）
3. `standards/README.md` + 任务相关的 2-3 份规范（按需）
4. `docs/README.md` + `docs/FILE_INDEX.md`
5. `docs/04-progress/SESSION.md`（存在则先读，恢复上次进度）
6. `docs/00-request/request.md`（不存在则按 Phase 0 创建）

默认中文写文档，跟随用户习惯。上下文是稀缺资源：按需加载，用到再读（铁律 16）。

---

## 1. 诚实纪律（7 条，最高优先级，不可违反）

1. **只宣称已验证的事实** — "已实现/已支持"必须能指到代码与测试证据；未做的标"规划中/未实现"。
2. **写后即验** — 每次写文件/改代码后立即验证（编译/测试/脚本执行），验证结果写入进度日志。
3. **失败如实记录** — 进度日志必须含失败、回退、修复过程，禁止只报喜。
4. **证据=真实命令输出** — 测试报告/基准数据来自实际执行的命令输出，禁止虚构。
5. **假设留痕** — 需求不明做合理假设写入 `docs/00-request/request.md` 假设表（含依据与影响）；仅不可逆/高风险决策停下来问（一次最多 3 问）。
6. **文档与实现同步** — 宣称任何能力前确认代码存在；文件变更后核对 `docs/FILE_INDEX.md`。
7. **破坏性操作先确认** — 删数据/`reset --hard`/覆盖他人文件/批量改写，先说明影响面与回滚预案并等用户确认。

---

## 2. 七阶段执行协议

| 阶段 | 产物 | 完成标准 |
|---|---|---|
| P0 需求摄入 | `docs/00-request/request.md` + `docs/01-requirements/prd.md` | 需求经 grill-me 澄清（或用户明确免问）；每个 P0 需求有可测试验收标准 |
| P1 设计与选型 | `docs/02-design/architecture.md` + `decisions/`（ADR） | 最小可行栈；显著决策有 ADR；模块只依赖契约 |
| P2 任务计划 | `docs/03-plan/tasks.md` | 每任务有 DoD；每批可独立验证 |
| P3 脚手架 | 骨架 + `.env.example` + CI/构建配置 | 空壳 build+test 在干净环境通过 |
| P4 增量实现 | 每批：代码+测试+文档+经验 | 单测绿；FILE_INDEX/MEMORY/进度日志已更新 |
| P5 测试加固 | `docs/05-testing/` 带证据报告 | 安全/可靠性/性能/可观测清单逐项过完 |
| P6 交付复盘 | README/运行手册/CHANGELOG/复盘/交付总结 | `quality-gate.sh` 全绿；已知限制列明 |

### Phase 0 细节

1. **需求澄清用 grill-me skill**：一句话需求先调用 `grill-me` 做 relentless 追问（目标/范围/边界/优先级/非目标），达成共识后再动笔；用户明确说"不用问直接做"时跳过，改走假设表。
2. 用户原话完整抄入 `request.md`，提炼目标/约束，写**假设表**（假设+依据+影响）。
3. 新项目：`scripts/init-project.sh <目录> --lang … --kind generic|dsh-plugin` 生成骨架（DSH 插件项目用 `--kind dsh-plugin`）。
4. 企业规范：`standards/enterprise/_inbox/` 有文件则按 `standards/enterprise/README.md` 转化，列为 PRD 非功能约束。
5. 若仓库由框架整体拷贝而来（存在框架元文档），先跑 `scripts/cleanup-framework.sh`。

### 与 DSH 机制的对应

- **复杂改动** → 先进 plan 模式（决策完备方案：目标/验收/子系统分组/API 与数据流变化/边界与失败模式/测试），批准后再实施。
- **长任务/跨会话** → goal 跟踪；结束前按 §3 交接协议更新交接单。
- **批量独立子任务** → subagent；大批量流程 → workflow（用户要求时）。
- 每阶段产物必须落 `docs/`，禁止只留在对话里。

### Phase 1-6 摘要（全文见 `standards/process.md` 与各 docs 分册）

- **P1**：最小可行栈（每个中间件都要理由）；选型对照表（成熟度/性能/熟悉度/运维成本/许可证）；显著决策（影响多模块/难回头/有备选）写 ADR；冲突优先级：生产安全 > 数据一致性 > 可审计 > 现有资产，豁免必须声明范围/边界/回退。
- **P2**：里程碑 M0 脚手架→M1 核心→M2 完整→M3 加固；每任务含输入/动作/DoD/依赖/验证命令；禁止大爆炸式任务。
- **P3**：构建系统/目录/`.env.example`/CI/lint/测试框架齐备；**空壳先跑通再写业务**。
- **P4**：契约先行（接口/错误语义先于实现）→ 实现 → 跑测试到绿 → 更新文档 → 小提交（类型前缀）→ 每里程碑跑 `quality-gate.sh`。
- **P5**：单测（快/确定）+ 集成（真实依赖）+ 关键路径 E2E；对照 `standards/{security,reliability,performance,observability,testing}.md` 逐项过；证据（命令+输出）落 `docs/05-testing/`。
- **P6**：README/运行手册/CHANGELOG（只列已实现）+ 经验沉淀 + 复盘 + 交付总结（含已知限制）。

---

## 3. 文档纪律

- **Frontmatter**：正式文档（PRD/ADR/架构/计划/报告/规范）必须有 YAML 头；流水账不需要。
- **索引**：任何文件增删移动后更新 `docs/FILE_INDEX.md`（`scripts/doc-check.sh` 强校验）。
- **引用**：交叉引用必须可解析；变更按 `standards/documentation.md` §4.2 依赖矩阵联动，禁止复制内容代替引用。
- **必要性**：每份文档回答"没有它会出什么问题"；七类信息（需求/决策/过程/经验/状态/契约/证据）禁止只存在于对话。

| 事件 | 必须更新 |
|---|---|
| 文件变化 | `docs/FILE_INDEX.md` |
| 需求/假设变化 | `docs/00-request/request.md` |
| 架构决策 | `docs/02-design/decisions/`（ADR） |
| 每批完成 | `docs/04-progress/<日期>.md`（含失败与回退） |
| 测试完成 | `docs/05-testing/`（命令+输出证据） |
| 状态/待办变化 | `MEMORY.md` |
| 一般性教训 | `docs/06-experience/` + 必要时提升为 §4 铁律 |

**会话交接（新会话启动协议）**：按 §0 读取（SESSION.md 优先于 request.md）→ 先向用户汇报"上次进度/下一步/待确认" → 确认后再动手。结束前用 `scripts/handoff.sh` 更新 SESSION.md + 当日进度（`scripts/journal.sh`）+ `MEMORY.md`。

---

## 4. 编码铁律（编号+日期；只增不删，新增必须带日期与触发原因）

| # | 规则 | 确立 |
|---|------|------|
| 1 | 参数外化：源码禁硬编码密钥/IP/端口/URL；凭证默认值为空 | v1 |
| 2 | fail-closed：外部入口必须鉴权；鉴权密钥为空拒绝启动 | v1 |
| 3 | 契约先行：模块间只依赖接口契约，不依赖实现 | v1 |
| 4 | 单一真源：每个事实只存一处（规则/配置/矩阵禁止双写漂移） | v1 |
| 5 | 并发安全：状态变更用 CAS；消费幂等；有界重试（2-3 次）后升级或明确失败 | v1 |
| 6 | 测试宪法：单测快而确定；集成用真实依赖；关键路径 E2E；证据落盘 | v1 |
| 7 | 可复现构建：依赖锁版本；干净环境可构建 | v1 |
| 8 | 显式失败：禁吞异常；fail-soft 有日志+兜底；超时/重试/熔断可配置 | v1 |
| 9 | 性能靠基准：无基准不写数字；大数据量禁深 OFFSET（用 keyset） | v1 |
| 10 | 文档与实现一致：宣称能力前确认代码存在 | v1 |
| 11 | 破坏性操作需确认（见 §1.7） | v1 |
| 12 | 经验必留痕：任务后记教训；一般性教训提升为铁律/规范 | v1 |
| 13 | 文档工程合规：frontmatter + FILE_INDEX 登记 + 可解析引用；接口契约留痕 | v1.0.2 |
| 14 | 企业规范优先：`standards/enterprise/` 是硬约束，冲突时以其为准（安全红线除外，升级用户裁决） | v1.0.5 |
| 15 | 会话交接必留痕：SESSION.md + 当日进度 + MEMORY.md 三同步；新会话先读交接单再动手 | v1.0.6 |
| 16 | system prompt 节约：进 system prompt 的内容（本文件/preset persona）必须薄；重内容走渐进加载（按需读文件、按需调 skill） | v2.0 |
| 17 | 需求澄清优先：一句话需求先 grill-me 澄清再动手（用户明确免问除外） | v2.0 |

---

## 5. 质量门禁（Definition of Done）

- **每次提交**：lint/单测通过；无硬编码密钥（`rg` 抽查）；FILE_INDEX 已同步。
- **每里程碑**：`scripts/doc-check.sh` 通过 + 集成测试（真实依赖）+ 进度日志（含失败）。
- **交付/发布**：`scripts/quality-gate.sh` 全绿 + 安全/可靠性清单过完 + 性能基准（或注明未测）+ 交付总结列明已知限制与未实现项。

---

## 6. 目录地图（本框架自身）

```
AGENTS.md        # 本文件（Agent 入口，保持薄）
README.md        # 给人看的总览
MANUAL.md        # 使用手册（人）
MEMORY.md        # 框架自身状态/待办/硬约束
presets/         # DSH agent preset（工程模式）→ install-dsh.sh 装到 $DSH_HOME/.agent-presets/
skills/          # 随包 skill：project-discipline（框架操作手册）+ grilling/grill-me（需求澄清）
standards/       # 生产级规范（语言无关 + languages/ + enterprise/）
prompts/         # 一句话指令模板（自然语言，给人在 DSH 里发）
scaffold/        # 新项目模板（generic + dsh-plugin 两种 kind）
scripts/         # init-project / install-dsh / doc-check / quality-gate / handoff / journal / experience
docs/            # 本框架自身文档；00-request~07-ops 模板分册兼作生成项目的模板源
projects/        # 用法一：在本仓库内开发的项目（每项目一目录，如 projects/dsh-minesweeper）
```

**新项目怎么产生**：优先在本仓库 `projects/<项目名>/` 下按本协议执行；或 `scripts/init-project.sh <目录> --lang … --kind …` 生成独立项目（自带 AGENTS/docs/standards/scripts，任何 Agent 打开即可用）。

---

## 7. 冲突处理

- 需求冲突：以最新用户意图为准，记录变更原因。
- 文档冲突：以代码实现为准，修正文档并在进度日志记录。
- 规范冲突：生产安全 > 数据一致性 > 可审计 > 现有资产；豁免必须显式声明范围/边界/回退。
- preset persona 与项目 AGENTS.md 冲突：以项目 AGENTS.md 为准（persona 只是入口与兜底）。
- 铁律冲突：先满足 §1 诚实纪律，再执行具体规则；拿不准就停下来问用户。