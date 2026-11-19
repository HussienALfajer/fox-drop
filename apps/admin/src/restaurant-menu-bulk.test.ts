import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { bulkBody, bulkFormOf, ticked } = await import('./restaurant-menu-bulk.js');

describe('«تعديل جماعي» (slice 2.31)', () => {
  it('sends a percentage in basis points and an amount in minor units', () => {
    expect(bulkBody({ ...bulkFormOf(), value: '10' }, 'TRY')).toEqual({
      categoryId: null,
      kind: 'percent',
      direction: 'up',
      value: '1000',
    });
    expect(bulkBody({ ...bulkFormOf(), value: '7.5', direction: 'down' }, 'TRY')).toMatchObject({
      direction: 'down',
      value: '750',
    });
    expect(
      bulkBody({ categoryId: 'c', kind: 'amount', direction: 'up', value: '2.5' }, 'TRY'),
    ).toEqual({ categoryId: 'c', kind: 'amount', direction: 'up', value: '250' });
  });

  it('refuses a value of nothing, a negative one or too many decimals', () => {
    for (const value of ['', '0', '-5', '1.234', 'abc']) {
      expect(bulkBody({ ...bulkFormOf(), value }, 'TRY')).toEqual({ problem: 'value' });
    }
  });

  it('keeps the ticked items in menu order', () => {
    expect(ticked(['a', 'b', 'c'], new Set(['c', 'a']))).toEqual(['a', 'c']);
  });
});
