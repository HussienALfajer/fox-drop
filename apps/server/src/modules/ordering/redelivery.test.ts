import { describe, expect, it } from 'vitest';
import {
  REDELIVERY_PAY_REASON,
  REDELIVERY_REASON,
  redeliveryEntries,
  redeliveryLinePrice,
} from './redelivery.js';

// AP §9.9.3, docs/domain/10, §8.9 (slice 2.23d): what a free re-delivery
// posts at its normal delivery, besides the order's own journals (the
// pickup, the commission, the captain's pay against
// platform.compensation_cost). From the platform's side.

const facts = {
  restaurantId: 'restaurant-1',
  responsibleCaptainId: 'captain-1',
  currency: 'TRY',
  // The affected items at their prices: the pickup payment.
  itemsValue: 12_000n,
  // 15% of 12 000.
  commission: 1_800n,
  payTotal: 3_500n,
  testOrder: false,
};

const lines = (journals: ReturnType<typeof redeliveryEntries>) =>
  journals.map((journal) => [
    journal.type,
    journal.reason,
    journal.entries.map((entry) => [entry.account, entry.party.id, entry.amount]),
  ]);

describe('redeliveryLinePrice', () => {
  it('replaces the items at no price when the restaurant is responsible', () => {
    expect(redeliveryLinePrice('restaurant', 6_000n)).toBe(0n);
    expect(redeliveryLinePrice('captain', 6_000n)).toBe(6_000n);
    expect(redeliveryLinePrice('platform', 6_000n)).toBe(6_000n);
  });
});

describe('redeliveryEntries', () => {
  it('posts nothing more with the restaurant responsible (pickup 0, no commission)', () => {
    expect(
      redeliveryEntries({
        ...facts,
        responsible: 'restaurant',
        itemsValue: 0n,
        commission: 0n,
        chargePay: false,
      }),
    ).toEqual([]);
  });

  it('charges the restaurant the captain pay when operations charge it', () => {
    expect(
      lines(
        redeliveryEntries({
          ...facts,
          responsible: 'restaurant',
          itemsValue: 0n,
          commission: 0n,
          chargePay: true,
        }),
      ),
    ).toEqual([
      [
        'merchant.debit',
        REDELIVERY_PAY_REASON,
        [
          ['merchant.account', 'restaurant-1', 3_500n],
          ['platform.compensation_cost', null, -3_500n],
        ],
      ],
    ]);
  });

  it('books the pickup payment as the platform cost with the platform responsible', () => {
    // The commission (1 800) stays revenue, so the platform bears the
    // merchant net, 10 200.
    expect(
      lines(redeliveryEntries({ ...facts, responsible: 'platform', chargePay: false })),
    ).toEqual([
      [
        'platform.compensation_cost',
        REDELIVERY_REASON,
        [
          ['platform.order_clearing', null, -12_000n],
          ['platform.compensation_cost', null, 12_000n],
        ],
      ],
    ]);
  });

  it('charges the responsible captain the merchant net, and the pay when charged', () => {
    expect(lines(redeliveryEntries({ ...facts, responsible: 'captain', chargePay: true }))).toEqual(
      [
        [
          'platform.compensation_cost',
          REDELIVERY_REASON,
          [
            ['platform.order_clearing', null, -12_000n],
            ['platform.compensation_cost', null, 12_000n],
          ],
        ],
        [
          'earn.charge',
          REDELIVERY_REASON,
          [
            ['captain.earnings', 'captain-1', 10_200n],
            ['platform.compensation_cost', null, -10_200n],
          ],
        ],
        [
          'earn.charge',
          REDELIVERY_PAY_REASON,
          [
            ['captain.earnings', 'captain-1', 3_500n],
            ['platform.compensation_cost', null, -3_500n],
          ],
        ],
      ],
    );
  });

  it('books a test order on the test cost and charges nobody', () => {
    expect(
      lines(
        redeliveryEntries({
          ...facts,
          responsible: 'captain',
          commission: 0n,
          chargePay: true,
          testOrder: true,
        }),
      ),
    ).toEqual([
      [
        'platform.test_cost',
        REDELIVERY_REASON,
        [
          ['platform.order_clearing', null, -12_000n],
          ['platform.test_cost', null, 12_000n],
        ],
      ],
    ]);
  });
});
