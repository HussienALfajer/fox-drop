import { describe, expect, it } from 'vitest';
import type { RateSnapshot } from '../fx/index.js';
import { checkDoorPayment, commission, waitingMinutes } from './door-payment.js';

// Azaz's placeholder rules: TRY the base, rounded to 5 TRY; USD at 41.20 TRY,
// rounded to 0.50 USD; SYP at 1/290 TRY, rounded to 500 SYP. Amounts are in
// minor units (AP §8.6).
const snapshot: RateSnapshot = {
  cityId: 'azaz',
  baseCurrency: 'TRY',
  takenAt: new Date('2026-11-06T10:00:00Z'),
  currencies: [
    {
      code: 'TRY',
      decimals: 2,
      rate: { numerator: 1n, denominator: 1n },
      rateVersionId: null,
      roundingUnitMinor: 500n,
      roundingMode: 'nearest',
    },
    {
      code: 'USD',
      decimals: 2,
      rate: { numerator: 412n, denominator: 10n },
      rateVersionId: 'usd-1',
      roundingUnitMinor: 50n,
      roundingMode: 'nearest',
    },
    {
      code: 'SYP',
      decimals: 2,
      rate: { numerator: 1n, denominator: 290n },
      rateVersionId: 'syp-1',
      roundingUnitMinor: 50_000n,
      roundingMode: 'nearest',
    },
  ],
};
const TRY = (amount: bigint) => ({ currency: 'TRY', amount });
const USD = (amount: bigint) => ({ currency: 'USD', amount });

describe('checkDoorPayment (AP §8.6, CA §9.7)', () => {
  it('takes the exact amount in the base with no change', () => {
    expect(checkDoorPayment(snapshot, [TRY(44_000n)], [], 44_000n)).toEqual({
      netBase: 44_000n,
      shortfall: 0n,
      roundingGap: 0n,
      perCurrency: [{ currency: 'TRY', net: 44_000n, base: 44_000n }],
    });
  });

  it('nets the change against what was received', () => {
    const result = checkDoorPayment(snapshot, [TRY(50_000n)], [TRY(6_000n)], 44_000n);
    expect(result).toMatchObject({ netBase: 44_000n, shortfall: 0n, roundingGap: 0n });
  });

  it('converts another currency with the snapshot, change given in the base', () => {
    // 11 USD = 453.20 TRY; 13.20 TRY back leaves 440 TRY.
    const result = checkDoorPayment(snapshot, [USD(1_100n)], [TRY(1_320n)], 44_000n);
    expect(result).toEqual({
      netBase: 44_000n,
      shortfall: 0n,
      roundingGap: 0n,
      perCurrency: [
        { currency: 'USD', net: 1_100n, base: 45_320n },
        { currency: 'TRY', net: -1_320n, base: -1_320n },
      ],
    });
  });

  it('books a gap within half the largest rounding unit of the lines as rounding', () => {
    // 10.70 USD = 440.84 TRY: 0.84 TRY over, within half of 0.50 USD (10.30 TRY).
    expect(checkDoorPayment(snapshot, [USD(1_070n)], [], 44_000n)).toMatchObject({
      netBase: 44_084n,
      shortfall: 0n,
      roundingGap: -84n,
    });
    // 2.50 TRY short in the base alone: within half of 5 TRY.
    expect(checkDoorPayment(snapshot, [TRY(43_750n)], [], 44_000n)).toMatchObject({
      shortfall: 0n,
      roundingGap: 250n,
    });
  });

  it('flags a shortfall beyond rounding with the missing amount', () => {
    expect(checkDoorPayment(snapshot, [TRY(40_000n)], [], 44_000n)).toMatchObject({
      netBase: 40_000n,
      shortfall: 4_000n,
      roundingGap: 0n,
    });
  });

  it('refuses a net above the amount due beyond rounding', () => {
    expect(checkDoorPayment(snapshot, [TRY(50_000n)], [], 44_000n)).toBe('overpaid');
  });

  it('refuses lines that are empty, repeated, zero or in a currency not accepted', () => {
    expect(checkDoorPayment(snapshot, [], [], 44_000n)).toBe('invalid_lines');
    expect(checkDoorPayment(snapshot, [TRY(1n), TRY(2n)], [], 3n)).toBe('invalid_lines');
    expect(checkDoorPayment(snapshot, [TRY(0n)], [], 0n)).toBe('invalid_lines');
    expect(checkDoorPayment(snapshot, [TRY(44_000n)], [TRY(0n)], 44_000n)).toBe('invalid_lines');
    expect(checkDoorPayment(snapshot, [{ currency: 'EUR', amount: 1_000n }], [], 1_000n)).toBe(
      'currency_not_accepted',
    );
  });
});

describe('waitingMinutes (docs/domain/04)', () => {
  const at = (minute: number) => new Date(Date.UTC(2026, 10, 6, 12, minute));
  const order = {
    acceptedAt: at(0),
    prepMin: 20,
    arrivedAtMerchantAt: at(10),
    // captain.waiting_threshold_min (10) after the arrival.
    captainWaitingAlertAt: at(20),
  };

  it('counts from the prep due time when the captain came early', () => {
    // Due at 12:20, paid from 12:30; picked up at 12:34.
    expect(waitingMinutes({ ...order, pickedUpAt: at(34) })).toBe(4);
    expect(waitingMinutes({ ...order, pickedUpAt: at(29) })).toBe(0);
  });

  it('counts from the arrival when the captain came after the food was due', () => {
    const late = { ...order, arrivedAtMerchantAt: at(25), captainWaitingAlertAt: at(35) };
    expect(waitingMinutes({ ...late, pickedUpAt: at(40) })).toBe(5);
  });

  it('counts whole minutes only, and none without an arrival', () => {
    const pickedUpAt = new Date(at(34).getTime() + 59_000);
    expect(waitingMinutes({ ...order, pickedUpAt })).toBe(4);
    expect(
      waitingMinutes({
        ...order,
        arrivedAtMerchantAt: null,
        captainWaitingAlertAt: null,
        pickedUpAt: at(50),
      }),
    ).toBe(0);
  });
});

describe('commission (AP §8.4)', () => {
  it('is the rate on the items value, to the nearest minor unit, half up', () => {
    expect(commission(40_000n, 1500)).toBe(6_000n);
    expect(commission(333n, 1500)).toBe(50n); // 49.95
    expect(commission(10n, 1250)).toBe(1n); // 1.25
    expect(commission(30n, 1500)).toBe(5n); // 4.5
    expect(commission(40_000n, 0)).toBe(0n);
  });
});
