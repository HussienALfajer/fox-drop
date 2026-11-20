import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { changeOf, tileLines } = await import('./dashboard.js');

// AP §9.1.2 (slice 2.40): today against the same weekday last week.
describe('changeOf', () => {
  it('subtracts counts, minutes and shares', () => {
    expect(changeOf({ kind: 'count', value: 12 }, { kind: 'count', value: 9 })).toEqual({
      kind: 'count',
      value: 3,
    });
    expect(changeOf({ kind: 'minutes', value: 31.2 }, { kind: 'minutes', value: 35 })).toEqual({
      kind: 'minutes',
      value: -3.8,
    });
    expect(changeOf({ kind: 'percent', bp: 9000 }, { kind: 'percent', bp: 9250 })).toEqual({
      kind: 'percent',
      bp: -250,
    });
  });

  it('subtracts money in minor units, never through a float', () => {
    expect(
      changeOf(
        { kind: 'money', amount: '900000000000000001', currency: 'TRY' },
        { kind: 'money', amount: '1', currency: 'TRY' },
      ),
    ).toEqual({ kind: 'money', amount: '900000000000000000', currency: 'TRY' });
  });

  it('has no change without both sides or across currencies', () => {
    expect(changeOf(null, { kind: 'count', value: 1 })).toBeNull();
    expect(changeOf({ kind: 'percent', bp: 1 }, null)).toBeNull();
    expect(
      changeOf(
        { kind: 'money', amount: '1', currency: 'TRY' },
        { kind: 'money', amount: '1', currency: 'USD' },
      ),
    ).toBeNull();
  });
});

describe('tileLines', () => {
  it('reads null money and rates as nothing to show', () => {
    const period = {
      from: '2026-11-20T01:00:00.000Z',
      until: '2026-11-20T09:00:00.000Z',
      orders: {
        placed: 0,
        delivered: 0,
        inProgress: 0,
        cancelled: 0,
        rejected: 0,
        failed: 0,
        deliveryMinutes: null,
        onTimeBp: null,
        successBp: null,
        firstOrders: 0,
      },
      money: null,
      newCustomers: 0,
    };
    const values = Object.fromEntries(tileLines.map(([key, value]) => [key, value(period)]));
    expect(values.placed).toEqual({ kind: 'count', value: 0 });
    expect(values.gmv).toBeNull();
    expect(values.onTime).toBeNull();
    expect(values.deliveryMinutes).toBeNull();
  });
});
