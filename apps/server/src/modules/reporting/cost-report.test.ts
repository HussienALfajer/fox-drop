import { describe, expect, it } from 'vitest';
import type { SourceCost } from '../ledger/index.js';
import type { PersonalCodeOrigin } from '../marketing/index.js';
import type { CostOrder } from '../ordering/index.js';
import { type costAccounts, costReport, type CostInput } from './cost-report.js';

// «كلفة التعويضات والخصومات» (AP §9.10.6; slice 2.22d): a period's entries
// on the platform's discount, compensation and operating cost accounts,
// split by reason, by code, by responsible party and by restaurant.

const id = (n: number) => `0190f3a0-0000-7000-8000-${n.toString().padStart(12, '0')}`;
const [pizza, grill] = [id(1), id(2)];
const [fox10, eid, personal, late] = [id(11), id(12), id(13), id(14)];

let journals = 0;
function cost(
  purpose: (typeof costAccounts)[number],
  orderId: string | null,
  amount: bigint,
  overrides: Partial<SourceCost> = {},
): SourceCost {
  journals += 1;
  return {
    journalId: `j-${journals}`,
    purpose,
    type: purpose,
    reason: null,
    orderId,
    currency: 'TRY',
    amount,
    ...overrides,
  };
}

function order(restaurantId: string, overrides: Partial<CostOrder> = {}): CostOrder {
  return {
    restaurantId,
    status: 'delivered',
    cancelResponsible: null,
    outcome: 'normal',
    outcomeResponsible: null,
    outcomes: [],
    promoCodeId: null,
    promoCode: null,
    ...overrides,
  };
}

function input(
  entries: SourceCost[],
  orders: [string, CostOrder][],
  origins: [string, PersonalCodeOrigin][] = [],
): CostInput {
  return {
    base: 'TRY',
    // 1 USD = 40 TRY.
    toBase: (amount, currency) => (currency === 'TRY' ? amount : amount * 40n),
    entries,
    orders: new Map(orders),
    origins: new Map(origins),
  };
}

