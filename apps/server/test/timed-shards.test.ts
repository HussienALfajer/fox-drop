import { existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import seconds from './test-seconds.json' with { type: 'json' };
import { timedShard } from './timed-shards.js';

const root = fileURLToPath(new URL('..', import.meta.url));

describe('the server test shards', () => {
  it('lists only test files that exist', () => {
    const missing = Object.keys(seconds).filter((file) => !existsSync(`${root}${file}`));
    expect(missing).toEqual([]);
  });

  it('puts every file in exactly one shard, the slow ones apart', () => {
    const files = [...Object.keys(seconds), 'src/new-a.test.ts', 'src/new-b.test.ts'];
    const shards = [1, 2, 3, 4].map((index) => timedShard(files, index, 4));
    expect(shards.flat().sort()).toEqual([...files].sort());
    const total = (shard: string[]) =>
      shard.reduce((sum, file) => sum + ((seconds as Record<string, number>)[file] ?? 2), 0);
    const totals = shards.map(total);
    // Balanced within the slowest file.
    expect(Math.max(...totals) - Math.min(...totals)).toBeLessThanOrEqual(
      Math.max(...Object.values(seconds)),
    );
  });
});
