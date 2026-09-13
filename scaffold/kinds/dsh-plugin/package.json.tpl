{
  "name": "{{PROJECT_NAME}}",
  "version": "0.1.0",
  "description": "{{PROJECT_DESC}}",
  "keywords": [
    "dsh",
    "dsh-plugin",
    "deepseek-harness"
  ],
  "license": "MIT",
  "type": "module",
  "main": "./lib/index.js",
  "exports": {
    ".": "./lib/index.js",
    "./client": "./lib/client.js",
    "./package.json": "./package.json"
  },
  "files": [
    "lib/",
    "src/",
    "scripts/",
    "test/",
    "tsconfig.json",
    "tsconfig.client.json",
    "cordis.patch.yml",
    "README.md",
    "LICENSE",
    "docs/"
  ],
  "peerDependencies": {
    "@deepseek-ai/cordis": ">=4.0.0"
  },
  "dependencies": {
    "@deepseek-ai/schemastery": ">=3.18.0 <4.0.0-0"
  },
  "devDependencies": {
    "@types/node": "^22",
    "esbuild": ">=0.20.0",
    "typescript": ">=5.0.0"
  },
  "dsh": {
    "bundle": {
      "patch": "./cordis.patch.yml"
    },
    "client": {
      "inject": [],
      "platform": "web"
    }
  },
  "scripts": {
    "build": "node scripts/build.mjs --no-typecheck",
    "build:full": "node scripts/build.mjs",
    "typecheck": "node scripts/typecheck.mjs",
    "test": "node test/smoke-test.mjs",
    "check": "node scripts/build.mjs && node test/smoke-test.mjs",
    "pack": "npm pack"
  }
}
