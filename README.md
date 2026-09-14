# dsh-engineering-starter — DSH 工程模式

> 给 **DeepSeek Harness（DSH）** 的工程模式全家桶：一个 agent preset + 三个 skill +
> 一套项目工程协议（AGENTS.md / standards / scripts）+ 脚手架（普通项目与 DSH 插件两种）。
>
> 你在 DSH 里发一句话，工程模式 Agent 走**七阶段流程**（需求澄清→设计→计划→脚手架→
> 增量实现→测试加固→交付复盘）交付生产级软件——每个结论有证据，每步诚实落文档，
> 需求先拷问（grill-me）再动手。适用于**所有软件项目**，也专门覆盖 **DSH 插件开发**。

```
你：开发 dsh-minesweeper 扫雷插件
Agent：（grill-me 拷问目标/范围/边界）→ 写 request.md（含假设表）→ 写 spec.md 给你确认
       → SDD 三件套 → 脚手架 → 增量实现（每批：代码+测试+进度）→ 临时实例 3084 验收
       → 你验收通过 → 才谈安装到生产
```

---

## 包含什么

| 组成 | 位置 | 作用 |
|---|---|---|
| **工程模式 preset** | `presets/engineering/` | DSH agent 平面组合：薄 persona（入口+兜底纪律）+ 工具集 + plan/compaction 策略。装到 `$DSH_HOME/.agent-presets/engineering/` |
| **skills** | `presets/engineering/skills/` | 随 preset 走、preset 层注册（shadow 全局同名技能，不动 `~/.agents/skills`）：`grill-me`（需求拷问，Phase 0 强制）、`grilling`（方法论，MIT，来自 mattpocock/skills）、`project-discipline`（框架操作手册） |
| **工程协议** | `AGENTS.md`（根）+ `standards/` | 七阶段流程 + 17 条铁律 + 安全/可靠性/性能/可观测/测试/文档规范 + 语言适配。生成项目的单一真源 |
| **指令模板** | `prompts/` | 一句话指令模板（自然语言，无控制词）：新项目/功能/Bug/评审/复盘/导入企业规范 |
| **脚手架** | `scaffold/` + `scripts/init-project.sh` | 两种 kind：`generic`（任意语言应用）/ `dsh-plugin`（DSH 插件：双 tsconfig、esbuild 双端构建+产物门禁、SDD 规格骨架、冒烟测试） |
| **安装器** | `scripts/install-dsh.sh` | 一键把 preset+skills 装进你的 DSH（幂等、自动备份、可 `--uninstall`） |

## 快速开始（3 步）

```bash
# 1. 安装 preset（含随包 skills/，幂等；默认 $DSH_HOME=~/.dsh-dev；不写 ~/.agents/skills）
scripts/install-dsh.sh

# 2. 在 DSH 里开一个新会话，选「工程模式」，workspace 指向要开发的项目
#    （可以是本仓库本身，或任何已有项目目录）

# 3. 发一句话
#    “开发 dsh-minesweeper 扫雷插件”
```

Agent 会先 grill-me 拷问需求 → 写 `docs/00-request/request.md`（原话+假设表）→
按七阶段推进，关键产物（PRD/架构/规格）呈现给你确认。

## 两种用法

### 用法一：在任意项目里用工程模式（最常用）

任意项目目录（DSH 里选工程模式、workspace 指向该目录）。若项目没有 `AGENTS.md`，
preset 的兜底纪律 + `project-discipline` skill 会引导 Agent 按本框架协议开工；
建议先跑一次 `init-project.sh` 把完整协议（AGENTS.md/standards/scripts/docs 骨架）带进项目。

### 用法二：从零生成项目

```bash
# 普通应用
scripts/init-project.sh ../my-service --lang go --name "短链接服务" --git

# DSH 插件
scripts/init-project.sh ../dsh-minesweeper --kind dsh-plugin --git
```

生成一个**自包含**项目：自带 AGENTS.md（协议）、standards/、scripts/（门禁）、
docs/ 骨架；DSH 插件 kind 额外带 package.json（dsh 字段）、双 tsconfig、
`scripts/build.mjs`（产物门禁）、`test/smoke-test.mjs`、`docs/specs/`（SDD 三件套模板）。
之后在该目录开工程模式会话即可，框架仓库本身无需在场。

## 设计原则（为什么长这样）

1. **薄 persona，厚协议**（铁律 4 单一真源）：规则全文只住在一处——项目的 `AGENTS.md`；
   preset persona 只是入口开关与兜底纪律（~20 行），不复制任何规则。
2. **system prompt 经济**（铁律 16）：进 system prompt 的东西必须薄；重内容
   （规范/操作手册）走渐进加载——按需读文件、按需调 skill。
3. **需求先拷问**（铁律 17）：一句话需求先 `grill-me` 澄清再动手；用户说"不用问"才跳过。
4. **无机器路径**：preset/skills/协议里没有任何本机绝对路径，换机器 `install-dsh.sh` 即复刻。
5. **诚实纪律**：只宣称已验证的事实；写后即验；失败入日志；证据=真实命令输出。
   （完整 7 条见 `AGENTS.md` §1）

## 血缘

本仓库是 `project-framework-aistarter`（v1，opscrew 实战提炼）的 **DSH 专属重构版**：
协议内核（七阶段/铁律/规范/脚手架）全部保留并更新，Claude Code/CLAUDE.md 机制移除，
全面改为 DSH 语义（preset/skill/plan/goal/subagent）。v1 的 GitHub 仓库已删除，
本仓库是唯一维护源。经验沉淀见 `docs/06-experience/`。

## License

Apache-2.0（见 [LICENSE](LICENSE)）。
`presets/engineering/skills/grilling` 源自 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT）。