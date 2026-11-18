import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));
vi.mock('./session.js', () => ({ can: () => false }));

const { commissionBody, sortWeightOf } = await import('./restaurant-account.js');

// AP §9.6.5, D16 (slice 2.30c): the commission change and the sort weight.
describe('commissionBody', () => {
  const form = { percent: '12.5', when: 'now', at: '', reason: ' اتفاق ' } as const;

  it('sends the rate for new orders from now or from a time on the city’s clock', () => {
    expect(commissionBody(form, 'Asia/Damascus')).toEqual({
      rateBp: 1250,
      effectiveFrom: null,
      reason: 'اتفاق',
    });
    expect(
      commissionBody({ ...form, when: 'at', at: '2026-11-20T00:00' }, 'Asia/Damascus'),
    ).toEqual({ rateBp: 1250, effectiveFrom: '2026-11-19T21:00:00.000Z', reason: 'اتفاق' });
  });

  it('refuses a rate it cannot read, a missing time or reason', () => {
    expect(commissionBody({ ...form, percent: '101' }, 'UTC')).toBeNull();
    expect(commissionBody({ ...form, percent: 'abc' }, 'UTC')).toBeNull();
    expect(commissionBody({ ...form, when: 'at', at: '' }, 'UTC')).toBeNull();
    expect(commissionBody({ ...form, reason: ' ' }, 'UTC')).toBeNull();
  });
});

describe('sortWeightOf', () => {
  it('takes a whole number up to the maximum', () => {
    expect(sortWeightOf(' 50 ', 1000)).toBe(50);
    expect(sortWeightOf('1001', 1000)).toBeNull();
    expect(sortWeightOf('2.5', 1000)).toBeNull();
    expect(sortWeightOf('', 1000)).toBeNull();
  });
});
