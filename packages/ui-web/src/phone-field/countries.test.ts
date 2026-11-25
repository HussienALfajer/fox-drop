import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { describe, expect, it } from 'vitest';
import { COUNTRY_NAMES } from './countries.generated';
import { callingCode } from './phone';

const root = path.resolve(import.meta.dirname, '../../../..');

describe('the country list (owner, 2026-11-25: every region the metadata knows)', () => {
  it('matches a fresh run of scripts/countries.mjs, in both its outputs', () => {
    const run = spawnSync(process.execPath, ['scripts/countries.mjs', '--check'], {
      cwd: root,
      encoding: 'utf8',
    });
    expect(run.stderr).toBe('');
    expect(run.status).toBe(0);
  });

  it('names every region in Arabic and English, with the parser’s calling code', () => {
    expect(COUNTRY_NAMES.length).toBeGreaterThan(240);
    for (const country of COUNTRY_NAMES) {
      expect(country.ar).not.toBe(country.iso);
      expect(country.en).not.toBe(country.iso);
      expect(callingCode(country.iso)).toBe(country.code);
    }
    expect(COUNTRY_NAMES.find((c) => c.iso === 'SY')).toEqual({
      iso: 'SY',
      code: '963',
      ar: 'سوريا',
      en: 'Syria',
    });
  });
});
