import { describe, expect, it } from 'vitest';
import {
  type CodeContext,
  codeRefusal,
  type CodeRow,
  type CodeTerms,
  fixedAmountAboveItems,
  minuteOfDay,
  promoDiscount,
} from './promo-codes.js';

// AP §8.4's caps and the funder's split, and CU Appendix C's refusals
// (slice 2.21b), without a database.
const percent: CodeTerms = {
  kind: 'percentage',
  percentBp: 1000,
  amount: null,
  maxDiscount: 3000n,
  merchantShareBp: 0,
};

describe('promoDiscount', () => {
  it("gives AP §8.4's platform code: 10% of 400 capped at 30", () => {
    expect(promoDiscount(percent, { itemsValue: 40000n, deliveryFee: 4000n })).toEqual({
      total: 3000n,
      merchant: 0n,
      onDelivery: false,
    });
  });

  it('rounds a percentage half up below its cap', () => {
    const terms = { ...percent, percentBp: 1250, maxDiscount: null };
    expect(promoDiscount(terms, { itemsValue: 1001n, deliveryFee: 0n }).total).toBe(125n);
    expect(promoDiscount(terms, { itemsValue: 1004n, deliveryFee: 0n }).total).toBe(126n);
  });

  it('caps a fixed amount at the items value, the rest lost', () => {
    const terms: CodeTerms = {
      ...percent,
      kind: 'fixed_amount',
      percentBp: null,
      maxDiscount: null,
      amount: 5000n,
    };
    expect(promoDiscount(terms, { itemsValue: 3000n, deliveryFee: 1000n }).total).toBe(3000n);
    expect(promoDiscount(terms, { itemsValue: 9000n, deliveryFee: 1000n }).total).toBe(5000n);
    expect(fixedAmountAboveItems(terms, 3000n)).toBe(true);
    expect(fixedAmountAboveItems(terms, 5000n)).toBe(false);
    expect(fixedAmountAboveItems(percent, 1n)).toBe(false);
  });

  it('takes the whole fee for free delivery', () => {
    const terms: CodeTerms = {
      ...percent,
      kind: 'free_delivery',
      percentBp: null,
      maxDiscount: null,
    };
    expect(promoDiscount(terms, { itemsValue: 9000n, deliveryFee: 1500n })).toEqual({
      total: 1500n,
      merchant: 0n,
      onDelivery: true,
    });
  });

  it("splits by the restaurant's share, half up", () => {
    expect(
      promoDiscount({ ...percent, merchantShareBp: 10000 }, { itemsValue: 40000n, deliveryFee: 0n })
        .merchant,
    ).toBe(3000n);
    expect(
      promoDiscount({ ...percent, merchantShareBp: 3333 }, { itemsValue: 40000n, deliveryFee: 0n })
        .merchant,
    ).toBe(1000n);
    expect(
      promoDiscount(
        { ...percent, maxDiscount: 3n, merchantShareBp: 5000 },
        { itemsValue: 40000n, deliveryFee: 0n },
      ).merchant,
    ).toBe(2n);
  });
});

const code: CodeRow = {
  ...percent,
  status: 'active',
  currency: 'TRY',
  minOrder: 15000n,
  validFrom: new Date('2026-12-01T00:00:00Z'),
  validTo: new Date('2026-12-31T00:00:00Z'),
  startMinute: null,
  endMinute: null,
  totalLimit: 100,
  perCustomerLimit: 1,
  audience: 'everyone',
  restaurantIds: [],
  zoneIds: [],
  dailyBudget: null,
};

const context: CodeContext = {
  now: new Date('2026-12-10T12:00:00Z'),
  minuteOfDay: 15 * 60,
  baseCurrency: 'TRY',
  restaurantId: 'r1',
  zoneId: 'z1',
  itemsValue: 20000n,
  customer: { newUser: true, uses: 0, phoneOrDeviceUsed: false },
  totalUses: 0,
  dayCost: 0n,
};

