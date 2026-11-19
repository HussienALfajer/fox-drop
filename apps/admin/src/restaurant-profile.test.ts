import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const {
  canOpenStatement,
  canSignOutDevices,
  changeActionOf,
  changeFieldOf,
  isProfileTab,
  noteOf,
  valueText,
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

  it('shows a text, a number or a flag, never a list or an object', () => {
    expect(valueText('"الساحة"')).toBe('الساحة');
    expect(valueText('25')).toBe('25');
    expect(valueText('false')).toBe('false');
    expect(valueText('[1,2]')).toBeNull();
    expect(valueText('{"amount":"1"}')).toBeNull();
    expect(valueText(null)).toBeNull();
  });
});
