import { relative } from 'node:path';
import { BaseSequencer, type TestSpecification } from 'vitest/node';
import seconds from './test-seconds.json' with { type: 'json' };

// The seconds a test file took on CI (median of four runs, 2026-11-23),
// for the files of 4 s or more. Only the balance depends on it: a file not
// listed counts as UNLISTED_SECONDS and runs all the same.
const SECONDS: Record<string, number> = seconds;
const UNLISTED_SECONDS = 2;

// The files of shard `index` of `count` (1-based): the slowest first, each to
// the shard with the least so far. Vitest's own split hashes the paths, which
// gave one shard 309 to 404 s of files and the others 176 to 265.
export function timedShard(files: readonly string[], index: number, count: number): string[] {
  const shards = Array.from({ length: count }, () => ({ seconds: 0, files: [] as string[] }));
  const time = (file: string) => SECONDS[file] ?? UNLISTED_SECONDS;
  for (const file of [...files].sort((a, b) => time(b) - time(a) || a.localeCompare(b))) {
    const lightest = shards.reduce((least, each) => (each.seconds < least.seconds ? each : least));
    lightest.files.push(file);
    lightest.seconds += time(file);
  }
  return shards[index - 1]?.files ?? [];
}

// The server's `--shard=<i>/<n>` (scripts/verify.mjs, CI's server jobs).
export class TimedShards extends BaseSequencer {
  override shard(specs: TestSpecification[]): Promise<TestSpecification[]> {
    const { root, shard } = this.ctx.config;
    if (!shard) return Promise.resolve(specs);
    const path = (spec: TestSpecification) => relative(root, spec.moduleId).split('\\').join('/');
    const chosen = new Set(timedShard(specs.map(path), shard.index, shard.count));
    return Promise.resolve(specs.filter((spec) => chosen.has(path(spec))));
  }
}
