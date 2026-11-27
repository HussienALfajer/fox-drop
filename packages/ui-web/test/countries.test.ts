import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { describe, expect, it } from 'vitest';

const root = path.resolve(import.meta.dirname, '../../..');

// The country list of the sign-in (owner, 2026-11-25: every region the phone
// metadata knows) is generated into core_l10n by scripts/countries.mjs from
// this package's libphonenumber-js. It stays checked here while the phone
// field is rebuilt (D.R1, 2026-11-27).
describe('the country list', () => {
  it('matches a fresh run of scripts/countries.mjs', () => {
    const run = spawnSync(process.execPath, ['scripts/countries.mjs', '--check'], {
      cwd: root,
      encoding: 'utf8',
    });
    expect(run.stderr).toBe('');
    expect(run.status).toBe(0);
  });
});
