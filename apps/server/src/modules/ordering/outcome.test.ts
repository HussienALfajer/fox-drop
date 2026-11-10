import { describe, expect, it } from 'vitest';
import {
  CHARGE_RETURNED_REASON,
  COMMISSION_RESTORED_REASON,
  FEE_CUT_RETURNED_REASON,
  outcomeEntries,
  PAY_OFFSET_REASON,
  PICKUP_RETURNED_REASON,
  type OutcomeChoices,
  type OutcomeFacts,
} from './outcome.js';

// AP §8.9, docs/domain/09 (slice 2.11a): the entries «تحديد النتيجة» posts
// with nothing collected, from the platform's side. The pickup already put
// the items value on the order clearing account (+40 000 here), so every
// outcome's journals take it back to zero. The numbers are AP §8.4's example
// in minor units: items 400, fee 40, commission 15 % (60), pay 35.

const facts: OutcomeFacts = {
  restaurantId: 'restaurant-1',
  captainId: 'captain-1',
  customerAccountId: 'customer-1',
  currency: 'TRY',
  testOrder: false,
  commissionBp: 1500,
  itemsValue: 40_000n,
  deliveryFee: 4_000n,
  discount: 0n,
  total: 44_000n,
  pickup: {
    itemsValue: 40_000n,
    restaurantCharge: 0n,
    restaurantCommissionCut: 0n,
    captainCharge: 0n,
    platformCharge: 0n,
    feeCuts: { restaurant: 0n, captain: 0n, platform: 0n },
  },
  pay: { orderPay: 3_500n, waiting: 0n },
  duesRule: { kind: 'fee_plus_merchant_net', fixed: null },
};

const failed = (choices: Partial<OutcomeChoices>): OutcomeChoices => ({
  outcome: 'failed_other',
  responsible: 'platform',
  delivered: false,
  food: 'kept_by_captain',
  amountToCollect: 0n,
  ...choices,
});

type Booked = Exclude<ReturnType<typeof outcomeEntries>, { problem: string }>;

function booked(result: ReturnType<typeof outcomeEntries>): Booked {
  if ('problem' in result) throw new Error(result.problem);
  return result;
}

const lines = (result: ReturnType<typeof outcomeEntries>) =>
  booked(result).journals.map((journal) => [
    journal.type,
    journal.reason,
    journal.entries.map((entry) => [entry.account, entry.amount]),
  ]);

// What the outcome leaves on the order clearing account, the pickup's
// +40 000 and the edits' entries included.
const clearingAfter = (result: ReturnType<typeof outcomeEntries>, before: bigint) =>
  booked(result)
    .journals.flatMap((journal) => journal.entries)
    .filter((entry) => entry.account === 'platform.order_clearing')
    .reduce((sum, entry) => sum + entry.amount, before);

