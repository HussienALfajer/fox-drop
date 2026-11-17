import { describe, expect, it, vi } from 'vitest';

import { aboveDues, blockBodyOf, duesLinesOf, duesPayBodyOf } from './customers.js';

vi.mock('./api.js', () => ({ api: {} }));

const city = { timeZone: 'Asia/Damascus', currency: 'TRY' };
const now = new Date('2026-11-17T09:00:00.000Z');
const form = {
  kind: 'indefinite' as const,
  until: '',
  amount: '',
  reason: 'abuse',
  note: ' أساء ',
};

// AP §9.8 «حظر» (slice 2.25a).
describe('blockBodyOf', () => {
  it('sends until further notice with the trimmed note', () => {
    expect(blockBodyOf('c', form, city, now)).toEqual({
      status: 'ready',
      body: {
        cityId: 'c',
        kind: 'indefinite',
        until: null,
        amount: null,
        reason: 'abuse',
        note: 'أساء',
      },
    });
  });

  it('reads a duration on the city clock and refuses one already past', () => {
    expect(
      blockBodyOf('c', { ...form, kind: 'until', until: '2026-11-20T18:30' }, city, now),
    ).toMatchObject({
      status: 'ready',
      body: { kind: 'until', until: '2026-11-20T15:30:00.000Z', amount: null },
    });
    expect(
      blockBodyOf('c', { ...form, kind: 'until', until: '2026-11-17T11:00' }, city, now),
    ).toEqual({
      status: 'problem',
      problem: 'until',
    });
    expect(blockBodyOf('c', { ...form, kind: 'until' }, city, now)).toMatchObject({
      problem: 'until',
    });
  });

  it('takes the dues in the base currency’s major units, above zero', () => {
    expect(blockBodyOf('c', { ...form, kind: 'dues', amount: '50' }, city, now)).toMatchObject({
      status: 'ready',
      body: { kind: 'dues', amount: '5000', until: null },
    });
    for (const amount of ['0', '', 'x']) {
      expect(blockBodyOf('c', { ...form, kind: 'dues', amount }, city, now)).toMatchObject({
        problem: 'amount',
      });
    }
    expect(
      blockBodyOf('c', { ...form, kind: 'dues', amount: '50' }, { ...city, currency: null }, now),
    ).toMatchObject({ problem: 'amount' });
  });

  it('needs a reason and an internal note', () => {
    expect(blockBodyOf('c', { ...form, reason: '' }, city, now)).toMatchObject({
      problem: 'reason',
    });
    expect(blockBodyOf('c', { ...form, note: '  ' }, city, now)).toMatchObject({ problem: 'note' });
  });
});

// AP §8.8 «تسجيل دفع المستحق».
describe('the dues payment', () => {
  it('reads the cash per currency, leaving out empty fields and zeros', () => {
    expect(duesLinesOf({ TRY: '40', USD: '0', SYP: '' }, ['TRY', 'USD', 'SYP'])).toEqual({
      status: 'lines',
      lines: [{ currency: 'TRY', amount: '4000' }],
    });
    expect(duesLinesOf({ TRY: '' }, ['TRY'])).toEqual({ status: 'empty' });
    expect(duesLinesOf({ USD: 'abc' }, ['USD'])).toEqual({ status: 'invalid', currency: 'USD' });
  });

  it('sends exactly what the review showed and refuses more than is owed', () => {
    const preview = {
      customerId: 'u',
      customerName: 'رامي',
      cityId: 'c',
      currency: 'TRY',
      due: '4000',
      lines: [
        {
          currency: 'USD',
          amount: '100',
          base: '4000',
          rates: [{ currency: 'USD', rateVersionId: 'r' }],
          unit: null,
        },
      ],
      total: '4000',
      remaining: '0',
    };
    expect(aboveDues(preview)).toBe(false);
    expect(aboveDues({ ...preview, total: '4100' })).toBe(true);
    expect(duesPayBodyOf(preview)).toEqual({
      cityId: 'c',
      customerId: 'u',
      due: '4000',
      lines: [
        {
          currency: 'USD',
          amount: '100',
          base: '4000',
          rates: [{ currency: 'USD', rateVersionId: 'r' }],
        },
      ],
    });
  });
});
