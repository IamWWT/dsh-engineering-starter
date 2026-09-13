/**
 * DSH 插件 Host 入口（骨架）。
 *
 * 导出形态红线（PLUGIN-DEV-STANDARD §4.1，postmortem-0001 实证）：
 *   - 一律**具名导出**（export const / export function），**禁止 export default**
 *     ——default export 会丢失 inject 声明，服务加载直接崩溃；
 *   - `name`/`inject`/`VERSION` 均为 `export const`，`apply` 为具名函数。
 *
 * 版本纪律：VERSION 与 package.json version / tgz 文件名 / README 四处同步（§2.4）。
 *
 * 骨架说明：apply 目前为占位实现；进入 SDD Implement 阶段后按 spec 接线
 * （路由走 ctx.webServer 时，必须在 inject 中声明 "webServer"，否则代理抛
 * "cannot get property ... without inject"）。
 */

/** 插件 id（bundle 注册名；短横线小写，如 "scheduled-send"）。 */
export const name = "{{PROJECT_NAME}}";

/** 依赖注入声明：ctx.<服务> 取用前必须在此声明（Cordis Proxy 不做惰性兜底）。 */
export const inject: string[] = [];

/** 与 package.json version 同步（四处同步，改版本必同步本行）。 */
export const VERSION = "0.1.0";

export interface PluginConfig {
  // TODO(SDD): 插件配置项（宿主侧 settings 或默认值）
}

export function apply(ctx: unknown, _config: Partial<PluginConfig> = {}): void {
  // TODO(SDD): 按 docs/specs/<id>/spec.md 接线——注册路由 / client 插槽 / 状态机。
  // 参考：dsh-scheduled-send 的「状态目录 + effect 注册路由 + 重启补投」结构。
  void ctx;
}