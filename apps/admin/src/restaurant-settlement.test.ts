import { describe, expect, it, vi } from 'vitest';
import {
  aboveDue,
  balanceSide,
  type MerchantStatement,
  type RestaurantSettlementPreview,
  defaultSession,
  restaurantSettleBodyOf,
  settlementLinesOf,
  statementParts,
} from './restaurant-settlement.js';

vi.mock('./api.js', () => ({ api: {} }));

const line = (kind: 'order' | 'exception' | 'payment', position: number) => ({
  position,
  kind,
  at: '2026-11-12T10:00:00.000Z',
  orderId: null,
  orderNumber: null,
  itemsValue: null,
  pickupLines: null,
  commission: null,
  discountShare: null,
  cause: null,
  amount: null,
  reason: null,
});

// AP §8.7, RA §12.3 (slice 2.19a): which side owes, and the statement's
// three parts.
describe('the restaurant settlement', () => {
  it('reads the balance from the restaurant side', () => {
    expect(balanceSide('46000')).toBe('owes');
    expect(balanceSide('-3400')).toBe('owed');
    expect(balanceSide('0')).toBe('settled');
  });

  it('splits the statement into orders, exceptions and payments', () => {
    const statement = {
      lines: [line('payment', 0), line('order', 1), line('exception', 2), line('order', 3)],
    } as MerchantStatement;
    const parts = statementParts(statement);
    expect(parts.orders.map((each) => each.position)).toEqual([1, 3]);
    expect(parts.exceptions.map((each) => each.position)).toEqual([2]);
    expect(parts.payments.map((each) => each.position)).toEqual([0]);
  });
});

// AP §9.10.3 tab 3, RA §12.4 (slice 2.19b): the cash typed per currency and
// the confirmation's body.
describe('the restaurant settlement form', () => {
  const currencies = ['TRY', 'USD'];

  it('takes the amounts typed in major units, leaving empty fields and zeros out', () => {
    expect(settlementLinesOf({ TRY: '200', USD: '20.50' }, currencies)).toEqual({
      status: 'lines',
      lines: [
        { currency: 'TRY', amount: '20000' },
        { currency: 'USD', amount: '2050' },
      ],
    });
    expect(settlementLinesOf({ TRY: ' ', USD: '0' }, currencies)).toEqual({ status: 'empty' });
    expect(settlementLinesOf({ TRY: '12.345' }, currencies)).toEqual({
      status: 'invalid',
      currency: 'TRY',
    });
  });

  const preview: RestaurantSettlementPreview = {
    restaurantId: 'r1',
    restaurantName: 'مطعم',
    cityId: 'c1',
    currency: 'TRY',
    due: '-3400',
    lines: [
      {
        currency: 'USD',
        amount: '100',
        base: '4000',
        rates: [{ currency: 'USD', rateVersionId: 'v1' }],
        unit: { from: 'USD', to: 'TRY', value: '40' },
      },
    ],
    total: '4000',
    remaining: '600',
  };

  it('finds an amount above what is owed, either way', () => {
    expect(aboveDue(preview)).toBe(true);
    expect(aboveDue({ ...preview, due: '4000' })).toBe(false);
  });

  it('confirms exactly what the review showed', () => {
    expect(restaurantSettleBodyOf(preview, { session: 'office', visitorId: 'a1' })).toEqual({
      session: 'office',
      visitorId: 'a1',
      restaurantId: 'r1',
      due: '-3400',
      lines: [
        {
          currency: 'USD',
          amount: '100',
          base: '4000',
          rates: [{ currency: 'USD', rateVersionId: 'v1' }],
        },
      ],
    });
  });
});

// AP §9.10.3 tab 3 (slice 2.19c): the office session by default, the field
// one when only it is open.
describe('the session a settlement goes to', () => {
  it('takes the office session first, then the field one, else none', () => {
    expect(defaultSession({ office: true, field: true })).toBe('office');
    expect(defaultSession({ office: false, field: true })).toBe('field');
    expect(defaultSession({ office: false, field: false })).toBeNull();
  });
});
