import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { canExport, historyBodyOf, historySearchOf } = await import('./order-history.js');
const { correctionBody } = await import('./order-corrections.js');

const CITY = '0190f0a0-0000-7000-8000-000000000001';
const RESTAURANT = '0190f0a0-0000-7000-8000-000000000002';

// AP §9.5 «سجل الطلبات» (slice 2.40).
describe('the history filters', () => {
  it('keeps only the values each filter takes', () => {
    expect(
      historySearchOf({
        number: '#10042',
        restaurant: RESTAURANT,
        captain: 'not an id',
        from: '2026-11-01',
        to: 'yesterday',
        status: 'delivered',
        outcome: 'lost',
        kind: 'test',
        code: 'SAVE 10',
        phone: '+963912345678',
      }),
    ).toEqual({
      number: '#10042',
      restaurant: RESTAURANT,
      from: '2026-11-01',
      status: 'delivered',
      kind: 'test',
    });
  });

  it('sends the phone in the body only, and every other filter null when left out', () => {
    expect(historyBodyOf(CITY, { status: 'cancelled' }, ' 0912 345 678 ')).toEqual({
      cityId: CITY,
      number: null,
      customerPhone: '0912 345 678',
      restaurantId: null,
      captainId: null,
      from: null,
      to: null,
      status: 'cancelled',
      outcome: null,
      responsible: null,
      code: null,
      zoneId: null,
      kind: 'all',
    });
    expect(historyBodyOf(CITY, {}, '  ').customerPhone).toBeNull();
  });

  it('exports a period of business days only', () => {
    expect(canExport({})).toBe(false);
    expect(canExport({ from: '2026-11-01' })).toBe(false);
    expect(canExport({ from: '2026-11-02', to: '2026-11-01' })).toBe(false);
    expect(canExport({ from: '2026-11-01', to: '2026-11-30' })).toBe(true);
  });
});

describe('the financial correction', () => {
  const accounts = [
    {
      partyKind: 'restaurant' as const,
      partyId: RESTAURANT,
      partyName: 'مطعم',
      account: 'merchant.account' as const,
      currencies: ['TRY'],
    },
  ];
  const form = {
    choice: 0,
    currency: 'TRY',
    direction: 'down' as const,
    amount: '5',
    reason: 'خطأ',
  };

  it('signs the amount from the party’s view and needs a reason', () => {
    expect(correctionBody(accounts, form)).toEqual({
      party: 'restaurant',
      partyId: RESTAURANT,
      account: 'merchant.account',
      currency: 'TRY',
      amount: '-500',
      reason: 'خطأ',
    });
    expect(correctionBody(accounts, { ...form, reason: ' ' })).toBeNull();
    expect(correctionBody(accounts, { ...form, amount: '0' })).toBeNull();
    expect(correctionBody(accounts, { ...form, currency: 'USD' })).toBeNull();
    expect(correctionBody(accounts, { ...form, choice: 1 })).toBeNull();
  });
});
