#!/usr/bin/env bash
# ============================================================================
# install-to-dsh.sh — DSH 插件一键安装（构建→冒烟→安装→验证），幂等可重跑
#
# 红线（PLUGIN-DEV-STANDARD §7）：
#   - 未经验证的改动禁止装生产实例；本脚本目标默认指向「当前 DSH_HOME」。
#   - 开发期用 link 安装（pnpm link / npm link）；tgz 仅用于稳定版（升版本号）。
#   - 生产（3082）只在用户明确同意后才重启/重载；其余走临时实例 3084 验证。
#
# 用法：
#   scripts/install-to-dsh.sh            # 构建+冒烟+安装到 $DSH_HOME（默认）
#   TARGET_DSH_HOME=$HOME/.dsh-test scripts/install-to-dsh.sh   # 指向临时实例
# ============================================================================
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> [1/4] 构建 + 产物门禁 + 冒烟"
node "$ROOT/scripts/build.mjs"
node "$ROOT/test/smoke-test.mjs"

DSH_HOME_TARGET="${TARGET_DSH_HOME:-$DSH_HOME:-$HOME/.dsh}"
echo "==> [2/4] 目标 DSH_HOME: $DSH_HOME_TARGET"
[ -d "$DSH_HOME_TARGET" ] || { echo "错误: $DSH_HOME_TARGET 不存在（临时实例请先用 pnpm dsh web 初始化）" >&2; exit 1; }

echo "==> [3/4] 安装（link 方式，幂等）"
# 默认走 link：pnpm/npm link 到目标实例的 plugins 目录。
# 具体安装命令以本机 deepseek-harness 的插件安装约定为准
# （见 dsh-plugins/DEV-WORKFLOW-GUIDE.md §安装）；骨架阶段此处保留占位，
# 进入 SDD Implement 后按实际 loader 机制补全并删除本注释。
( cd "$ROOT" && npm pack --dry-run >/dev/null && echo "  pack 校验通过（tgz 布局完整）" )
# TODO(SDD): 补全实际安装动作（link 或 tgz），保持本脚本幂等。

echo "==> [4/4] 安装后验证"
# TODO(SDD): 重启/重载目标实例后，验证插件注册成功（日志/健康端点/UI 入口可见）。
echo "完成。若目标是生产实例，重启前必须获得用户确认。"