describe('costReport', () => {
  it('splits the discounts by code and by the restaurant of the order', () => {
    const report = costReport(
      input(
        [
          cost('platform.discount_cost', id(101), 3_000n),
          cost('platform.discount_cost', id(102), 2_000n),
          cost('platform.discount_cost', id(103), 4_000n),
        ],
        [
          [id(101), order(pizza, { promoCodeId: fox10, promoCode: 'FOX10' })],
          [id(102), order(grill, { promoCodeId: fox10, promoCode: 'FOX10' })],
          [id(103), order(grill, { promoCodeId: eid, promoCode: 'EID' })],
        ],
      ),
    );
    expect(report.totals).toEqual({
      discounts: 9_000n,
      compensation: 0n,
      operating: 0n,
      total: 9_000n,
    });
    expect(report.codes).toEqual([
      { codeId: fox10, code: 'FOX10', orders: 2, amount: 5_000n },
      { codeId: eid, code: 'EID', orders: 1, amount: 4_000n },
    ]);
    expect(report.restaurants).toEqual([
      {
        restaurantId: grill,
        discounts: 6_000n,
        compensation: 0n,
        operating: 0n,
        total: 6_000n,
      },
      {
        restaurantId: pizza,
        discounts: 3_000n,
        compensation: 0n,
        operating: 0n,
        total: 3_000n,
      },
    ]);
  });

  it('splits the compensation by its reason, the late code apart, under the restaurant of the order compensated', () => {
    const report = costReport(
      input(
        [
          cost('platform.compensation_cost', id(201), 2_500n),
          cost('platform.compensation_cost', id(202), 1_500n),
          cost('platform.compensation_cost', id(203), 2_000n),
          // No personal code the report can read behind it.
          cost('platform.compensation_cost', id(204), 700n),
        ],
        [
          // The orders the codes were used on, all at the grill.
          [id(201), order(grill, { promoCodeId: personal, promoCode: 'K7M2QP4X' })],
          [id(202), order(grill, { promoCodeId: id(15), promoCode: 'A2B3C4D5' })],
          [id(203), order(grill, { promoCodeId: late, promoCode: 'Z9Y8X7W6' })],
          [id(204), order(grill)],
          // The orders compensated, at the pizza place.
          [id(301), order(pizza)],
        ],
        [
          [
            personal,
            { kind: 'compensation', reasonCode: 'other', reasonLabel: 'أخرى', orderId: id(301) },
          ],
          [
            id(15),
            { kind: 'compensation', reasonCode: 'other', reasonLabel: 'أخرى', orderId: id(301) },
          ],
          [late, { kind: 'late', orderId: id(301) }],
        ],
      ),
    );
    expect(report.totals.compensation).toBe(6_700n);
    expect(report.compensationReasons).toEqual([
      // The reason «أخرى» of Content's list (its code `other`) stays apart
      // from the line of what no personal code explains.
      { kind: 'reason', reason: 'other', label: 'أخرى', orders: 2, amount: 4_000n },
      { kind: 'late_delivery', reason: null, label: null, orders: 1, amount: 2_000n },
      { kind: 'other', reason: null, label: null, orders: 1, amount: 700n },
    ]);
    // A personal code is no code of «أكواد الخصم».
    expect(report.codes).toEqual([]);
    expect(report.restaurants).toEqual([
      {
        restaurantId: pizza,
        discounts: 0n,
        compensation: 6_000n,
        operating: 0n,
        total: 6_000n,
      },
      { restaurantId: grill, discounts: 0n, compensation: 700n, operating: 0n, total: 700n },
    ]);
  });

  it("puts what tickets recovered from the party responsible on its own lines, under the order's restaurant", () => {
    const report = costReport(
      input(
        [
          // The code given on the ticket, used on a later order.
          cost('platform.compensation_cost', id(205), 6_000n),
          // The restaurant's debit of V and the captain's charge, recovering it.
          cost('platform.compensation_cost', id(301), -6_000n, { type: 'merchant.debit' }),
          cost('platform.compensation_cost', id(302), -2_000n, { type: 'earn.charge' }),
        ],
        [
          [id(205), order(grill, { promoCodeId: personal, promoCode: 'K7M2QP4X' })],
          [id(301), order(pizza)],
          [id(302), order(pizza)],
        ],
        [
          [
            personal,
            {
              kind: 'compensation',
              reasonCode: 'missing_item',
              reasonLabel: 'صنف ناقص',
              orderId: id(301),
            },
          ],
        ],
      ),
    );
    expect(report.totals.compensation).toBe(-2_000n);
    expect(report.compensationReasons).toEqual([
      { kind: 'reason', reason: 'missing_item', label: 'صنف ناقص', orders: 1, amount: 6_000n },
      { kind: 'recovered_captain', reason: null, label: null, orders: 1, amount: -2_000n },
      { kind: 'recovered_restaurant', reason: null, label: null, orders: 1, amount: -6_000n },
    ]);
    expect(report.restaurants).toEqual([
      {
        restaurantId: pizza,
        discounts: 0n,
        compensation: -2_000n,
        operating: 0n,
        total: -2_000n,
      },
    ]);
  });

  it('splits the operating cost by its cause and by the responsible party', () => {
    const cancelled = order(pizza, {
      status: 'cancelled',
      outcome: null,
      cancelResponsible: 'customer',
    });
    const failed = order(grill, {
      status: 'failed',
      outcome: 'damaged',
      outcomeResponsible: 'platform',
    });
    const report = costReport(
      input(
        [
          cost('platform.operating_cost', id(401), 34_000n),
          cost('platform.operating_cost', id(401), 2_500n, { type: 'earn.order_pay' }),
          cost('platform.operating_cost', id(402), 30_000n),
          cost('platform.operating_cost', id(402), 2_000n, { type: 'earn.order_pay' }),
          cost('platform.operating_cost', id(403), 900n, { reason: 'نقص في التحصيل' }),
        ],
        [
          [id(401), cancelled],
          [id(402), failed],
          [id(403), order(grill)],
        ],
      ),
    );
    expect(report.totals.operating).toBe(69_400n);
    expect(report.operatingReasons).toEqual([
      { reason: 'cancelled_prepared', orders: 1, amount: 34_000n },
      { reason: 'damaged', orders: 1, amount: 32_000n },
      { reason: 'captain_compensation', orders: 1, amount: 2_500n },
      { reason: 'shortfall', orders: 1, amount: 900n },
    ]);
    expect(report.parties).toEqual([
      { party: 'customer', orders: 1, amount: 36_500n },
      { party: 'platform', orders: 2, amount: 32_900n },
    ]);
    expect(report.restaurants.map((row) => [row.restaurantId, row.operating])).toEqual([
      [pizza, 36_500n],
      [grill, 32_900n],
    ]);
  });

  it('counts a changed outcome against the outcome that posted each journal', () => {
    // Week 1: «تالف», platform responsible, 325.00 (j-a). Week 2: OWN makes
    // the captain responsible; the reversal of j-a falls in week 2.
    const changed = order(grill, {
      status: 'failed',
      outcome: 'damaged',
      outcomeResponsible: 'captain',
      outcomes: [
        { outcome: 'damaged', responsible: 'platform', journalIds: ['j-a'] },
        { outcome: 'damaged', responsible: 'captain', journalIds: ['j-b'] },
      ],
    });
    const week = (amount: bigint) =>
      costReport(
        input(
          [cost('platform.operating_cost', id(601), amount, { journalId: 'j-a' })],
          [[id(601), changed]],
        ),
      );
    expect(week(32_500n).parties).toEqual([{ party: 'platform', orders: 1, amount: 32_500n }]);
    expect(week(-32_500n).parties).toEqual([{ party: 'platform', orders: 1, amount: -32_500n }]);
    expect(week(-32_500n).operatingReasons).toEqual([
      { reason: 'damaged', orders: 1, amount: -32_500n },
    ]);
  });

  it('drops what a reversal took back, and converts another currency into the base', () => {
    const report = costReport(
      input(
        [
          cost('platform.discount_cost', id(501), 3_000n),
          cost('platform.discount_cost', id(501), -3_000n),
          cost('platform.discount_cost', id(502), 100n, { currency: 'USD' }),
          // No order behind it.
          cost('platform.operating_cost', null, 500n),
        ],
        [
          [id(501), order(pizza, { promoCodeId: fox10, promoCode: 'FOX10' })],
          [id(502), order(pizza, { promoCodeId: eid, promoCode: 'EID' })],
        ],
      ),
    );
    expect(report.totals).toEqual({
      discounts: 4_000n,
      compensation: 0n,
      operating: 500n,
      total: 4_500n,
    });
    expect(report.codes).toEqual([{ codeId: eid, code: 'EID', orders: 1, amount: 4_000n }]);
    expect(report.operatingReasons).toEqual([{ reason: 'other', orders: 0, amount: 500n }]);
    expect(report.parties).toEqual([{ party: null, orders: 0, amount: 500n }]);
    expect(report.restaurants).toEqual([
      { restaurantId: pizza, discounts: 4_000n, compensation: 0n, operating: 0n, total: 4_000n },
      { restaurantId: null, discounts: 0n, compensation: 0n, operating: 500n, total: 500n },
    ]);
  });
});
