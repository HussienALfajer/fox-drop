import { describe, expect, it, vi } from 'vitest';
import { browserOf, teamRefusalOf } from './team.js';

vi.mock('./api.js', () => ({ api: {} }));

describe('the portal sessions (owner decision 2026-11-20)', () => {
  it('names a browser and its system from the user agent', () => {
    expect(
      browserOf(
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36 Edg/130.0',
      ),
    ).toEqual({ browser: 'Edge', system: 'Windows' });
    expect(
      browserOf(
        'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Mobile Safari/537.36',
      ),
    ).toEqual({ browser: 'Chrome', system: 'Android' });
    expect(browserOf('curl/8.0')).toBeNull();
    expect(browserOf(null)).toBeNull();
  });
});

describe('the staff and devices refusals (RA §14)', () => {
  it('says each in the owner’s words', () => {
    expect(teamRefusalOf({ error: 'phone_taken' })).toBe('phoneTaken');
    expect(teamRefusalOf({ error: 'unknown_session' })).toBe('gone');
    expect(teamRefusalOf({ error: 'no_device' })).toBe('gone');
    expect(teamRefusalOf({ error: 'too_many' })).toBe('tooMany');
    expect(teamRefusalOf(undefined)).toBe('other');
  });
});
