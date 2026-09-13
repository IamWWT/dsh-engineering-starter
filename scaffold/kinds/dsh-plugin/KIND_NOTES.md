## 2A. DSH 插件专项纪律（本项目 kind = dsh-plugin）

本项目是 **DSH（DeepSeek Harness）插件**，以下纪律叠加在 §1-§4 之上（完整规范：本机 deepseek-harness 仓库 `dsh-plugins/PLUGIN-DEV-STANDARD.md` + `DEV-WORKFLOW-GUIDE.md`，如存在则先读；不存在时以下列红线为准）：

- **SDD 规格驱动（强制）**：`docs/specs/<id>/` 三件套 `spec.md → plan.md → tasks.md`；**规格未获用户确认前禁止进入实现**。验收以 spec 验收标准逐条对照。
- **双端边界**：Host（Node：路由/状态/外部服务）与 Client（浏览器：插槽/卡片/UI）只在契约处相接；client 侧禁止 value-import 其他插件；`@deepseek-ai/*` 服务包走 peerDependencies。
- **构建产物门禁**：`scripts/build.mjs` 三职责（双端 esbuild 打包 + 产物断言 + 双 tsconfig typecheck）不得删改弱化；检查命令不加管道裸跑（要管道就 `set -o pipefail`）。
- **版本四处同步**：`package.json version` = `src/index.ts VERSION` = tgz 文件名 = README/CHANGELOG；重打包必升版本号（pnpm 按 integrity 判断，同版本重打包导致 loader `ERR_MODULE_NOT_FOUND`）。
- **安装红线**：未验证的改动**禁止**装入生产 DSH 实例；先用临时实例验证（`DSH_HOME=$HOME/.dsh-<name>-test pnpm dsh web --port 3084`），用户验收后再装生产。开发期用 link 安装，tgz 仅用于稳定版。
- **client 主题**：走 DSH 主题 token（`--dsw-*` 等），明暗模式自动跟随，禁止硬编码颜色。