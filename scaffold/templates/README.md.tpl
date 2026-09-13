# {{PROJECT_NAME}}

> 创建: {{DATE}} | 语言: {{LANG}}（未指定则见 docs/02-design/architecture.md 选型）

## 项目简介

{{PROJECT_DESC}}

## 快速开始

```bash
# 环境要求与配置
cp .env.example .env       # 然后填入真实值（密钥留空则服务拒绝启动）

# 安装依赖 / 构建 / 测试（见 standards/languages/{{LANG}}.md）

# 启动
```

## 文档导航

```
README.md            # 本文件（给人看）
AGENTS.md            # Agent 工作协议
MEMORY.md            # 当前状态/待办
docs/FILE_INDEX.md   # 文件索引
docs/00-request/     # 需求与假设
docs/02-design/      # 架构与 ADR
docs/04-progress/    # 诚实进度日志
docs/05-testing/     # 测试报告（带证据）
docs/06-experience/  # 经验库
docs/07-ops/         # 运行手册
standards/           # 生产级规范
```

## 已知限制

- （交付前由 Agent 如实列出）
