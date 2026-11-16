import { describe, expect, it } from 'vitest';
import type { CityTotal } from '../ledger/index.js';
import { dailyFigures, type DayInput } from './daily-figures.js';

// «التقرير اليومي» (AP §9.10.1, §8.11; slice 2.20d): one business day's
// figures from the ledger's totals, from the platform's side.

const usdVersion = '0190f3a0-0000-7000-8000-00000000a001';

function total(
  purpose: CityTotal['purpose'],
  type: CityTotal['type'],
  amount: bigint,
  currency = 'TRY',
  rates: CityTotal['rates'] = null,
): CityTotal {
  return { period: 0, purpose, type, currency, rates, amount };
}

// 1 USD = 40 TRY at the journal's version, 41 TRY otherwise (2 decimals
// both).
function toBase(amount: bigint, currency: string, versionId: string | null): bigint {
  if (currency === 'TRY') return amount;
  return amount * (versionId === usdVersion ? 40n : 41n);
}

function input(totals: CityTotal[], overrides: Partial<DayInput> = {}): DayInput {
  return {
    base: 'TRY',
    orders: { count: 0, gmv: 0n, itemsValue: 0n },
    totals,
    distancePay: 0n,
    toBase,
    custody: [],
    restaurants: [],
    ...overrides,
  };
}

// The AP §8.4 worked example: items 400 paid at pickup, customer pays 410
// (fee 40, platform code 30), commission 15% = 60, captain pay 25 of which
// 5 for the distance; a restaurant-funded discount of 10 elsewhere.
const workedExample: CityTotal[] = [
  total('captain.custody', 'custody.pay_merchant', -40_000n),
  total('platform.order_clearing', 'custody.pay_merchant', 40_000n),
  total('captain.custody', 'custody.collect', 41_000n),
  total('platform.order_clearing', 'custody.collect', -41_000n),
  total('platform.order_clearing', 'platform.revenue_delivery', 4_000n),
  total('platform.revenue_delivery', 'platform.revenue_delivery', -4_000n),
  total('platform.order_clearing', 'platform.discount_cost', -3_000n),
  total('platform.discount_cost', 'platform.discount_cost', 3_000n),
  total('merchant.account', 'merchant.commission', 6_000n),
  total('platform.revenue_commission', 'merchant.commission', -6_000n),
  total('merchant.account', 'merchant.discount_share', 1_000n),
  total('platform.order_clearing', 'merchant.discount_share', -1_000n),
  total('captain.earnings', 'earn.order_pay', -2_500n),
  total('platform.captain_pay', 'earn.order_pay', 2_500n),
];

