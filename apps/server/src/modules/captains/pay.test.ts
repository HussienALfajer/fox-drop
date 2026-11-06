import { describe, expect, it } from 'vitest';
import { checkPayRate, orderPay, type PayRate } from './pay.js';

// AP §9.12.5: the pay of one order for a vehicle, in minor units of the
// table's currency. The placeholder of development and staging: 25 TRY
// including the first 3 km, 5 TRY per extra km pro rata by the metre and
// rounded down (owner decisions 2026-11-05 and 2026-11-06).
const placeholder: PayRate = {
  basePay: 2_500n,
  includedMetres: 3_000,
  perExtraKm: 500n,
  waitingPerMinute: 0n,
  minimumPay: 2_500n,
};

const pay = (rate: PayRate, metres: number, waitingMinutes = 0) =>
  orderPay(rate, { metres, waitingMinutes }).orderPay;

describe('orderPay', () => {
  it('pays the base pay up to the included distance, its edge included', () => {
    expect(pay(placeholder, 0)).toBe(2_500n);
    expect(pay(placeholder, 2_000)).toBe(2_500n);
    expect(pay(placeholder, 3_000)).toBe(2_500n);
  });

  it('pays each extra metre pro rata, rounded down to the minor unit', () => {
    expect(pay(placeholder, 3_400)).toBe(2_700n);
    expect(pay(placeholder, 3_401)).toBe(2_700n);
    expect(pay(placeholder, 3_402)).toBe(2_701n);
    expect(pay(placeholder, 10_000)).toBe(6_000n);
  });

  it('gives the parts: base, distance, top-up and their sum (AP §8.5.5, CA §9.8)', () => {
    expect(orderPay(placeholder, { metres: 5_000, waitingMinutes: 0 })).toEqual({
      base: 2_500n,
      distance: 1_000n,
      topUp: 0n,
      orderPay: 3_500n,
      waiting: 0n,
    });
  });

  it('raises the order pay to the minimum pay, with the top-up apart', () => {
    const low = { ...placeholder, basePay: 1_000n, minimumPay: 2_000n };
    expect(orderPay(low, { metres: 3_000, waitingMinutes: 0 })).toEqual({
      base: 1_000n,
      distance: 0n,
      topUp: 1_000n,
      orderPay: 2_000n,
      waiting: 0n,
    });
    expect(pay(low, 6_000)).toBe(2_500n);
  });

  it('adds the waiting pay on top, never absorbed by the minimum (docs/domain/04)', () => {
    const low = { ...placeholder, basePay: 1_000n, minimumPay: 2_000n, waitingPerMinute: 100n };
    expect(orderPay(low, { metres: 3_000, waitingMinutes: 4 })).toEqual({
      base: 1_000n,
      distance: 0n,
      topUp: 1_000n,
      orderPay: 2_000n,
      waiting: 400n,
    });
  });

  it('refuses a distance or a waiting time that is not a whole number of zero or more', () => {
    expect(() => orderPay(placeholder, { metres: -1, waitingMinutes: 0 })).toThrow(RangeError);
    expect(() => orderPay(placeholder, { metres: 1.5, waitingMinutes: 0 })).toThrow(RangeError);
    expect(() => orderPay(placeholder, { metres: 0, waitingMinutes: -1 })).toThrow(RangeError);
  });
});

describe('checkPayRate', () => {
  it('accepts the placeholder', () => {
    expect(checkPayRate(placeholder)).toBeNull();
  });

  it('refuses negative amounts and a distance that is not whole metres', () => {
    expect(checkPayRate({ ...placeholder, basePay: -1n })).not.toBeNull();
    expect(checkPayRate({ ...placeholder, perExtraKm: -1n })).not.toBeNull();
    expect(checkPayRate({ ...placeholder, waitingPerMinute: -1n })).not.toBeNull();
    expect(checkPayRate({ ...placeholder, minimumPay: -1n })).not.toBeNull();
    expect(checkPayRate({ ...placeholder, includedMetres: -1 })).not.toBeNull();
    expect(checkPayRate({ ...placeholder, includedMetres: 2.5 })).not.toBeNull();
    expect(checkPayRate({ ...placeholder, basePay: 2n ** 63n })).not.toBeNull();
  });
});
