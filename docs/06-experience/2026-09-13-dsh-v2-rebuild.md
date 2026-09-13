---
title: "v2.0 DSH 专属重构复盘（2026-09-13）"
type: experience
status: active
version: 1.0.0
date: 2026-09-13
owner: AI + 维护人
---

# 经验 — v2.0 DSH 专属重构复盘

> 场景：把 aistarter（v1，Claude Code 兼容层）重构为 DSH 专属的 dsh-engineering-starter，
> 新增 dsh-plugin 脚手架 kind，并让生成项目能自举（自带协议/门禁/工具链解析）。
> 本次全部脚本改动均经真实执行验证（双 kind 生成 + 生成项目跑 `npm run check`/doc-check）。

## 踩坑与解决

| # | 现象 | 根因 | 解决 | 教训（已固化） |
|---|------|------|------|----------------|
| 1 | pnpm 布局下 `esbuild` 找不到，build.mjs 工具解析失败 | 只按 `node_modules/<pkg>` 扁平布局解析，而 deepseek-harness 用 pnpm（包在 `.pnpm/<pkg>@<ver>/` 里） | build.mjs/typecheck.mjs 增加 `node_modules/.pnpm/<name>@*` 兜底扫描（兼容 DSH_PLUGIN_TOOLS_DIR 指向 node_modules 或项目根） | 跨仓库复用工具链必须同时支持 npm 与 pnpm 两种布局 |
| 2 | typecheck 报 `Cannot find type definition file for 'node'` | 生成项目无 node_modules，`types:["node"]` 无处解析 | ①骨架 devDependencies 加 `@types/node`（npm install 即可）②typecheck.mjs 在借用外部工具链时补 `--typeRoots <tools>/@types` | 「干净环境可构建」（铁律 7）对生成物同样适用：依赖声明要能让用户一条 `npm install` 走通 |
| 3 | 产物门禁失败：`lib/client.js 未包含插件 id` | 占位符只替换 `.tpl` 文件，`src/*.ts` 里的 PROJECT_NAME 占位符原样进了 bundle | kind 文件统一走占位符替换（find -type f 全量实例化，`.tpl` 仅控制输出名） | 模板占位符的替换范围 = 所有会被实例化的文件，而不是「长得像模板的文件」 |
| 4 | 生成项目 doc-check 报 `docs/specs/README.md` 缺 frontmatter | 框架仓的 scaffold 文件被 doc-check 豁免，生成项目里它落在 `docs/` 下不再豁免 | 模板文件自带 frontmatter（模板自身合规）；doc-check 豁免清单两侧对齐（`docs/specs/_template/*` 占位符豁免） | 「框架里能过」≠「生成项目能过」：门禁必须在生成物上再跑一遍才算验证 |
| 5 | `init-project.sh` 对非空目录静默失败（旧目录残留导致假通过） | 目标目录非空直接报错退出，但上一轮测试残留未清理 | 测试流程固定 `rm -rf` 再 init；脚本保持「非空即拒」的安全行为 | 自动化验证前先清场，否则上一轮产物污染下一轮结论 |

## 设计决策（v2.0 定案）

- **薄 persona + 厚协议**：preset persona 只含入口纪律（~20 行），规则全文唯一住在项目 `AGENTS.md`
  → 铁律 4（单一真源）+ 16（system prompt 节约）成为框架的一等公民，v1 的「persona 里塞规则」被明确废弃。
- **kind 机制**：`--kind generic|dsh-plugin`，kind 文件 = 占位符模板集合（`scaffold/kinds/<kind>/`），
  通用骨架与 kind 模板正交；SDD 三件套（spec→plan→tasks）作为 dsh-plugin 的强制流程内置在骨架里。
- **工具链自举**：生成项目不假设框架在场——`DSH_PLUGIN_TOOLS_DIR` 环境变量 + 本地 node_modules 双通道，
  使「生成 → npm install → npm run check」在干净机器上闭环。

## 验证清单（本次实际执行）

- [x] `bash -n` 全部 scripts 语法通过
- [x] 框架仓 doc-check / quality-gate 全绿（0 错误 0 警告）
- [x] generic kind 生成项目 doc-check 0 错误
- [x] dsh-plugin kind 生成项目：`npm run check`（esbuild 双端 + 产物门禁 + 双 typecheck + 冒烟）全绿
- [x] `install-dsh.sh` 实跑：preset→`~/.dsh-dev/.agent-presets/engineering/`（旧版备份 .bak-20260913-211243），
      skills→`~/.agents/skills/`（grill-me/grilling 覆盖备份，project-discipline 新增），新会话技能目录已生效

## 待办

- 验收测试：新工程模式会话一句话「开发 dsh-minesweeper 扫雷插件」，跑通七阶段 + SDD，3084 验收。
- 旧仓库 `IamWWT/project-framework-aistarter` 删除（等用户验收后执行，见 MEMORY.md 待办）。