describe('dailyFigures', () => {
  it('reports the orders, fees, discounts by funder, commission, captain pay and margin (AP §8.4)', () => {
    const figures = dailyFigures(
      input(workedExample, {
        orders: { count: 1, gmv: 41_000n, itemsValue: 40_000n },
        distancePay: 500n,
      }),
    );
    expect(figures.currency).toBe('TRY');
    expect(figures.orders).toEqual({ count: 1, gmv: 41_000n, itemsValue: 40_000n });
    expect(figures.deliveryFees).toBe(4_000n);
    expect(figures.discounts).toEqual({ platform: 3_000n, restaurant: 1_000n });
    expect(figures.commission).toBe(6_000n);
    expect(figures.captainPay).toEqual({
      base: 2_000n,
      distance: 500n,
      waiting: 0n,
      peak: 0n,
      bonuses: 0n,
      total: 2_500n,
    });
    expect(figures.compensation).toBe(0n);
    expect(figures.operatingCost).toBe(0n);
    expect(figures.testCost).toBe(0n);
    expect(figures.fxRounding).toBe(0n);
    expect(figures.adjustments).toBe(0n);
    // 60 + 40 − 30 − 25.
    expect(figures.margin).toBe(4_500n);
  });

  it('takes the waiting, peak and bonuses apart, and costs borne by the platform from the margin (AP §8.9)', () => {
    const figures = dailyFigures(
      input([
        total('captain.earnings', 'earn.waiting_pay', -300n),
        total('platform.captain_pay', 'earn.waiting_pay', 300n),
        total('captain.earnings', 'earn.peak_bonus', -200n),
        total('platform.captain_pay', 'earn.peak_bonus', 200n),
        total('captain.earnings', 'earn.bonus', -1_000n),
        total('platform.captain_pay', 'earn.bonus', 1_000n),
        // Pay borne by the platform under §8.9 is an operating cost, not
        // captain pay, in the margin; the captain still earned it.
        total('captain.earnings', 'earn.order_pay', -2_500n),
        total('platform.operating_cost', 'earn.order_pay', 2_500n),
        total('platform.operating_cost', 'platform.operating_cost', 4_000n),
        total('platform.order_clearing', 'platform.operating_cost', -4_000n),
        total('platform.compensation_cost', 'platform.compensation_cost', 1_500n),
        total('platform.order_clearing', 'platform.compensation_cost', -1_500n),
        total('captain.earnings', 'earn.order_pay', -2_500n, 'TRY', null),
        total('platform.test_cost', 'earn.order_pay', 2_500n),
      ]),
    );
    // Only the pay booked to platform.captain_pay: the rest is in the
    // operating and test costs, so the lines add up to the margin.
    expect(figures.captainPay).toEqual({
      base: 0n,
      distance: 0n,
      waiting: 300n,
      peak: 200n,
      bonuses: 1_000n,
      total: 1_500n,
    });
    expect(figures.operatingCost).toBe(6_500n);
    expect(figures.compensation).toBe(1_500n);
    expect(figures.testCost).toBe(2_500n);
    expect(figures.margin).toBe(-(1_500n + 6_500n + 1_500n + 2_500n));
    expect(figures.margin).toBe(
      figures.deliveryFees +
        figures.commission +
        figures.fxRounding +
        figures.adjustments -
        figures.discounts.platform -
        figures.captainPay.total -
        figures.compensation -
        figures.operatingCost -
        figures.testCost,
    );
  });

  it("converts rounding and FX at each journal's rate version, and manual corrections, into the margin", () => {
    const rates = [{ currency: 'USD', rateVersionId: usdVersion }];
    const figures = dailyFigures(
      input([
        // A hand-in of 10 USD for 405 TRY at 40: the platform keeps 5 TRY.
        total('captain.custody', 'custody.fx_convert', -1_000n, 'USD', rates),
        total('platform.fx_rounding', 'custody.fx_convert', 1_000n, 'USD', rates),
        total('captain.custody', 'custody.fx_convert', 40_500n, 'TRY', rates),
        total('platform.fx_rounding', 'custody.fx_convert', -40_500n, 'TRY', rates),
        // A custody correction of 1 USD in the platform's favour, at the
        // rate in force (41).
        total('captain.custody', 'custody.adjustment', 100n, 'USD'),
        total('platform.adjustments', 'custody.adjustment', -100n, 'USD'),
        total('captain.earnings', 'earn.adjustment', -700n),
        total('platform.adjustments', 'earn.adjustment', 700n),
      ]),
    );
    expect(figures.fxRounding).toBe(500n);
    expect(figures.adjustments).toBe(4_100n - 700n);
    expect(figures.margin).toBe(500n + 3_400n);
  });

  it("reports the captains' cash per currency: created, handed in, reimbursed, paid out and open (AP §9.10.1)", () => {
    const figures = dailyFigures(
      input(
        [
          ...workedExample,
          total('captain.custody', 'custody.collect', 500n, 'USD'),
          total('platform.order_clearing', 'custody.collect', -500n, 'USD'),
          total('captain.custody', 'custody.change_given', -1_000n),
          total('platform.order_clearing', 'custody.change_given', 1_000n),
          total('captain.custody', 'custody.hand_in', -30_000n),
          total('platform.cash', 'custody.hand_in', 30_000n),
          total('captain.custody', 'custody.reimburse', 2_000n),
          total('platform.cash', 'custody.reimburse', -2_000n),
          total('captain.earnings', 'earn.payout', 10_000n),
          total('platform.cash', 'earn.payout', -10_000n),
          total('merchant.account', 'merchant.settlement', -5_000n),
          total('platform.cash', 'merchant.settlement', 5_000n),
        ],
        {
          custody: [
            { ownerId: 'a', currency: 'TRY', amount: 12_000n },
            { ownerId: 'b', currency: 'TRY', amount: -2_000n },
            { ownerId: 'a', currency: 'USD', amount: 500n },
          ],
        },
      ),
    );
    expect(figures.cash).toEqual([
      {
        currency: 'TRY',
        custodyCreated: 1_000n - 1_000n,
        handedIn: 30_000n,
        reimbursed: 2_000n,
        openCustody: 12_000n,
        owedToCaptains: 2_000n,
        captainPayouts: 10_000n,
        restaurantPayments: 5_000n,
      },
      {
        currency: 'USD',
        custodyCreated: 500n,
        handedIn: 0n,
        reimbursed: 0n,
        openCustody: 500n,
        owedToCaptains: 0n,
        captainPayouts: 0n,
        restaurantPayments: 0n,
      },
    ]);
  });

  it('reports what restaurants owe: posted today and open at the cutoff (AP §8.7)', () => {
    const figures = dailyFigures(
      input(
        [
          ...workedExample,
          // A failed order's commission recovers the pickup payment: still
          // posted to the restaurant, not earned by the platform (§8.9 rule 3).
          total('merchant.account', 'merchant.commission', 1_500n),
          total('platform.order_clearing', 'merchant.commission', -1_500n),
        ],
        {
          restaurants: [
            { ownerId: 'r1', currency: 'TRY', amount: -9_000n },
            { ownerId: 'r2', currency: 'TRY', amount: -1_000n },
            { ownerId: 'r3', currency: 'TRY', amount: 2_000n },
          ],
        },
      ),
    );
    expect(figures.commission).toBe(6_000n);
    expect(figures.restaurants).toEqual({
      commission: 7_500n,
      discountShare: 1_000n,
      owedByRestaurants: 10_000n,
      owedToRestaurants: 2_000n,
    });
  });

  it('shows zero for a day with nothing booked', () => {
    const figures = dailyFigures(input([]));
    expect(figures.margin).toBe(0n);
    expect(figures.cash).toEqual([]);
    expect(figures.restaurants).toEqual({
      commission: 0n,
      discountShare: 0n,
      owedByRestaurants: 0n,
      owedToRestaurants: 0n,
    });
  });
});
