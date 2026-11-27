import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { describe, it } from 'node:test';

import { countries } from './countries.mjs';

describe('the country list', () => {
  it('knows Syria and Turkey with their calling codes', () => {
    const list = countries();
    assert.ok(list.length > 200, String(list.length));
    assert.equal(list.find((each) => each.iso === 'SY')?.code, '963');
    assert.equal(list.find((each) => each.iso === 'TR')?.code, '90');
  });

  it('is committed as a fresh run writes it', () => {
    const run = spawnSync(process.execPath, ['scripts/countries.mjs', '--check'], {
      encoding: 'utf8',
    });
    assert.equal(run.status, 0, run.stderr);
  });
});
