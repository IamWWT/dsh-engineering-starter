# scaffold — 新项目脚手架

## 用法

```bash
# 普通项目
scripts/init-project.sh ../my-service --lang go --name "短链接服务" --git

# DSH 插件项目（生成 dsh.json 声明/双 tsconfig/构建门禁/SDD 骨架）
scripts/init-project.sh ../dsh-my-plugin --kind dsh-plugin --name dsh-my-plugin --git
```

脚本会把 `templates/` 实例化到目标目录，并复制：

- 文档骨架：`docs/00-request` ~ `docs/07-ops`（含 PRD/ADR/任务/报告模板）
- 规范层：`standards/`（含语言适配）
- 工具层：`scripts/`（doc-check / quality-gate / journal / experience）

`--kind dsh-plugin` 额外合并 `kinds/dsh-plugin/`：

| 文件 | 说明 |
|------|------|
| `package.json` | dsh 声明（`dsh.bundle.patch` / `dsh.client`）、双端 exports、构建脚本 |
| `tsconfig.json` / `tsconfig.client.json` | Host（Node，strict）/ Client（浏览器，strict）双配置 |
| `cordis.patch.yml` | DSH bundle 补丁（config 层注入，骨架为空） |
| `scripts/build.mjs` | 双端 esbuild + **产物门禁**（三职责，见 PLUGIN-DEV-STANDARD §2.3） |
| `scripts/typecheck.mjs` | 双 tsconfig `--noEmit` |
| `scripts/install-to-dsh.sh` | 一键安装（构建→冒烟→安装→验证，幂等；骨架留 TODO） |
| `test/smoke-test.mjs` | 冒烟测试（版本四处同步 + 导出完整性 + 产物断言） |
| `src/index.ts` | Host 入口（`name`/`inject`/`VERSION`/`apply` 具名导出，禁 default export） |
| `src/client/entry.ts` | Client 入口（`window.__ModuleLoader__` 注册） |
| `src/shared/contracts.ts` | Host/Client 共享契约（单一真源） |
| `docs/specs/` | SDD 规格目录 + 三件套模板（spec→plan→tasks，用户确认前禁实现） |

## 占位符

`{{PROJECT_NAME}}` / `{{LANG}}` / `{{DATE}}` / `{{PROJECT_DESC}}` / `{{KIND_NOTES}}`
由 `init-project.sh` 自动替换（`KIND_NOTES` 在 generic kind 下为空）。

## 工具链（dsh-plugin）

构建工具解析顺序：本项目 `node_modules` → `$DSH_PLUGIN_TOOLS_DIR`（可指向
deepseek-harness 的 node_modules，含 esbuild/typescript）。首次使用：

```bash
npm install          # 或 export DSH_PLUGIN_TOOLS_DIR=~/.../deepseek-harness/node_modules
npm run check        # 双端构建 + 产物门禁 + typecheck + 冒烟
```