import { availableParallelism } from 'node:os';
import swc from 'unplugin-swc';
import { defineConfig } from 'vitest/config';
import { TimedShards } from './test/timed-shards.js';

// NestJS dependency injection reads decorator metadata, which esbuild does not
// emit, so tests compile through SWC.
export default defineConfig({
  plugins: [swc.vite({ module: { type: 'es6' } })],
  test: {
    include: ['src/**/*.test.ts', 'test/**/*.test.ts'],
    env: { LOG_LEVEL: 'silent' },
    // One PostGIS for the run; each database test file copies its migrated
    // template (src/database/test-database.ts). One Valkey per worker slot
    // (src/valkey/test-valkey.ts). Leftovers of a killed run go first.
    globalSetup: ['src/database/test-postgres.global-setup.ts'],
    // On a 32-thread machine 12 workers ran the suite as fast as 16 or 31
    // (223 s, 224 s, 238 s, each file then with its own PostGIS); more only
    // load Docker. CI's 4 vCPUs stay at 3.
    maxWorkers: Math.max(1, Math.min(availableParallelism() - 1, 12)),
    // `--shard` splits the files by their measured time (test/timed-shards.ts).
    sequence: { sequencer: TimedShards },
    // `vitest run --changed` (node scripts/verify.mjs --changed, for a change
    // outside src/modules) runs the tests that import a changed file; a
    // change to one of these runs them all: every database test migrates, the
    // fixtures are read from disk, and so are the files in
    // READ_BY_SERVER_TESTS (scripts/classify-changes.mjs, whose test checks
    // they are here). The first three are Vitest's defaults.
    forceRerunTriggers: [
      '**/package.json/**',
      '**/vitest.config.*/**',
      '**/vite.config.*/**',
      '**/pnpm-lock.yaml',
      '**/tsconfig*.json',
      '**/apps/server/migrations/**',
      '**/apps/server/test/fixtures/**',
      '**/apps/server/src/database/**',
      '**/docs/product/v1/admin-panel/appendix-a-settings-catalogue.md',
      '**/compose.yaml',
      '**/infra/**',
      '**/apps/admin/src/locales/**',
      '**/apps/merchant-portal/src/locales/**',
    ],
  },
});
