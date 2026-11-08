import { describe, expect, it } from 'vitest';
import type { Menu, MenuItem, MenuOptionGroup } from '../merchants/index.js';
import { type CartLine, priceLines, quoteMoney, quoteVersion, thresholds } from './quote.js';

// CU §10.1–10.2, §10.6 and AP §8.4: the quote's lines and money, in base
// minor units (TRY, 1 TRY = 100).
const tryAmount = (amount: bigint) => ({ amount, currency: 'TRY' });

const option = (id: string, delta: bigint, available = true) => ({
  id,
  name: id,
  priceDelta: tryAmount(delta),
  available,
  switchedOff: available ? null : { until: null },
});

const size: MenuOptionGroup = {
  id: 'size',
  name: 'الحجم',
  minChoices: 1,
  maxChoices: 1,
  options: [option('medium', 0n), option('large', 2_000n)],
};
const extras: MenuOptionGroup = {
  id: 'extras',
  name: 'إضافات',
  minChoices: 0,
  maxChoices: 2,
  options: [option('cheese', 500n), option('garlic', 300n), option('pickles', 200n, false)],
};

const item = (id: string, price: bigint, extra: Partial<MenuItem> = {}): MenuItem => ({
  id,
  code: id,
  name: id,
  description: null,
  photoKey: null,
  price: tryAmount(price),
  available: true,
  switchedOff: null,
  hidden: false,
  optionGroups: [],
  ...extra,
});

const menu: Menu = {
  categories: [
    {
      id: 'meals',
      name: 'وجبات',
      hidden: false,
      available: true,
      switchedOff: null,
      window: null,
      inWindow: true,
      items: [
        item('shawarma', 12_000n, { optionGroups: [size, extras] }),
        item('drink', 3_000n, { available: false, switchedOff: { until: null } }),
        item('secret', 1_000n, { hidden: true }),
      ],
    },
    {
      id: 'hidden',
      name: 'مخفي',
      hidden: true,
      available: true,
      switchedOff: null,
      window: null,
      inWindow: true,
      items: [item('ghost', 1_000n)],
    },
  ],
};

const line = (
  itemId: string,
  optionIds: string[] = [],
  extra: Partial<CartLine> = {},
): CartLine => ({
  itemId,
  optionIds,
  quantity: 1,
  note: null,
  // The shawarma's price with the medium size.
  knownUnitPrice: 12_000n,
  ...extra,
});

describe('priceLines', () => {
  it('prices a line with its options and quantity', () => {
    const [priced] = priceLines(
      menu,
      [line('shawarma', ['large', 'cheese'], { quantity: 2, knownUnitPrice: 14_500n })],
      'TRY',
    );
    expect(priced).toMatchObject({
      itemId: 'shawarma',
      unitPrice: 14_500n,
      lineTotal: 29_000n,
      problems: [],
      options: [
        { id: 'large', priceDelta: 2_000n },
        { id: 'cheese', priceDelta: 500n },
      ],
    });
  });

  it('marks what cannot be ordered, never pricing it', () => {
    const priced = priceLines(
      menu,
      [
        line('drink'),
        line('secret'),
        line('ghost'),
        line('nothing'),
        line('shawarma', ['large', 'pickles']),
      ],
      'TRY',
    );
    expect(priced.map((entry) => entry.problems)).toEqual([
      ['item_unavailable'],
      ['item_not_found'],
      ['item_not_found'],
      ['item_not_found'],
      ['option_unavailable'],
    ]);
    expect(priced.every((entry) => entry.lineTotal === null)).toBe(true);
  });

  it("refuses choices that break a group's rule or are not the item's", () => {
    const problems = (optionIds: string[]) =>
      priceLines(menu, [line('shawarma', optionIds)], 'TRY')[0]!.problems;
    // The required size missing, two sizes, three extras, an unknown option, a repeat.
    expect(problems([])).toEqual(['options_invalid']);
    expect(problems(['medium', 'large'])).toEqual(['options_invalid']);
    expect(problems(['medium', 'cheese', 'garlic', 'pickles'])).toContain('options_invalid');
    expect(problems(['medium', 'olives'])).toEqual(['option_not_found']);
    expect(problems(['medium', 'cheese', 'cheese'])).toEqual(['options_invalid']);
    expect(problems(['medium'])).toEqual([]);
  });

  it('flags a price that changed since the customer saw it (CU §10.1)', () => {
    const priced = priceLines(
      menu,
      [line('shawarma', ['medium'], { knownUnitPrice: 11_000n })],
      'TRY',
    );
    expect(priced[0]).toMatchObject({ unitPrice: 12_000n, problems: ['price_changed'] });
  });

  it('checks no currency without a base, which the quote shows as rates_unavailable', () => {
    expect(priceLines(menu, [line('shawarma', ['medium'])], null)[0]!.problems).toEqual([]);
  });

  it('refuses a price outside the base currency', () => {
    expect(priceLines(menu, [line('shawarma', ['medium'])], 'USD')[0]!.problems).toEqual([
      'price_not_in_base_currency',
    ]);
  });
});

