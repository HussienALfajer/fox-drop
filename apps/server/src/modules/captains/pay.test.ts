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

describe('orderPay', () => {
  it('pays the base pay up to the included distance, its edge included', () => {
    expect(orderPay(placeholder, { metres: 0, waitingMinutes: 0 })).toBe(2_500n);
    expect(orderPay(placeholder, { metres: 2_000, waitingMinutes: 0 })).toBe(2_500n);
    expect(orderPay(placeholder, { metres: 3_000, waitingMinutes: 0 })).toBe(2_500n);
  });

  it('pays each extra metre pro rata, rounded down to the minor unit', () => {
    expect(orderPay(placeholder, { metres: 3_400, waitingMinutes: 0 })).toBe(2_700n);
    expect(orderPay(placeholder, { metres: 3_401, waitingMinutes: 0 })).toBe(2_700n);
    expect(orderPay(placeholder, { metres: 3_402, waitingMinutes: 0 })).toBe(2_701n);
    expect(orderPay(placeholder, { metres: 10_000, waitingMinutes: 0 })).toBe(6_000n);
  });

  it('adds the waiting minutes past the threshold at the waiting rate', () => {
    const waiting = { ...placeholder, waitingPerMinute: 100n };
    expect(orderPay(waiting, { metres: 3_400, waitingMinutes: 4 })).toBe(3_100n);
  });

  it('raises the pay to the minimum pay per order', () => {
    const low = { ...placeholder, basePay: 1_000n, minimumPay: 2_000n };
    expect(orderPay(low, { metres: 3_000, waitingMinutes: 0 })).toBe(2_000n);
    expect(orderPay(low, { metres: 6_000, waitingMinutes: 0 })).toBe(2_500n);
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
