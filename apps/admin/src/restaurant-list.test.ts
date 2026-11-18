import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));
vi.mock('./session.js', () => ({ can: () => false }));

const { listFilterOf, looksLikePhone, percentText } = await import('./restaurant-list.js');

// AP §9.6.2 «المطاعم» (slice 2.30c): the list's search and its numbers.
describe('listFilterOf', () => {
  it('keeps the known filters and drops the rest', () => {
    expect(
      listFilterOf({ status: 'suspended', category: 'c1', zone: '', q: 'شام', stars: 2 }),
    ).toEqual({ status: 'suspended', category: 'c1', q: 'شام' });
    expect(listFilterOf({ status: 'closed' })).toEqual({});
  });
});

describe('looksLikePhone', () => {
  it('keeps a number out of the URL, not a name', () => {
    expect(looksLikePhone('0944 000 111')).toBe(true);
    expect(looksLikePhone('+963944000111')).toBe(true);
    expect(looksLikePhone('مطعم 7')).toBe(false);
  });
});

describe('percentText', () => {
  it('writes basis points as a percentage', () => {
    expect(percentText(1500)).toBe('15%');
    expect(percentText(1250)).toBe('12.5%');
    expect(percentText(0)).toBe('0%');
  });
});
