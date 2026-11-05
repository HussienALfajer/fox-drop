import { describe, expect, it } from 'vitest';
import { checkDeliveryFeeRule, type DeliveryFeeRule, deliveryFeeFor } from './delivery-fee.js';

// The delivery fee of AP §9.12.3, in integer minor units of the city's base
// currency (docs/domain/04-order-money.md).
const flat: DeliveryFeeRule = {
  kind: 'flat',
  currency: 'TRY',
  flatFee: 4000n,
  minimumFee: null,
  freeDeliveryFrom: null,
};

// 0–2 km = 30, 2–4 km = 40, farther = 55.
const bands: DeliveryFeeRule = {
  kind: 'distance_bands',
  currency: 'TRY',
  bands: [
    { upToMetres: 2000, fee: 3000n },
    { upToMetres: 4000, fee: 4000n },
    { upToMetres: null, fee: 5500n },
  ],
  minimumFee: null,
  freeDeliveryFrom: null,
};

describe('deliveryFeeFor', () => {
  it('charges a flat fee whatever the distance', () => {
    expect(deliveryFeeFor(flat, { itemsValue: 12_000n })).toEqual({ fee: 4000n, free: false });
    expect(deliveryFeeFor(flat, { itemsValue: 12_000n, metres: 9000 })).toEqual({
      fee: 4000n,
      free: false,
    });
  });

  it('charges the band a distance falls in, its upper edge included', () => {
    const fee = (metres: number) => deliveryFeeFor(bands, { itemsValue: 1n, metres }).fee;
    expect(fee(0)).toBe(3000n);
    expect(fee(2000)).toBe(3000n);
    expect(fee(2001)).toBe(4000n);
    expect(fee(4000)).toBe(4000n);
    expect(fee(4001)).toBe(5500n);
    expect(fee(50_000)).toBe(5500n);
  });

  it('needs the distance for distance bands', () => {
    expect(() => deliveryFeeFor(bands, { itemsValue: 1n })).toThrow(RangeError);
  });

  it('raises a fee below the minimum fee to it', () => {
    const rule = { ...bands, minimumFee: 3500n };
    expect(deliveryFeeFor(rule, { itemsValue: 1n, metres: 500 }).fee).toBe(3500n);
    expect(deliveryFeeFor(rule, { itemsValue: 1n, metres: 3000 }).fee).toBe(4000n);
  });

  it('delivers free from the threshold on the items value, the threshold included', () => {
    const rule = { ...flat, minimumFee: 3000n, freeDeliveryFrom: 50_000n };
    expect(deliveryFeeFor(rule, { itemsValue: 49_999n })).toEqual({ fee: 4000n, free: false });
    expect(deliveryFeeFor(rule, { itemsValue: 50_000n })).toEqual({ fee: 0n, free: true });
    expect(deliveryFeeFor(rule, { itemsValue: 80_000n })).toEqual({ fee: 0n, free: true });
  });
});

describe('checkDeliveryFeeRule', () => {
  it('accepts a flat rule and distance bands', () => {
    expect(checkDeliveryFeeRule(flat)).toBeNull();
    expect(checkDeliveryFeeRule(bands)).toBeNull();
  });

  it('refuses negative amounts and a threshold of zero', () => {
    expect(checkDeliveryFeeRule({ ...flat, flatFee: -1n })).not.toBeNull();
    expect(checkDeliveryFeeRule({ ...flat, minimumFee: -1n })).not.toBeNull();
    expect(checkDeliveryFeeRule({ ...flat, freeDeliveryFrom: 0n })).not.toBeNull();
  });

  it('refuses bands that leave a distance without a fee', () => {
    const withBands = (list: { upToMetres: number | null; fee: bigint }[]) =>
      checkDeliveryFeeRule({ ...bands, bands: list });
    expect(withBands([])).not.toBeNull();
    expect(withBands([{ upToMetres: 2000, fee: 3000n }])).not.toBeNull();
    expect(
      withBands([
        { upToMetres: 4000, fee: 3000n },
        { upToMetres: 2000, fee: 4000n },
        { upToMetres: null, fee: 5000n },
      ]),
    ).not.toBeNull();
    expect(
      withBands([
        { upToMetres: null, fee: 3000n },
        { upToMetres: null, fee: 4000n },
      ]),
    ).not.toBeNull();
    expect(
      withBands([
        { upToMetres: 0, fee: 1n },
        { upToMetres: null, fee: 2n },
      ]),
    ).not.toBeNull();
    expect(
      withBands([
        { upToMetres: 1.5, fee: 1n },
        { upToMetres: null, fee: 2n },
      ]),
    ).not.toBeNull();
    expect(withBands([{ upToMetres: null, fee: -1n }])).not.toBeNull();
  });

  it('refuses what the database cannot hold', () => {
    expect(checkDeliveryFeeRule({ ...flat, flatFee: 2n ** 63n })).not.toBeNull();
    expect(
      checkDeliveryFeeRule({
        ...bands,
        bands: [
          { upToMetres: 2 ** 31, fee: 1n },
          { upToMetres: null, fee: 2n },
        ],
      }),
    ).not.toBeNull();
  });

  it('refuses a currency code that is not three capital letters', () => {
    expect(checkDeliveryFeeRule({ ...flat, currency: 'try' })).not.toBeNull();
  });
});
