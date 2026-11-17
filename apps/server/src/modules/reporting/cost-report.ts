import type { SourceCost } from '../ledger/index.js';
import type { PersonalCodeOrigin } from '../marketing/index.js';
import { type CostOrder, type OperatingCostCause, operatingCostCause } from '../ordering/index.js';

// «كلفة التعويضات والخصومات» (AP §9.10.6, §8.11; slice 2.22d): a period's
// entries on the platform's discount, compensation and operating cost
// accounts (`LedgerService.sourceCosts`, + a cost), split by reason, by
// code, by responsible party and by restaurant. Every amount is in the base.

// The accounts the report reads (docs/domain/11). A test order's costs are
// on platform.test_cost and stay out.
export const costAccounts = [
  'platform.discount_cost',
  'platform.compensation_cost',
  'platform.operating_cost',
] as const;

export type CostParty = NonNullable<CostOrder['cancelResponsible']>;

// A line of the compensation cost: a reason of «تعويض الزبون», the automatic
// late codes' own line, or the cost with no personal code the report can
// read behind it.
export const compensationLineKinds = ['reason', 'late_delivery', 'other'] as const;
export type CompensationLineKind = (typeof compensationLineKinds)[number];

export interface CostInput {
  base: string;
  toBase: (amount: bigint, currency: string) => bigint;
  entries: readonly SourceCost[];
  // The orders the entries belong to, and the orders their personal codes
  // were given for.
  orders: ReadonlyMap<string, CostOrder>;
  // Where each personal code used came from, by the code's id.
  origins: ReadonlyMap<string, PersonalCodeOrigin>;
}

export interface CostTotals {
  // Platform-funded discounts of the codes of «أكواد الخصم».
  discounts: bigint;
  compensation: bigint;
  operating: bigint;
  total: bigint;
}

export interface CostReportFigures {
  currency: string;
  totals: CostTotals;
  // The compensation cost by line: `reason` with the reason's code in
  // «تعويض الزبون» and its label as chosen, `late_delivery` for the late
  // codes, `other` for the rest (both without a code). `orders` counts the
  // orders the codes were used on.
  compensationReasons: {
    kind: CompensationLineKind;
    reason: string | null;
    label: string | null;
    orders: number;
    amount: bigint;
  }[];
  operatingReasons: { reason: OperatingCostCause; orders: number; amount: bigint }[];
  // The discounts by code; `codeId` null for an order the report cannot read.
  codes: { codeId: string | null; code: string | null; orders: number; amount: bigint }[];
  // The operating cost by the party operations named responsible; null
  // where none was named.
  parties: { party: CostParty | null; orders: number; amount: bigint }[];
  // By restaurant: a discount and an operating cost under the order's, a
  // compensation under the restaurant of the order compensated; null for
  // an entry without an order the report can read.
  restaurants: ({ restaurantId: string | null } & CostTotals)[];
}

// One line of a split: its amount and the orders behind it.
class Bucket {
  amount = 0n;
  readonly orders = new Set<string>();
  add(amount: bigint, orderId: string | null) {
    this.amount += amount;
    if (orderId !== null) this.orders.add(orderId);
  }
}

class Split<K> {
  private readonly buckets = new Map<K, Bucket>();
  add(key: K, amount: bigint, orderId: string | null) {
    let bucket = this.buckets.get(key);
    if (!bucket) this.buckets.set(key, (bucket = new Bucket()));
    bucket.add(amount, orderId);
  }
  // The lines that did not cancel out, the largest first.
  lines(): { key: K; orders: number; amount: bigint }[] {
    return [...this.buckets]
      .filter(([, bucket]) => bucket.amount !== 0n)
      .map(([key, bucket]) => ({ key, orders: bucket.orders.size, amount: bucket.amount }))
      .sort((a, b) => (a.amount === b.amount ? 0 : a.amount < b.amount ? 1 : -1));
  }
}

export function costReport(input: CostInput): CostReportFigures {
  const totals: CostTotals = { discounts: 0n, compensation: 0n, operating: 0n, total: 0n };
  const compensationReasons = new Split<string>();
  const labels = new Map<string, string>();
  const operatingReasons = new Split<OperatingCostCause>();
  const codes = new Split<string | null>();
  const codeNames = new Map<string, string | null>();
  const parties = new Split<CostParty | null>();
  const restaurants = new Map<string | null, CostTotals>();
  const book = (restaurantId: string | null, kind: keyof Omit<CostTotals, 'total'>, by: bigint) => {
    let row = restaurants.get(restaurantId);
    if (!row) {
      restaurants.set(
        restaurantId,
        (row = { discounts: 0n, compensation: 0n, operating: 0n, total: 0n }),
      );
    }
    row[kind] += by;
    row.total += by;
    totals[kind] += by;
    totals.total += by;
  };

  for (const entry of input.entries) {
    const amount = input.toBase(entry.amount, entry.currency);
    const order = entry.orderId === null ? undefined : input.orders.get(entry.orderId);
    switch (entry.purpose) {
      case 'platform.discount_cost': {
        const codeId = order?.promoCodeId ?? null;
        codes.add(codeId, amount, entry.orderId);
        if (codeId !== null) codeNames.set(codeId, order?.promoCode ?? null);
        book(order?.restaurantId ?? null, 'discounts', amount);
        break;
      }
      case 'platform.compensation_cost': {
        const origin =
          order?.promoCodeId == null ? undefined : input.origins.get(order.promoCodeId);
        // A reason's key is prefixed, so no code of Content's list can
        // take a fixed line's.
        let reason: string = 'other';
        if (origin?.kind === 'compensation') {
          reason = `reason:${origin.reasonCode}`;
          labels.set(reason, origin.reasonLabel);
        } else if (origin?.kind === 'late') {
          reason = 'late_delivery';
        }
        compensationReasons.add(reason, amount, entry.orderId);
        // The restaurant of the order compensated, where the cost began.
        const compensated = origin ? input.orders.get(origin.orderId) : order;
        book(compensated?.restaurantId ?? null, 'compensation', amount);
        break;
      }
      case 'platform.operating_cost': {
        const { cause, responsible } = operatingCostCause(
          { id: entry.journalId, type: entry.type, reason: entry.reason },
          order,
        );
        operatingReasons.add(cause, amount, entry.orderId);
        parties.add(responsible, amount, entry.orderId);
        book(order?.restaurantId ?? null, 'operating', amount);
        break;
      }
      default:
        throw new Error(`${entry.purpose} is no cost account of the report`);
    }
  }

  return {
    currency: input.base,
    totals,
    compensationReasons: compensationReasons.lines().map(({ key, ...line }) =>
      key === 'late_delivery' || key === 'other'
        ? { kind: key, reason: null, label: null, ...line }
        : {
            kind: 'reason' as const,
            reason: key.slice('reason:'.length),
            label: labels.get(key) ?? null,
            ...line,
          },
    ),
    operatingReasons: operatingReasons
      .lines()
      .map(({ key, ...line }) => ({ reason: key, ...line })),
    codes: codes.lines().map(({ key, ...line }) => ({
      codeId: key,
      code: key === null ? null : (codeNames.get(key) ?? null),
      ...line,
    })),
    parties: parties.lines().map(({ key, ...line }) => ({ party: key, ...line })),
    restaurants: [...restaurants]
      .filter(([, row]) => row.discounts !== 0n || row.compensation !== 0n || row.operating !== 0n)
      .map(([restaurantId, row]) => ({ restaurantId, ...row }))
      .sort((a, b) => (a.total === b.total ? 0 : a.total < b.total ? 1 : -1)),
  };
}