describe('quoteMoney (AP §8.4)', () => {
  it('adds the items and the fee, takes the discount and rounds the total to the base unit', () => {
    // 129.70 + 40 = 169.70 TRY, to the nearest 5 TRY: 170, rounding +0.30.
    expect(
      quoteMoney({
        itemsValue: 12_970n,
        deliveryFee: 4_000n,
        discount: 0n,
        rounding: { unitMinor: 500n, mode: 'nearest' },
      }),
    ).toEqual({
      itemsValue: 12_970n,
      deliveryFee: 4_000n,
      discount: 0n,
      rounding: 30n,
      total: 17_000n,
    });
  });

  it('rounds down when the mode says so, and not at all without a rule', () => {
    expect(
      quoteMoney({
        itemsValue: 12_970n,
        deliveryFee: 4_000n,
        discount: 0n,
        rounding: { unitMinor: 500n, mode: 'down' },
      }),
    ).toMatchObject({ rounding: -470n, total: 16_500n });
    expect(
      quoteMoney({ itemsValue: 12_970n, deliveryFee: 4_000n, discount: 0n, rounding: null }),
    ).toMatchObject({ rounding: 0n, total: 16_970n });
  });

  it('never takes the total below 0', () => {
    expect(
      quoteMoney({ itemsValue: 1_000n, deliveryFee: 0n, discount: 5_000n, rounding: null }),
    ).toMatchObject({ total: 0n });
  });
});

describe('thresholds (CU §10.2)', () => {
  it('compares the items value with the minimum order and the free-delivery threshold', () => {
    expect(
      thresholds({ itemsValue: 8_000n, minimumOrder: 10_000n, freeDeliveryFrom: 50_000n }),
    ).toEqual({
      minimumOrder: { reached: false, missing: 2_000n },
      freeDelivery: { reached: false, missing: 42_000n },
    });
    expect(
      thresholds({ itemsValue: 50_000n, minimumOrder: 10_000n, freeDeliveryFrom: 50_000n }),
    ).toEqual({
      minimumOrder: { reached: true, missing: 0n },
      freeDelivery: { reached: true, missing: 0n },
    });
    expect(thresholds({ itemsValue: 0n, minimumOrder: 0n, freeDeliveryFrom: null })).toEqual({
      minimumOrder: { reached: true, missing: 0n },
      freeDelivery: null,
    });
  });
});

describe('quoteVersion (CU §10.6)', () => {
  const parts = {
    lines: [{ itemId: 'shawarma', optionIds: ['medium'], quantity: 1, unitPrice: 12_000n }],
    money: { itemsValue: 12_000n, deliveryFee: 4_000n, discount: 0n, rounding: 0n, total: 16_000n },
    equivalents: [{ currency: 'USD', amount: 400n }],
    rateVersions: [{ currency: 'USD', rateVersionId: 'r1' }],
    problems: [],
  };

  it('stays the same for the same money, rates and problems', () => {
    expect(quoteVersion(parts)).toBe(quoteVersion(structuredClone(parts)));
    expect(quoteVersion(parts)).toMatch(/^[0-9a-f]{32}$/);
  });

  it('changes with a money line, an equivalent, a rate version or a blocking problem', () => {
    const versions = [
      quoteVersion(parts),
      quoteVersion({ ...parts, money: { ...parts.money, deliveryFee: 3_000n, total: 15_000n } }),
      quoteVersion({ ...parts, equivalents: [{ currency: 'USD', amount: 450n }] }),
      quoteVersion({ ...parts, rateVersions: [{ currency: 'USD', rateVersionId: 'r2' }] }),
      quoteVersion({ ...parts, problems: [{ code: 'below_minimum_order', line: null }] }),
    ];
    expect(new Set(versions).size).toBe(versions.length);
  });
});
