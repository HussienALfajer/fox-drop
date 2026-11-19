import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const {
  canOpenStatement,
  canSignOutDevices,
  changeActionOf,
  changeFieldOf,
  isProfileTab,
  noteOf,
  changeValue,
} = await import('./restaurant-profile.js');

const session = (permissions: string[]) => ({ permissions }) as never;

// AP §9.6.4 «ملف المطعم» (slice 2.30d).
describe('the profile', () => {
  it('knows its tabs', () => {
    expect(isProfileTab('log')).toBe(true);
    expect(isProfileTab('images')).toBe(false);
  });

  it('opens the statement for OWN and FIN, and signs devices out for OWN and OPS', () => {
    expect(canOpenStatement(session(['restaurants.statements']))).toBe(true);
    expect(canOpenStatement(session(['restaurants.read']))).toBe(false);
    expect(canSignOutDevices(session(['restaurants.owner_accounts']))).toBe(true);
    expect(canSignOutDevices(session(['restaurants.read', 'restaurants.manage']))).toBe(false);
  });

  it('takes a note of 1 to 500 characters, trimmed', () => {
    expect(noteOf('  يتصل صباحاً ')).toBe('يتصل صباحاً');
    expect(noteOf('   ')).toBeNull();
    expect(noteOf('x'.repeat(501))).toBeNull();
  });

  it('names the log’s known actions and fields, and nothing else', () => {
    expect(changeActionOf('restaurant.operations')).toBe('restaurant.operations');
    expect(changeActionOf('restaurant.secret')).toBeNull();
    expect(changeFieldOf('periods')).toBe('periods');
    expect(changeFieldOf('phoneHash')).toBeNull();
  });

  it('reads a commission, a status, a moment, a flag, a text; never a list', () => {
    expect(changeValue('rateBp', '1500')).toEqual({ kind: 'percent', bp: 1500 });
    expect(changeValue('accountStatus', '"suspended"')).toEqual({
      kind: 'status',
      status: 'suspended',
    });
    expect(changeValue('effectiveFrom', '"now"')).toEqual({ kind: 'now' });
    expect(changeValue('effectiveFrom', '"2026-11-19T21:00:00.000Z"')).toEqual({
      kind: 'time',
      at: '2026-11-19T21:00:00.000Z',
    });
    expect(changeValue('visible', 'false')).toEqual({ kind: 'flag', on: false });
    expect(changeValue('address', '"الساحة"')).toEqual({ kind: 'text', text: 'الساحة' });
    expect(changeValue('defaultPrepMin', '25')).toEqual({ kind: 'text', text: '25' });
    expect(changeValue('periods', '[1,2]')).toBeNull();
    expect(changeValue('address', null)).toBeNull();
  });
});
