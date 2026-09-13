# presets/ — DSH agent preset（工程模式）

本目录是**工程模式**的 preset 源（单一真源）。安装到 DSH：

```bash
scripts/install-dsh.sh            # 安装 preset + skills（幂等，自动备份旧文件）
scripts/install-dsh.sh --uninstall # 卸载（恢复到备份）
```

- `preset.yml`：显示名与描述（新会话选择器里看到的"工程模式"）。
- `agent.cordis.yml`：agent 平面组合——persona（薄入口+兜底纪律）、工具集（bash/fs/jobs/skills/goal/plan/subagent/web）、plan 模式、compaction。

## 设计原则（为什么 persona 是薄的）

1. **单一真源**（铁律 4）：规则全文住在项目 `AGENTS.md` / `standards/`，persona 只做"入口开关 + 无 AGENTS.md 时的兜底纪律"，禁止双写。
2. **system prompt 节约**（铁律 16）：persona 约 20 行是固定开销；重内容（七阶段操作细节、脚本用法、规范）走 skill 按需加载。
3. **可移植**：persona 不含任何机器路径/用户名，换机器 `install-dsh.sh` 即复刻。

## 其他模式

本仓库只托管 engineering preset。研究/排障/学习等模式属个人工作流，建议单独版本管理（如独立 preset 仓库），避免与工程纪律耦合。