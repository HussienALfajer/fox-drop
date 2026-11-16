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
    // One PostGIS for the run; each database test file copies its migrated
    // template (src/database/test-database.ts).
    globalSetup: ['src/database/test-postgres.global-setup.ts'],
    // A database test file starts its own Valkey and takes a database of the
    // run's PostGIS. On a 32-thread machine 12 workers ran the suite as fast
    // as 16 or 31 (223 s, 224 s, 238 s, each file then with its own PostGIS);
    // more only load Docker. CI's 4 vCPUs stay at 3.
    maxWorkers: Math.max(1, Math.min(availableParallelism() - 1, 12)),
  },
});
