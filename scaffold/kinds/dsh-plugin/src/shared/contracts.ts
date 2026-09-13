/**
 * Host/Client 共享契约（骨架）。
 *
 * 铁律 #3 契约先行：跨端数据/事件契约只定义在这里，
 * 双端都 import 本目录，禁止各自私抄字段定义（铁律 #4 单一真源）。
 *
 * TODO(SDD): 按 spec.md 的数据契约定义 interface/type。
 */

export interface PluginEvent {
  /** 事件域（PLUGIN-DEV-STANDARD §4.3：按域路由，勿混用） */
  domain: string;
  /** 事件名 */
  type: string;
  /** 事件负载 */
  payload: unknown;
}