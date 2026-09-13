/**
 * Client 侧入口（浏览器，骨架）。
 *
 * DSH 宿主以 iife 加载本模块（esbuild globalName 见 scripts/build.mjs），
 * 经 window.__ModuleLoader__ 通道注册为 client 模块。
 *
 * 注意：`window.__ModuleLoader__` 的方法名以本机 deepseek-harness 宿主源码为准
 * （apps/web 侧 loader 实现）；接入真实插槽前先核对，本骨架只做「探测 + 占位注册」。
 */

interface DshModuleLoader {
  define?: (id: string, factory: () => unknown) => void;
  [key: string]: unknown;
}

declare global {
  interface Window {
    __ModuleLoader__?: DshModuleLoader;
  }
}

export const CLIENT_ID = "{{PROJECT_NAME}}-client";

/** client 模块工厂：宿主就绪后由 loader 调用。 */
export function factory(): { mount: (host: unknown) => void } {
  return {
    mount(host: unknown): void {
      // TODO(SDD): 注册卡片/插槽/对话框（PLUGIN-DEV-STANDARD §4.5 Client 插槽）。
      // UI 走 DSH 主题 token（--dsw-*），随宿主明暗模式切换。
      void host;
    },
  };
}

/** 自注册：宿主未就绪时静默 no-op（loader 未注入即纯文本页/未启用本插件）。 */
export function bootstrap(): void {
  const loader = typeof window !== "undefined" ? window.__ModuleLoader__ : undefined;
  if (!loader || typeof loader.define !== "function") return;
  loader.define(CLIENT_ID, factory);
}

bootstrap();