describe('outcomeEntries', () => {
  it("books AP §8.4's fake order with the customer responsible", () => {
    const result = outcomeEntries(facts, failed({ outcome: 'fake', responsible: 'customer' }));
    expect(booked(result)).toMatchObject({
      status: 'failed',
      loss: 34_000n,
      dues: 38_000n,
      merchantDebit: null,
      captainPay: 3_500n,
    });
    expect(lines(result)).toEqual([
      [
        'merchant.commission',
        null,
        [
          ['merchant.account', 6_000n],
          ['platform.order_clearing', -6_000n],
        ],
      ],
      [
        'dues.charge',
        null,
        [
          ['customer.dues', 38_000n],
          ['platform.order_clearing', -34_000n],
          ['platform.revenue_delivery', -4_000n],
        ],
      ],
      [
        'earn.order_pay',
        null,
        [
          ['captain.earnings', -3_500n],
          ['platform.captain_pay', 3_500n],
        ],
      ],
    ]);
    expect(clearingAfter(result, 40_000n)).toBe(0n);
  });

  it('charges the captain the loss and pays nothing when the captain is responsible', () => {
    const result = outcomeEntries(facts, failed({ responsible: 'captain' }));
    expect(booked(result)).toMatchObject({ loss: 34_000n, dues: null, captainPay: 0n });
    expect(lines(result)).toEqual([
      [
        'merchant.commission',
        null,
        [
          ['merchant.account', 6_000n],
          ['platform.order_clearing', -6_000n],
        ],
      ],
      [
        'earn.charge',
        'تعذّر التسليم',
        [
          ['captain.earnings', 34_000n],
          ['platform.order_clearing', -34_000n],
        ],
      ],
    ]);
    expect(clearingAfter(result, 40_000n)).toBe(0n);
  });

  it('books the loss and the pay as operating cost when the platform is responsible', () => {
    const result = outcomeEntries(facts, failed({ responsible: 'platform' }));
    expect(lines(result)).toEqual([
      [
        'merchant.commission',
        null,
        [
          ['merchant.account', 6_000n],
          ['platform.order_clearing', -6_000n],
        ],
      ],
      [
        'platform.operating_cost',
        null,
        [
          ['platform.operating_cost', 34_000n],
          ['platform.order_clearing', -34_000n],
        ],
      ],
      [
        'earn.order_pay',
        null,
        [
          ['captain.earnings', -3_500n],
          ['platform.operating_cost', 3_500n],
        ],
      ],
    ]);
  });

  it('has the restaurant return the pickup payment, with no commission, when it is responsible', () => {
    const result = outcomeEntries(
      facts,
      failed({
        outcome: 'wrong_refused',
        responsible: 'restaurant',
        food: 'returned_to_restaurant',
      }),
    );
    expect(booked(result)).toMatchObject({ loss: 0n, merchantDebit: 40_000n, captainPay: 3_500n });
    expect(lines(result)).toEqual([
      [
        'merchant.debit',
        PICKUP_RETURNED_REASON,
        [
          ['merchant.account', 40_000n],
          ['platform.order_clearing', -40_000n],
        ],
      ],
      [
        'earn.order_pay',
        null,
        [
          ['captain.earnings', -3_500n],
          ['platform.operating_cost', 3_500n],
        ],
      ],
    ]);
    expect(clearingAfter(result, 40_000n)).toBe(0n);
  });

  it('pays the waiting pay apart', () => {
    const result = outcomeEntries(
      { ...facts, pay: { orderPay: 3_500n, waiting: 500n } },
      failed({ responsible: 'platform' }),
    );
    expect(booked(result).captainPay).toBe(4_000n);
    expect(lines(result).at(-1)).toEqual([
      'earn.waiting_pay',
      null,
      [
        ['captain.earnings', -500n],
        ['platform.operating_cost', 500n],
      ],
    ]);
  });

  it('ends free and damaged orders delivered, and a damaged one failed when asked', () => {
    expect(
      booked(outcomeEntries(facts, failed({ outcome: 'free', delivered: true, food: null }))),
    ).toMatchObject({ status: 'delivered', loss: 34_000n });
    expect(
      booked(outcomeEntries(facts, failed({ outcome: 'damaged', delivered: true, food: null })))
        .status,
    ).toBe('delivered');
    expect(booked(outcomeEntries(facts, failed({ outcome: 'damaged' }))).status).toBe('failed');
  });

  describe('after an edit after the pickup, nobody pays twice (owner decision 2026-11-10)', () => {
    // 12 000 of items removed after the pickup: the commission on 40 000 is
    // 6 000, on 28 000 it is 4 200, so the cut is 1 800.
    const restaurantEdited: OutcomeFacts = {
      ...facts,
      itemsValue: 28_000n,
      pickup: { ...facts.pickup, restaurantCharge: 12_000n, restaurantCommissionCut: 1_800n },
    };
    const captainEdited: OutcomeFacts = {
      ...facts,
      itemsValue: 28_000n,
      pickup: { ...facts.pickup, captainCharge: 10_200n },
    };

    it('has the restaurant return the rest of the pickup payment and undoes its reversal', () => {
      const result = outcomeEntries(
        restaurantEdited,
        failed({ responsible: 'restaurant', food: 'destroyed' }),
      );
      expect(booked(result).merchantDebit).toBe(29_800n);
      expect(lines(result).slice(0, 2)).toEqual([
        [
          'merchant.debit',
          PICKUP_RETURNED_REASON,
          [
            ['merchant.account', 28_000n],
            ['platform.order_clearing', -28_000n],
          ],
        ],
        [
          'merchant.commission',
          COMMISSION_RESTORED_REASON,
          [
            ['merchant.account', 1_800n],
            ['platform.revenue_commission', -1_800n],
          ],
        ],
      ]);
      // The pickup +40 000 and the edit's debit −12 000.
      expect(clearingAfter(result, 28_000n)).toBe(0n);
    });

    it("counts the restaurant's edit in another party's loss", () => {
      const result = outcomeEntries(restaurantEdited, failed({ responsible: 'platform' }));
      expect(booked(result).loss).toBe(23_800n);
      expect(lines(result)[0]).toEqual([
        'merchant.commission',
        null,
        [
          ['merchant.account', 6_000n],
          ['platform.revenue_commission', -1_800n],
          ['platform.order_clearing', -4_200n],
        ],
      ]);
      expect(clearingAfter(result, 28_000n)).toBe(0n);
    });

    it("counts the captain's edit in the loss", () => {
      const result = outcomeEntries(captainEdited, failed({ responsible: 'platform' }));
      // The merchant net of the 28 000 left: 28 000 − 4 200.
      expect(booked(result).loss).toBe(23_800n);
      // The pickup +40 000 and the captain's charge −10 200.
      expect(clearingAfter(result, 29_800n)).toBe(0n);
    });

    it('gives back a lower fee charged after the pickup, since no fee is booked', () => {
      // The captain bore a fee cut of 2 000 (a charge of 2 000, no items).
      const feeCut: OutcomeFacts = {
        ...facts,
        deliveryFee: 2_000n,
        pickup: {
          ...facts.pickup,
          captainCharge: 2_000n,
          feeCuts: { restaurant: 0n, captain: 2_000n, platform: 0n },
        },
      };
      const result = outcomeEntries(feeCut, failed({ responsible: 'platform' }));
      expect(lines(result)[0]).toEqual([
        'earn.charge',
        FEE_CUT_RETURNED_REASON,
        [
          ['captain.earnings', -2_000n],
          ['platform.order_clearing', 2_000n],
        ],
      ]);
      expect(booked(result).loss).toBe(34_000n);
      // The pickup +40 000 and the edit's charge −2 000.
      expect(clearingAfter(result, 38_000n)).toBe(0n);
    });

    it("gives the captain's charge back when the restaurant is responsible", () => {
      const result = outcomeEntries(captainEdited, failed({ responsible: 'restaurant' }));
      expect(lines(result).slice(0, 2)).toEqual([
        [
          'merchant.debit',
          PICKUP_RETURNED_REASON,
          [
            ['merchant.account', 40_000n],
            ['platform.order_clearing', -40_000n],
          ],
        ],
        [
          'earn.charge',
          CHARGE_RETURNED_REASON,
          [
            ['captain.earnings', -10_200n],
            ['platform.order_clearing', 10_200n],
          ],
        ],
      ]);
      expect(clearingAfter(result, 29_800n)).toBe(0n);
    });
  });

  describe('the dues rule (customer.fake_order_dues_rule)', () => {
    const fake = failed({ outcome: 'fake', responsible: 'customer' });

    it('charges the fee and the items value, the rest as the delivery revenue', () => {
      const result = outcomeEntries(
        { ...facts, duesRule: { kind: 'fee_plus_items_value', fixed: null } },
        fake,
      );
      expect(booked(result).dues).toBe(44_000n);
      expect(lines(result)[1]).toEqual([
        'dues.charge',
        null,
        [
          ['customer.dues', 44_000n],
          ['platform.order_clearing', -34_000n],
          ['platform.revenue_delivery', -10_000n],
        ],
      ]);
    });

    it('books what a fixed amount leaves of the loss as operating cost', () => {
      const result = outcomeEntries(
        { ...facts, duesRule: { kind: 'fixed', fixed: 20_000n } },
        fake,
      );
      expect(lines(result).slice(1, 3)).toEqual([
        [
          'dues.charge',
          null,
          [
            ['customer.dues', 20_000n],
            ['platform.order_clearing', -20_000n],
          ],
        ],
        [
          'platform.operating_cost',
          null,
          [
            ['platform.operating_cost', 14_000n],
            ['platform.order_clearing', -14_000n],
          ],
        ],
      ]);
      expect(clearingAfter(result, 40_000n)).toBe(0n);
    });

    it('refuses a fixed rule without its amount', () => {
      expect(outcomeEntries({ ...facts, duesRule: { kind: 'fixed', fixed: null } }, fake)).toEqual({
        problem: 'dues_rule_unset',
      });
    });
  });

  it('books a test order without commission, its costs as the test cost', () => {
    const result = outcomeEntries(
      { ...facts, testOrder: true, commissionBp: null },
      failed({ responsible: 'platform' }),
    );
    expect(lines(result)).toEqual([
      [
        'platform.test_cost',
        null,
        [
          ['platform.test_cost', 40_000n],
          ['platform.order_clearing', -40_000n],
        ],
      ],
      [
        'earn.order_pay',
        null,
        [
          ['captain.earnings', -3_500n],
          ['platform.test_cost', 3_500n],
        ],
      ],
    ]);
  });

  it.each([
    ['normal is not an outcome to set', failed({ outcome: 'normal' })],
    ['fake needs the customer', failed({ outcome: 'fake', responsible: 'platform' })],
    ['the customer is responsible only for a fake order', failed({ responsible: 'customer' })],
    ['free is delivered', failed({ outcome: 'free' })],
    ['a failed outcome is never delivered', failed({ delivered: true, food: null })],
    ['a failed order says where the food went', failed({ food: null })],
    ['a delivered order has no food to place', failed({ outcome: 'free', delivered: true })],
    [
      'the food goes back only with the restaurant responsible',
      failed({ food: 'returned_to_restaurant' }),
    ],
  ])('refuses: %s', (_, choices) => {
    expect(outcomeEntries(facts, choices)).toEqual({ problem: 'invalid_outcome' });
  });

  // Slice 2.11b (K9): an amount to collect, only on a delivered outcome and
  // below the order total. The collection put the captain's custody up and
  // the order clearing account down by it (the custody lines are the
  // collection's own); these journals settle what is left.
  describe('with an amount to collect (K9)', () => {
    const delivered = (choices: Partial<OutcomeChoices>) =>
      failed({ outcome: 'free', delivered: true, food: null, ...choices });

    it('lowers the loss by what was collected', () => {
      const result = outcomeEntries(facts, delivered({ amountToCollect: 5_000n }));
      expect(booked(result)).toMatchObject({
        status: 'delivered',
        loss: 29_000n,
        captainPay: 3_500n,
      });
      expect(lines(result)).toEqual([
        [
          'merchant.commission',
          null,
          [
            ['merchant.account', 6_000n],
            ['platform.order_clearing', -6_000n],
          ],
        ],
        [
          'platform.operating_cost',
          null,
          [
            ['platform.operating_cost', 29_000n],
            ['platform.order_clearing', -29_000n],
          ],
        ],
        [
          'earn.order_pay',
          null,
          [
            ['captain.earnings', -3_500n],
            ['platform.operating_cost', 3_500n],
          ],
        ],
      ]);
      expect(clearingAfter(result, 35_000n)).toBe(0n);
    });

    it('books what was collected beyond the merchant net as delivery revenue', () => {
      const result = outcomeEntries(
        facts,
        delivered({ outcome: 'damaged', responsible: 'captain', amountToCollect: 38_000n }),
      );
      expect(booked(result)).toMatchObject({ loss: 0n, captainPay: 0n });
      expect(lines(result)).toEqual([
        [
          'merchant.commission',
          null,
          [
            ['merchant.account', 6_000n],
            ['platform.order_clearing', -6_000n],
          ],
        ],
        [
          'platform.revenue_delivery',
          null,
          [
            ['platform.order_clearing', 4_000n],
            ['platform.revenue_delivery', -4_000n],
          ],
        ],
      ]);
      expect(clearingAfter(result, 2_000n)).toBe(0n);
    });

    it("offsets the captain's pay with it when the restaurant is responsible", () => {
      const result = outcomeEntries(
        facts,
        delivered({ responsible: 'restaurant', amountToCollect: 5_000n }),
      );
      expect(booked(result)).toMatchObject({
        loss: 0n,
        merchantDebit: 40_000n,
        captainPay: 3_500n,
      });
      expect(lines(result)).toEqual([
        [
          'merchant.debit',
          PICKUP_RETURNED_REASON,
          [
            ['merchant.account', 40_000n],
            ['platform.order_clearing', -40_000n],
          ],
        ],
        [
          'earn.order_pay',
          null,
          [
            ['captain.earnings', -3_500n],
            ['platform.operating_cost', 3_500n],
          ],
        ],
        [
          'platform.operating_cost',
          PAY_OFFSET_REASON,
          [
            ['platform.operating_cost', -3_500n],
            ['platform.order_clearing', 3_500n],
          ],
        ],
        [
          'platform.revenue_delivery',
          null,
          [
            ['platform.order_clearing', 1_500n],
            ['platform.revenue_delivery', -1_500n],
          ],
        ],
      ]);
      expect(clearingAfter(result, 35_000n)).toBe(0n);
    });

    it('books the rest of the pay as operating cost when the amount is below it', () => {
      const result = outcomeEntries(
        { ...facts, pay: { orderPay: 3_500n, waiting: 500n } },
        delivered({ responsible: 'restaurant', amountToCollect: 2_000n }),
      );
      expect(lines(result).slice(1)).toEqual([
        [
          'earn.order_pay',
          null,
          [
            ['captain.earnings', -3_500n],
            ['platform.operating_cost', 3_500n],
          ],
        ],
        [
          'earn.waiting_pay',
          null,
          [
            ['captain.earnings', -500n],
            ['platform.operating_cost', 500n],
          ],
        ],
        [
          'platform.operating_cost',
          PAY_OFFSET_REASON,
          [
            ['platform.operating_cost', -2_000n],
            ['platform.order_clearing', 2_000n],
          ],
        ],
      ]);
      expect(clearingAfter(result, 38_000n)).toBe(0n);
    });

    it('charges the captain the loss less what was collected', () => {
      const result = outcomeEntries(
        facts,
        delivered({ responsible: 'captain', amountToCollect: 20_000n }),
      );
      expect(booked(result)).toMatchObject({ loss: 14_000n, captainPay: 0n });
      expect(lines(result).at(-1)).toEqual([
        'earn.charge',
        'مجاني',
        [
          ['captain.earnings', 14_000n],
          ['platform.order_clearing', -14_000n],
        ],
      ]);
      expect(clearingAfter(result, 20_000n)).toBe(0n);
    });

    it('counts a lower fee an edit after the pickup charged (nobody pays twice)', () => {
      const edited = {
        ...facts,
        deliveryFee: 3_000n,
        total: 43_000n,
        pickup: {
          ...facts.pickup,
          platformCharge: 1_000n,
          feeCuts: { restaurant: 0n, captain: 0n, platform: 1_000n },
        },
      };
      const result = outcomeEntries(edited, delivered({ amountToCollect: 5_000n }));
      expect(booked(result).loss).toBe(29_000n);
      expect(lines(result)[0]).toEqual([
        'platform.operating_cost',
        FEE_CUT_RETURNED_REASON,
        [
          ['platform.operating_cost', -1_000n],
          ['platform.order_clearing', 1_000n],
        ],
      ]);
      // The pickup's 40 000, the edit's −1 000 and the collection's −5 000.
      expect(clearingAfter(result, 34_000n)).toBe(0n);
    });

    it.each([
      ['on a failed order', failed({ amountToCollect: 5_000n })],
      ['below zero', delivered({ amountToCollect: -1n })],
      ['the whole total', delivered({ amountToCollect: 44_000n })],
    ])('refuses an amount %s', (_, choices) => {
      expect(outcomeEntries(facts, choices)).toEqual({ problem: 'invalid_outcome' });
    });
  });

  it('refuses an order whose pay table has no rate for the captain', () => {
    expect(outcomeEntries({ ...facts, pay: null }, failed({}))).toEqual({
      problem: 'captain_pay_unset',
    });
    expect(
      booked(outcomeEntries({ ...facts, pay: null }, failed({ responsible: 'captain' })))
        .captainPay,
    ).toBe(0n);
  });
});
