import { describe, expect, it } from 'vitest';
import { commission } from './door-payment.js';
import {
  afterPickupEntries,
  COMMISSION_REVERSED_REASON,
  FEE_LOWERED_AFTER_PICKUP_REASON,
  REMOVED_AFTER_PICKUP_REASON,
} from './order-edits.js';

// AP §9.3.3, docs/domain/09 (slice 2.10b): the entries an edit after the
// pickup posts, from the platform's side, each journal against the order
// clearing account (the commission's reversal against the revenue).

const facts = {
  restaurantId: 'restaurant-1',
  captainId: 'captain-1',
  currency: 'TRY',
  itemsValueBefore: 24_000n,
  itemsValueAfter: 12_000n,
  deliveryFeeBefore: 4_000n,
  deliveryFeeAfter: 1_000n,
  commissionOf: (value: bigint) => commission(value, 1500),
};

const lines = (booking: ReturnType<typeof afterPickupEntries>) =>
  booking.journals.map((journal) => [
    journal.type,
    journal.reason,
    journal.entries.map((entry) => [entry.account, entry.amount]),
  ]);

describe('afterPickupEntries', () => {
  it('debits the restaurant the removed value and the fee cut, and reverses the commission', () => {
    const booking = afterPickupEntries({ ...facts, responsible: 'restaurant' });
    expect(booking).toMatchObject({ charge: 15_000n, commissionCut: 1_800n });
    expect(lines(booking)).toEqual([
      [
        'merchant.debit',
        REMOVED_AFTER_PICKUP_REASON,
        [
          ['merchant.account', 12_000n],
          ['platform.order_clearing', -12_000n],
        ],
      ],
      [
        'merchant.commission',
        COMMISSION_REVERSED_REASON,
        [
          ['merchant.account', -1_800n],
          ['platform.revenue_commission', 1_800n],
        ],
      ],
      [
        'merchant.debit',
        FEE_LOWERED_AFTER_PICKUP_REASON,
        [
          ['merchant.account', 3_000n],
          ['platform.order_clearing', -3_000n],
        ],
      ],
    ]);
  });

  it('charges the captain, or books on the platform, the merchant net and the fee cut', () => {
    const captain = afterPickupEntries({ ...facts, responsible: 'captain' });
    expect(captain).toMatchObject({ charge: 13_200n, commissionCut: 1_800n });
    expect(lines(captain)).toEqual([
      [
        'earn.charge',
        REMOVED_AFTER_PICKUP_REASON,
        [
          ['captain.earnings', 10_200n],
          ['platform.order_clearing', -10_200n],
        ],
      ],
      [
        'earn.charge',
        FEE_LOWERED_AFTER_PICKUP_REASON,
        [
          ['captain.earnings', 3_000n],
          ['platform.order_clearing', -3_000n],
        ],
      ],
    ]);
    const platform = afterPickupEntries({ ...facts, responsible: 'platform' });
    expect(platform.journals.map((journal) => journal.type)).toEqual([
      'platform.operating_cost',
      'platform.operating_cost',
    ]);
    expect(platform.charge).toBe(13_200n);
  });

  it('books the whole removed value on a test order, which has no commission', () => {
    const booking = afterPickupEntries({
      ...facts,
      deliveryFeeAfter: 4_000n,
      responsible: 'captain',
      commissionOf: () => 0n,
    });
    expect(booking).toMatchObject({ charge: 12_000n, commissionCut: 0n });
    expect(booking.journals).toHaveLength(1);
  });

  it('rounds the commission once: the cut is the difference of the commissions', () => {
    // 15% of 1003 is 150.45 → 150; of 501 is 75.15 → 75; the cut is 75.
    const booking = afterPickupEntries({
      ...facts,
      itemsValueBefore: 1_003n,
      itemsValueAfter: 501n,
      deliveryFeeAfter: 4_000n,
      responsible: 'restaurant',
    });
    expect(booking.commissionCut).toBe(75n);
  });

  it('refuses a raise, which an edit after the pickup never makes', () => {
    expect(() =>
      afterPickupEntries({ ...facts, deliveryFeeAfter: 5_000n, responsible: 'platform' }),
    ).toThrow();
  });
});
