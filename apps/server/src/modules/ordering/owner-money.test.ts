import { describe, expect, it } from 'vitest';
import { ownerMoney } from './owner-money.js';

// RA §8.4, §12.1, R10 (slice 2.19d): the owners' money lines of an order.
describe('ownerMoney', () => {
  const order = { itemsValue: 40_000n, commissionBp: 1500, testOrder: false };

  it('takes the commission on the items value and leaves the restaurant the rest', () => {
    // RA §12.1: 400 at 15% is 60 of commission; the restaurant keeps 340.
    expect(ownerMoney(order, null)).toEqual({
      commissionBp: 1500,
      commission: 6_000n,
      merchantNet: 34_000n,
    });
  });

  it('rounds the commission half up to the minor unit', () => {
    expect(ownerMoney({ ...order, itemsValue: 10_001n }, null)?.commission).toBe(1_500n);
    expect(ownerMoney({ ...order, itemsValue: 10_003n }, null)?.commission).toBe(1_500n);
    expect(ownerMoney({ ...order, itemsValue: 10_004n }, null)?.commission).toBe(1_501n);
  });

  it('shows no commission on a test order', () => {
    expect(ownerMoney({ ...order, testOrder: true }, null)).toBeNull();
  });

  it('keeps the pickup values after the pickup, less the restaurant’s own edits', () => {
    // AP §9.3.3: 80 of items removed after the pickup with the restaurant
    // responsible: the commission on them is reversed and their value owed.
    expect(
      ownerMoney(
        { ...order, itemsValue: 32_000n },
        { itemsValue: 40_000n, restaurantCommissionCut: 1_200n, restaurantCharge: 8_000n },
      ),
    ).toEqual({ commissionBp: 1500, commission: 4_800n, merchantNet: 27_200n });
  });

  it('leaves the restaurant its pickup net when another party bore the edit', () => {
    expect(
      ownerMoney(
        { ...order, itemsValue: 32_000n },
        { itemsValue: 40_000n, restaurantCommissionCut: 0n, restaurantCharge: 0n },
      ),
    ).toEqual({ commissionBp: 1500, commission: 6_000n, merchantNet: 34_000n });
  });
});
