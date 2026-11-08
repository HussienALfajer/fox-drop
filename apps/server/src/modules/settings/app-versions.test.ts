import { describe, expect, it } from 'vitest';
import { updateNeed, versionBelow } from './app-versions.js';

describe('versionBelow (AP §9.14)', () => {
  it('compares part by part, past single digits', () => {
    expect(versionBelow('1.9.0', '1.10.0')).toBe(true);
    expect(versionBelow('1.10.0', '1.9.0')).toBe(false);
    expect(versionBelow('2.0.0', '2.0.0')).toBe(false);
    expect(versionBelow('1.4.2', '1.5.0')).toBe(true);
  });

  it('puts a version not in the form 1.4.0 below any minimum', () => {
    expect(versionBelow('1.4', '0.0.1')).toBe(true);
    expect(versionBelow('dev', '0.0.1')).toBe(true);
  });
});

describe('updateNeed (CU §4.2, RA §4.2, CA §4.2)', () => {
  const versions = { minVersion: '1.4.0', latestVersion: '1.6.0' };

  it('requires the update below the minimum and suggests it below the latest', () => {
    expect(updateNeed('1.3.9', versions)).toBe('required');
    expect(updateNeed('1.4.0', versions)).toBe('suggested');
    expect(updateNeed('1.6.0', versions)).toBe('none');
  });

  it('needs nothing while the versions are unset', () => {
    expect(updateNeed('0.0.1', { minVersion: null, latestVersion: null })).toBe('none');
  });
});
