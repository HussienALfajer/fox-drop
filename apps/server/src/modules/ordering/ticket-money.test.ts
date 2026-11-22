import { describe, expect, it } from 'vitest';
import { commission } from './door-payment.js';
import { COMMISSION_REVERSED_REASON } from './order-edits.js';
import {
  affectedValue,
  commissionOn,
  POST_DELIVERY_PROBLEM_REASON,
  ticketMoneyEntries,
  WRONG_CHANGE_REASON,
} from './ticket-money.js';

// AP §8.10, docs/domain/10 (slice 2.23c): what a ticket after a normal
// delivery posts, from the platform's side. The order is settled, so the
// party's side goes against platform.compensation_cost (the remedy's cost
// it recovers) and the commission's reversal against the revenue.

const order = {
  restaurantId: 'restaurant-1',
  captainId: 'captain-1',
  currency: 'TRY',
  itemsValue: 24_000n,
  commissionOf: (value: bigint) => commission(value, 1500),
};

const lines = (journals: ReturnType<typeof ticketMoneyEntries>['journals']) =>
  journals.map((journal) => [
    journal.type,
    journal.reason,
    journal.entries.map((entry) => [entry.account, entry.party.id, entry.amount]),
  ]);

describe('affectedValue', () => {
  const orderLines = [
    { position: 1, quantity: 2, unitPrice: 5_000n },
    { position: 2, quantity: 1, unitPrice: 14_000n },
  ];

  it('adds the affected quantities at their unit prices', () => {
    expect(
      affectedValue(orderLines, [
        { position: 1, quantity: 1 },
        { position: 2, quantity: 1 },
      ]),
    ).toBe(19_000n);
  });

  it('refuses a line not on the order, a repeated line or a quantity beyond the line', () => {
    expect(affectedValue(orderLines, [{ position: 3, quantity: 1 }])).toBeNull();
    expect(
      affectedValue(orderLines, [
        { position: 1, quantity: 1 },
        { position: 1, quantity: 1 },
      ]),
    ).toBeNull();
    expect(affectedValue(orderLines, [{ position: 1, quantity: 3 }])).toBeNull();
    expect(affectedValue(orderLines, [{ position: 1, quantity: 0 }])).toBeNull();
  });
});

describe('ticketMoneyEntries', () => {
  it('debits the restaurant V and reverses the commission on V', () => {
    const booking = ticketMoneyEntries({
      ...order,
      responsible: 'restaurant',
      affected: 6_000n,
      wrongChange: null,
    });
    // 15% of 24 000 is 3 600, of 18 000 is 2 700: the cut is 900.
    expect(booking).toMatchObject({ merchantDebit: 6_000n, captainCharge: 0n });
    expect(lines(booking.journals)).toEqual([
      [
        'merchant.debit',
        POST_DELIVERY_PROBLEM_REASON,
        [
          ['merchant.account', 'restaurant-1', 6_000n],
          ['platform.compensation_cost', null, -6_000n],
        ],
      ],
      [
        'merchant.commission',
        COMMISSION_REVERSED_REASON,
        [
          ['merchant.account', 'restaurant-1', -900n],
          ['platform.revenue_commission', null, 900n],
        ],
      ],
    ]);
  });

  it('charges the captain the merchant net of V', () => {
    const booking = ticketMoneyEntries({
      ...order,
      responsible: 'captain',
      affected: 6_000n,
      wrongChange: null,
    });
    expect(booking).toMatchObject({ merchantDebit: 0n, captainCharge: 5_100n });
    expect(lines(booking.journals)).toEqual([
      [
        'earn.charge',
        POST_DELIVERY_PROBLEM_REASON,
        [
          ['captain.earnings', 'captain-1', 5_100n],
          ['platform.compensation_cost', null, -5_100n],
        ],
      ],
    ]);
  });

  it('charges the captain nothing when the commission takes all of V', () => {
    // At 100% the merchant net of V is 0, and the ledger takes no entry of
    // zero (found by money-journals.property.test.ts).
    const booking = ticketMoneyEntries({
      ...order,
      commissionOf: (value: bigint) => commission(value, 10_000),
      responsible: 'captain',
      affected: 6_000n,
      wrongChange: null,
    });
    expect(booking).toEqual({ journals: [], merchantDebit: 0n, captainCharge: 0n });
  });

  it('posts nothing for the platform, the customer, or no affected items', () => {
    for (const responsible of ['platform', 'customer'] as const) {
      expect(
        ticketMoneyEntries({ ...order, responsible, affected: 6_000n, wrongChange: null }).journals,
      ).toEqual([]);
    }
    expect(
      ticketMoneyEntries({ ...order, responsible: 'restaurant', affected: 0n, wrongChange: null })
        .journals,
    ).toEqual([]);
  });

  it('posts no commission on a test order', () => {
    const booking = ticketMoneyEntries({
      ...order,
      commissionOf: () => 0n,
      responsible: 'captain',
      affected: 6_000n,
      wrongChange: null,
    });
    expect(booking.captainCharge).toBe(6_000n);
  });

  it('never reverses more commission than a restaurant-funded code left booked', () => {
    // Items 10 000, the restaurant funds 2 000 of item discount, 15%: the
    // delivery booked 1 200. Every item missing reverses those 1 200.
    const booking = ticketMoneyEntries({
      ...order,
      itemsValue: 10_000n,
      commissionOf: commissionOn(1500, 2_000n, false),
      responsible: 'captain',
      affected: 10_000n,
      wrongChange: null,
    });
    expect(booking.captainCharge).toBe(8_800n);
    expect(commissionOn(1500, 2_000n, true)(10_000n)).toBe(0n);
  });

  it('charges the captain M for the wrong change returned as a code', () => {
    const booking = ticketMoneyEntries({
      ...order,
      responsible: 'captain',
      affected: 0n,
      wrongChange: { amount: 2_000n, code: true },
    });
    expect(booking.captainCharge).toBe(2_000n);
    expect(lines(booking.journals)).toEqual([
      [
        'earn.charge',
        WRONG_CHANGE_REASON,
        [
          ['captain.earnings', 'captain-1', 2_000n],
          ['platform.compensation_cost', null, -2_000n],
        ],
      ],
    ]);
  });

  it('charges nothing when the captain returned the wrong change in person, or the platform bears it', () => {
    expect(
      ticketMoneyEntries({
        ...order,
        responsible: 'captain',
        affected: 0n,
        wrongChange: { amount: 2_000n, code: false },
      }).journals,
    ).toEqual([]);
    expect(
      ticketMoneyEntries({
        ...order,
        responsible: 'platform',
        affected: 0n,
        wrongChange: { amount: 2_000n, code: true },
      }).journals,
    ).toEqual([]);
  });
});
