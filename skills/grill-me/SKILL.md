---
name: grill-me
description: 需求澄清拷问：在动手前用 relentless 追问把一句话需求逼成共享理解（设计树/前沿问题/推荐答案）。工程模式 Phase 0 的默认澄清方式。
disable-model-invocation: false
---

# grill-me（随包版，源自 mattpocock/skills，MIT）

对需求/计划/设计做 relentless 追问，直到达成共识再动手。

调用方式：加载 `grilling` skill（本目录同级），按其协议执行——设计树 → 前沿问题 → 每轮整批问（编号+推荐答案）→ 用户回答后重算前沿 → 前沿清空且用户确认共识后才可以动手。

## 工程模式 Phase 0 用法

1. 用户发来一句话需求 → 立即进入 grilling，把需求当设计树拆解（目标/用户/范围/非目标/技术约束/边界/验收）。
2. 事实自己查（读文件/跑只读命令），只把**决策**抛给用户。
3. 用户说"不用问直接做/自动模式"时退出 grilling，转假设表模式（假设+依据+影响写入 request.md）。
4. 共识达成后：原话+澄清结论+假设表 → `docs/00-request/request.md`，再进入 PRD。