const refusal = (row: Partial<CodeRow>, ctx: Partial<CodeContext> = {}) =>
  codeRefusal({ ...code, ...row }, { ...context, ...ctx })?.refusal ?? null;

describe('codeRefusal', () => {
  it('accepts a code within every rule', () => {
    expect(codeRefusal(code, context)).toBeNull();
  });

  it('refuses a code paused, not started, ended or in another base as not valid now', () => {
    expect(refusal({ status: 'paused' })).toBe('not_valid_now');
    expect(refusal({ validFrom: new Date('2026-12-11T00:00:00Z') })).toBe('not_valid_now');
    expect(refusal({ validTo: context.now })).toBe('not_valid_now');
    expect(refusal({ currency: 'USD' })).toBe('not_valid_now');
  });

  it('keeps to its hours on the city clock, past midnight included', () => {
    expect(refusal({ startMinute: 14 * 60, endMinute: 16 * 60 })).toBeNull();
    expect(refusal({ startMinute: 16 * 60, endMinute: 18 * 60 })).toBe('not_valid_now');
    expect(refusal({ startMinute: 22 * 60, endMinute: 2 * 60 }, { minuteOfDay: 60 })).toBeNull();
    expect(refusal({ startMinute: 22 * 60, endMinute: 2 * 60 })).toBe('not_valid_now');
    expect(refusal({ startMinute: 14 * 60, endMinute: 15 * 60 })).toBe('not_valid_now');
  });

  it('says what is missing below its minimum, on the items value', () => {
    expect(codeRefusal(code, { ...context, itemsValue: 12000n })).toEqual({
      refusal: 'below_minimum',
      missing: 3000n,
    });
    expect(refusal({}, { itemsValue: 15000n })).toBeNull();
  });

  it('keeps to its restaurants and zones', () => {
    expect(refusal({ restaurantIds: ['r2'] })).toBe('not_for_restaurant');
    expect(refusal({ restaurantIds: ['r2', 'r1'] })).toBeNull();
    expect(refusal({ zoneIds: ['z2'] })).toBe('not_for_restaurant');
    expect(refusal({ zoneIds: ['z1'] }, { zoneId: null })).toBe('not_for_restaurant');
  });

  it('takes a new user only, once per number and device', () => {
    const newUsers = { audience: 'new_users' as const };
    expect(refusal(newUsers)).toBeNull();
    expect(
      refusal(newUsers, { customer: { newUser: false, uses: 0, phoneOrDeviceUsed: false } }),
    ).toBe('first_order_only');
    expect(
      refusal(newUsers, { customer: { newUser: true, uses: 0, phoneOrDeviceUsed: true } }),
    ).toBe('first_order_only');
    // A guest's quote leaves it to placing.
    expect(refusal(newUsers, { customer: null })).toBeNull();
  });

  it('counts the limits and the day', () => {
    expect(refusal({}, { customer: { newUser: false, uses: 1, phoneOrDeviceUsed: true } })).toBe(
      'used_before',
    );
    expect(
      refusal(
        { perCustomerLimit: null },
        { customer: { newUser: false, uses: 5, phoneOrDeviceUsed: true } },
      ),
    ).toBeNull();
    expect(refusal({}, { totalUses: 100 })).toBe('uses_ended');
    expect(refusal({}, { totalUses: 99 })).toBeNull();
    expect(refusal({ dailyBudget: 5000n }, { dayCost: 5000n })).toBe('budget_reached');
    expect(refusal({ dailyBudget: 5000n }, { dayCost: 4999n })).toBeNull();
  });
});

describe('minuteOfDay', () => {
  it("reads the city's clock", () => {
    expect(minuteOfDay(new Date('2026-12-10T12:30:00Z'), 'Asia/Damascus')).toBe(15 * 60 + 30);
    expect(minuteOfDay(new Date('2026-12-10T21:00:00Z'), 'Asia/Damascus')).toBe(0);
  });
});
