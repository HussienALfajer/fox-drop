import { describe, expect, it, vi } from 'vitest';
import { balanceSide, type MerchantStatement, statementParts } from './restaurant-settlement.js';

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
