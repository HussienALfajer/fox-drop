import { availableParallelism } from 'node:os';
import swc from 'unplugin-swc';
import { defineConfig } from 'vitest/config';

// NestJS dependency injection reads decorator metadata, which esbuild does not
// emit, so tests compile through SWC.
export default defineConfig({
  plugins: [swc.vite({ module: { type: 'es6' } })],
  test: {
    include: ['src/**/*.test.ts', 'test/**/*.test.ts'],
    env: { LOG_LEVEL: 'silent' },
    // A database test file starts its own PostGIS and Valkey, so each worker
    // is two containers. On a 32-thread machine 12 workers ran the suite as
    // fast as 16 or 31 (223 s, 224 s, 238 s) with a third of the containers;
    // more only load Docker. CI's 4 vCPUs stay at 3.
    maxWorkers: Math.max(1, Math.min(availableParallelism() - 1, 12)),
  },
});
