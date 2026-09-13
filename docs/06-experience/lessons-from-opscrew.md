---
title: opscrew-java 实战经验提炼（去劣取精华）
type: guide
status: active
version: 1.0.0
date: 2026-08-02
owner: AI + 维护人
applies_to: 项目文档
---

# opscrew-java 实战经验提炼（去劣取精华）

> 来源：opscrew-java（25 Maven 模块、10 个 Agent、50K+ 行 Java 的 AIOps 平台，3 个月高强度 AI 协作开发）。
> 本文是框架规则的主要依据：左边是 opscrew 踩过的坑/做对的事，右边是本框架的吸收方式。

## 一、值得吸收的精华（已进入框架）

### 1. 渐进式文档栈，避免一次性灌爆上下文

opscrew 的读法：README → CLAUDE.md（规则）→ ARCHITECTURE.md（宪法）→ MEMORY.md（状态）→ FILE_INDEX.md（索引）→ 需要时再进细节。

→ 本框架：README → AGENTS.md → MEMORY.md → FILE_INDEX → standards/ 按需加载（AGENTS.md §0）。

### 2. 文档诚实纪律（最重要的教训）

opscrew 规则 22：**文档宣称的能力必须已在代码落地，或标注"规划中/未实现"**。他们经历过文档吹嘘"自动化闭环"但代码不存在，后来专门做了代码审计整改（`java-code-audit-remediation.md`）。

→ 本框架：AGENTS.md §1 诚实纪律 7 条；`docs-alignment` 概念贯穿全部规范。

### 3. 铁律编号化 + 日期 + 原因

opscrew 的 CLAUDE.md 有 22 条编号铁律，每条带确立日期，实战踩坑后追加（如"docker -v 必须绝对路径"就是一次 462MB 文件污染事故换来的）。

→ 本框架：AGENTS.md §4 铁律表，新增规则强制编号+日期+触发原因。

### 4. ADR 决策记录

opscrew 有 ADR-001~023，每个显著决策（模块拆分、数据网关、FSM 并发控制）都有 背景/决策/影响/备选 四段。

→ 本框架：`docs/02-design/decisions/` 模板 + 触发条件（影响多模块/难回头/有备选）。

### 5. 单一真源（Single Source of Truth）

opscrew 踩过"两份 FSM 转移矩阵漂移"的坑（ADR-023），结论：状态矩阵、枚举、配置只存在一处。

→ 本框架：AGENTS.md 铁律 #4；每个规范都强调"以代码/配置为准，文档只做摘要"。

### 6. 并发控制用 CAS + 有界重试 + 失败兜底

opscrew ADR-023：状态更新必须 `UPDATE ... WHERE state=期望值`；空回复不推进状态机；报告子流程失败重试 3 次后强制收尾，防止事件卡死。

→ 本框架：AGENTS.md 铁律 #5；standards/reliability.md 幂等/CAS/有界重试。

### 7. 安全默认值：fail-closed

opscrew ADR-022：webhook 入口共享密钥鉴权、secret 为空启动即失败；清除 admin123 弱密码；凭证外部化（源码严禁字面量 IP/端口/密码）。

→ 本框架：AGENTS.md 铁律 #1/#2；standards/security.md。

### 8. 契约先行 + 团队边界

opscrew ADR-017：平台与业务团队之间只依赖 SDK 契约（接口），业务禁止依赖运行时实现类——这是他们能并行开发不互相踩脚的关键。

→ 本框架：AGENTS.md 铁律 #3；架构模板强制"模块只依赖契约"。

### 9. 测试证据落盘

opscrew 的测试报告目录带可执行脚本（`FTR-*/scripts/`），报告里的数字来自真实执行，验证命令固化可重跑。

→ 本框架：docs/05-testing/ 模板 + 证据规则 + scripts/quality-gate.sh。

### 10. 写后即验 + FILE_INDEX 维护

opscrew 知识库维护规范：任何 write 后立即二次确认；文件变更必查 FILE_INDEX。

→ 本框架：AGENTS.md §3 文档纪律 + scripts/doc-check.sh 自动检查。

### 11. 经验留痕机制

opscrew 用 MEMORY.md（状态/待办/硬约束）+ .claude.resume（会话摘要）+ 规范文件沉淀经验；bug 修复必追加 MEMORY.md。

→ 本框架：MEMORY.md + docs/06-experience/ + 铁律提升机制。

### 12. 统一管理入口

opscrew 的 manage.sh 统一启停/状态/日志，禁止绕过（防止手滑 docker stop）。

→ 本框架：scripts/ 统一工具层（init/doc-check/quality-gate/journal/experience）。

### 13. 冲突优先级与豁免声明

opscrew 架构宪法：生产安全 > 数据一致性 > 可审计 > 现有资产；豁免必须声明 范围/边界/回退。

→ 本框架：AGENTS.md Phase 1 §5。

### 14. 规模决策：复杂度的代价要明说

opscrew 从单 JVM 演进到 25 模块，每次拆分都有 ADR 论证。反面是：对"一句话项目"而言 25 模块是过度设计。

→ 本框架：最小可行栈原则（Phase 1），复杂度必须有 ADR 背书。

## 二、要去掉的糟粕（本框架刻意避免）

| 糟粕 | opscrew 的表现 | 本框架的做法 |
|------|----------------|-------------|
| **文档堆砌/重复** | 738 个 md 文件，README/ARCHITECTURE/MEMORY/FILE_INDEX 大量交叉重复，需定期"文档对齐"整改 | 每个文档单一职责，模板即最小集；重复内容以"单一真源"禁止 |
| **过度工程化** | 25 Maven 模块 + 5 管控进程 + 3 JVM 分组，对大多数项目是负担 | 最小可行栈；中间件/模块拆分必须 ADR 论证 |
| **环境硬编码进规范** | LLM 端口固定 8880、特定镜像名、特定 IP 写进铁律 | 规范只写原则与模式，具体值走 env/示例文件 |
| **Agent 权限配置过宽** | settings.local.json 有数百条精确允许规则，几乎不可维护 | 默认不做海量权限白名单；用最小权限模板 + 破坏性操作确认制 |
| **渐进加载反而需要看几十个文件** | 大量 SAD 分册、工程活动工艺全流程目录树很深 | 模板扁平化，最多两层（docs/0X-*/ 单文件） |
| **"文档对齐"成为常态化返工** | 因为文档先写后忘，需要专门的对齐审计 | 从源头禁止：写后即验 + 只宣称已验证 |

## 三、给 AI 协作的 5 条黄金经验

1. **上下文是稀缺资源**：文档要"渐进式加载"，Agent 入口文件（AGENTS.md）必须短而全。
2. **防幻觉靠证据**：让"完成"= "有测试证据 + 文档一致"，而不是 Agent 说完成。
3. **防回归靠单一真源**：任何事实只存一处，改代码前先问"这个矩阵/枚举/配置还有副本吗"。
4. **防卡死靠兜底**：状态机/重试/子流程必须有终态兜底，禁止"永久等待"。
5. **经验要制度化**：踩坑后不是写进聊天记录，而是提升为铁律/规范/经验库，让下一个会话继承。
