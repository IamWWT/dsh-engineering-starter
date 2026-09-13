#!/usr/bin/env bash
# ============================================================================
# install-dsh.sh — 把 dsh-engineering-starter 装入 DSH（DeepSeek Harness）
#
# 装入内容：
#   1. agent preset：presets/engineering/ → $DSH_HOME/.agent-presets/engineering/
#      （agent.cordis.yml + preset.yml；DSH 每次读 roster 时重新发现，无需重启）
#   2. skills：skills/{grill-me,grilling,project-disceline...} → $SKILLS_DIR
#      （默认 $HOME/.agents/skills，即用户实际生效的 skill 根目录）
#
# 用法:
#   scripts/install-dsh.sh                     # 安装（幂等；覆盖前自动备份）
#   scripts/install-dsh.sh --skills-dir DIR    # 指定 skill 安装目录
#   scripts/install-dsh.sh --dsh-home DIR      # 指定 DSH home（默认 $DSH_HOME 或 ~/.dsh-dev）
#   scripts/install-dsh.sh --uninstall         # 移除 preset 与已装 skills（不碰其他内容）
#
# 说明:
#   - 已有同名 preset/skill 会先备份为 <name>.bak-<时间戳>，可手动比对/回滚。
#   - 安装后新开一个 DSH 会话（选择"工程模式"preset）即可生效；
#     正在运行的会话保持旧 persona，不需要也不应该重启 3082。
# ============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRESET_SRC="$ROOT/presets/engineering"
SKILLS_SRC="$ROOT/skills"

DSH_HOME="${DSH_HOME:-$HOME/.dsh-dev}"
SKILLS_DIR="${DSH_SKILLS_DIR:-$HOME/.agents/skills}"
MODE="install"

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dsh-home)   [ "$#" -ge 2 ] || { echo "错误: --dsh-home 需要值" >&2; exit 1; }; DSH_HOME="$2"; shift 2 ;;
        --skills-dir) [ "$#" -ge 2 ] || { echo "错误: --skills-dir 需要值" >&2; exit 1; }; SKILLS_DIR="$2"; shift 2 ;;
        --uninstall)  MODE="uninstall"; shift ;;
        -h|--help)    grep '^#' "$0" | sed 's/^# \{0,1\}//' ; exit 0 ;;
        *) echo "错误: 未知参数 $1（见 --help）" >&2; exit 1 ;;
    esac
done

TS="$(date +%Y%m%d-%H%M%S)"

backup_then_cp() {  # $1=源  $2=目标目录
    local src="$1" dst_dir="$2" name
    name="$(basename "$src")"
    mkdir -p "$dst_dir"
    if [ -e "$dst_dir/$name" ]; then
        mv "$dst_dir/$name" "$dst_dir/$name.bak-$TS"
        echo "  备份: $name → $name.bak-$TS"
    fi
    cp -r "$src" "$dst_dir/$name"
    echo "  安装: $dst_dir/$name"
}

echo "== dsh-engineering-starter 安装 (mode=$MODE) =="
echo "  DSH_HOME  = $DSH_HOME"
echo "  SKILLS_DIR= $SKILLS_DIR"

if [ "$MODE" = "uninstall" ]; then
    PRESET_DST="$DSH_HOME/.agent-presets/engineering"
    [ -e "$PRESET_DST" ] && { mv "$PRESET_DST" "${PRESET_DST}.bak-$TS"; echo "  移除 preset: engineering → .bak-$TS"; } \
        || echo "  preset 不存在，跳过"
    for s in grill-me grilling project-discipline; do
        if [ -d "$SKILLS_DIR/$s" ]; then
            mv "$SKILLS_DIR/$s" "$SKILLS_DIR/$s.bak-$TS"
            echo "  移除 skill: $s → .bak-$TS"
        else
            echo "  skill 不存在，跳过: $s"
        fi
    done
    echo "✅ 卸载完成（被移除项均已保留为 .bak-$TS，确认无用后可删除）"
    exit 0
fi

# ---- 1. preset ----
[ -d "$PRESET_SRC" ] || { echo "错误: 缺少 $PRESET_SRC" >&2; exit 1; }
[ -f "$PRESET_SRC/agent.cordis.yml" ] || { echo "错误: preset 缺少 agent.cordis.yml" >&2; exit 1; }
echo "== 1/2 agent preset → $DSH_HOME/.agent-presets/engineering =="
PRESET_DST="$DSH_HOME/.agent-presets/engineering"
if [ -e "$PRESET_DST" ]; then
    mv "$PRESET_DST" "$PRESET_DST.bak-$TS"
    echo "  备份: engineering → engineering.bak-$TS"
fi
mkdir -p "$PRESET_DST"
cp -r "$PRESET_SRC/." "$PRESET_DST/"
echo "  安装: $PRESET_DST（agent.cordis.yml + preset.yml）"

# ---- 2. skills ----
[ -d "$SKILLS_SRC" ] || { echo "错误: 缺少 $SKILLS_SRC" >&2; exit 1; }
echo "== 2/2 skills → $SKILLS_DIR =="
for s in grill-me grilling project-discipline; do
    if [ -d "$SKILLS_SRC/$s" ]; then
        backup_then_cp "$SKILLS_SRC/$s" "$SKILLS_DIR"
    else
        echo "  跳过: skills/$s（源不存在）"
    fi
done

echo ""
echo "✅ 安装完成。"
echo "  - 新会话选择『工程模式』preset 即生效（DSH 每次读 roster 重新发现，无需重启）。"
echo "  - 已运行的会话不受影响。"
echo "  - 回滚: 删除新目录并把 .bak-$TS 改回原名即可。"