---
title: FILE_INDEX - 文件索引
type: index
status: active
version: 2.0.0
date: 2026-09-13
owner: AI + 维护人
applies_to: 本框架仓库
---

# FILE_INDEX - 文件索引

> 由 Agent 维护：每次新增/删除/移动文件后更新本表（`scripts/doc-check.sh` 强校验覆盖）。
> v2.0（DSH 专属版）重建：2026-09-13。

## 根目录

- README.md - 框架总览（是什么/两种用法/设计原则/血缘）
- MANUAL.md - 使用手册（人：安装/使用/维护/FAQ）
- AGENTS.md - Agent 总协议（入口：七阶段/诚实纪律/17 条铁律/冲突处理）
- MEMORY.md - 框架自身状态/待办/硬约束
- LICENSE - Apache License 2.0

## presets/（DSH agent preset）

- presets/README.md - preset 说明（安装方式/薄 persona 设计原则）
- presets/engineering/ - 工程模式 preset（preset.yml + agent.cordis.yml）

## presets/engineering/skills/（随包 skill，随 preset 走）

- presets/engineering/skills/README.md - skill 清单与安装说明
- presets/engineering/skills/grill-me/SKILL.md - 需求拷问（Phase 0 强制；薄包装→grilling）
- presets/engineering/skills/grilling/SKILL.md - 拷问方法论（MIT，源自 mattpocock/skills）
- presets/engineering/skills/project-discipline/SKILL.md - 框架操作手册（init/门禁/中途需求变更协议/视觉验收/插件开发循环）

## scaffold/（脚手架）

- scaffold/README.md - 脚手架用法（generic / dsh-plugin 两种 kind）
- scaffold/kinds/dsh-plugin/KIND_NOTES.md - dsh-plugin 追加纪律（注入生成项目 AGENTS.md §2A）
- scaffold/kinds/dsh-plugin/docs/specs/README.md - SDD 规格目录说明
- scaffold/kinds/dsh-plugin/docs/specs/_template/README.md - 三件套模板说明
- scaffold/kinds/dsh-plugin/docs/specs/_template/spec.md - SDD spec 模板
- scaffold/kinds/dsh-plugin/docs/specs/_template/plan.md - SDD plan 模板
- scaffold/kinds/dsh-plugin/docs/specs/_template/tasks.md - SDD tasks 模板

> 其余 scaffold 文件（templates/*.tpl、kinds 的 package.json/tsconfig/构建脚本等）非 markdown，
> 由 `scripts/init-project.sh` 实例化，详见 scaffold/README.md。

## docs/（本框架自身文档）

- docs/README.md - 文档体系总览
- docs/glossary.md - 术语表
- docs/FILE_INDEX.md - 本文件
- docs/00-request/README.md - 需求摄入协议
- docs/00-request/example-request.md - 需求摄入示例
- docs/00-request/minesweeper-request.md - v2.0 验收测试需求：dsh-minesweeper 插件
- docs/01-requirements/prd-template.md - PRD 模板
- docs/02-design/architecture-template.md - 架构模板
- docs/02-design/decisions/README.md - ADR 规范
- docs/02-design/decisions/adr-template.md - ADR 模板
- docs/03-plan/tasks-template.md - 任务计划模板
- docs/04-progress/README.md - 进度日志规范
- docs/05-testing/README.md - 测试报告规范
- docs/06-experience/README.md - 经验库规范
- docs/06-experience/lessons-from-opscrew.md - opscrew 实战经验提炼（v1 血缘）
- docs/06-experience/2026-09-13-dsh-v2-rebuild.md - v2.0 DSH 专属重构复盘（踩坑/设计决策/验证清单）
- docs/07-ops/README.md - 运行手册规范

## standards/（生产级规范）

- standards/README.md - 规范总览
- standards/security.md - 安全
- standards/reliability.md - 可靠性
- standards/performance.md - 性能
- standards/observability.md - 可观测
- standards/testing.md - 测试
- standards/code-style.md - 代码风格
- standards/documentation.md - 文档纪律
- standards/process.md - 工艺流程
- standards/interfaces.md - 接口管理
- standards/quality-gates.md - 质量门禁
- standards/enterprise/README.md - 企业规范（收纳/导入/优先级）
- standards/languages/java.md - Java 适配
- standards/languages/python.md - Python 适配
- standards/languages/rust.md - Rust 适配
- standards/languages/go.md - Go 适配
- standards/languages/node.md - TypeScript/Node 适配

## scripts/（工具脚本，非 markdown 列名备查）

scripts/init-project.sh（--kind generic|dsh-plugin）/ doc-check.sh / quality-gate.sh /
journal.sh / experience.sh / handoff.sh / cleanup-framework.sh / project-lib.sh / install-dsh.sh

## prompts/（一句话指令模板）

- prompts/README.md - 用法总览（自然语言控制）
- prompts/new-project.md - 新项目
- prompts/feature.md - 新功能
- prompts/bugfix.md - Bug 修复
- prompts/review.md - 评审
- prompts/report.md - 复盘/报告
- prompts/import-standards.md - 导入企业规范