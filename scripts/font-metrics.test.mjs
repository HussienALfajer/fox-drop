import assert from 'node:assert/strict';
import { existsSync } from 'node:fs';
import { describe, it } from 'node:test';
import { FONTS_DIR, measureAll, readMetrics, WEIGHTS } from './font-metrics.mjs';
import { readManifest } from './fonts.mjs';

// Brand expression §7: money, timers and tables use CoFo's tabular digits.
describe('the tabular digits of CoFo (packages/design-tokens/font-metrics.json)', () => {
  const metrics = readMetrics();
  const manifest = readManifest();

  it('has every UI weight, at the SHA-256 the fonts manifest pins', () => {
    assert.deepEqual(Object.keys(metrics).sort(), Object.keys(WEIGHTS).sort());
    for (const [weight, each] of Object.entries(metrics)) {
      const entry = manifest.files.find((file) => file.path === each.path);
      assert.equal(each.path, WEIGHTS[weight]);
      assert.equal(each.sha256, entry?.sha256, `${each.path} was measured from other bytes`);
    }
  });

  it('gives the ten tabular digits one width in every weight', () => {
    for (const [weight, each] of Object.entries(metrics)) {
      assert.equal(each.tabular.length, 10);
      assert.equal(new Set(each.tabular).size, 1, `weight ${weight}: ${each.tabular}`);
    }
  });

  // Without the fonts (CI until the deploy key is set) the committed metrics stand.
  const fetched = Object.values(WEIGHTS).every((file) => existsSync(new URL(file, FONTS_DIR)));
  it('matches the fetched fonts', { skip: !fetched && 'no .fonts/: run pnpm fonts:fetch' }, () => {
    assert.deepEqual(measureAll(), metrics);
  });
});
