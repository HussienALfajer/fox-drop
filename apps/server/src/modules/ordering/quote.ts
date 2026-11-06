import { createHash } from 'node:crypto';
import { type RoundingMode, roundToUnit } from '../fx/index.js';
import type { Menu, MenuItem } from '../merchants/index.js';

// CU §9.4, §10.1: a cart line as the app keeps it. knownUnitPrice is the
// unit price the customer last saw, so a change shows before confirming.
export interface CartLine {
  itemId: string;
  optionIds: string[];
  quantity: number;
  note: string | null;
  knownUnitPrice: bigint;
}

// Why a line cannot be ordered as it is (CU §10.6, Appendix C).
export type LineProblem =
  | 'item_not_found'
  | 'item_unavailable'
  | 'option_not_found'
  | 'option_unavailable'
  | 'options_invalid'
  | 'price_not_in_base_currency'
  | 'price_changed';

export interface PricedLine {
  itemId: string;
  name: string | null;
  quantity: number;
  note: string | null;
  options: { id: string; name: string; priceDelta: bigint }[];
  // The current unit price with the options, and times the quantity; null
  // for a line that cannot be priced.
  unitPrice: bigint | null;
  lineTotal: bigint | null;
  problems: LineProblem[];
}

// Each line at the menu's current prices and availability (CU §9.3–9.4,
// §10.1). Hidden rows are not found. A line whose price changed is priced and
// flagged; a line that cannot be ordered has no price. Without a base
// currency (the city's setup is incomplete) no line is refused for its
// currency; the quote shows rates_unavailable instead.
export function priceLines(
  menu: Menu,
  lines: CartLine[],
  baseCurrency: string | null,
): PricedLine[] {
  const items = new Map<string, MenuItem>();
  for (const category of menu.categories) {
    if (category.hidden) continue;
    for (const entry of category.items) if (!entry.hidden) items.set(entry.id, entry);
  }
  return lines.map((line) => priceLine(items.get(line.itemId), line, baseCurrency));
}

function priceLine(item: MenuItem | undefined, line: CartLine, base: string | null): PricedLine {
  const unpriced = (problems: LineProblem[], name: string | null = null): PricedLine => ({
    itemId: line.itemId,
    name,
    quantity: line.quantity,
    note: line.note,
    options: [],
    unitPrice: null,
    lineTotal: null,
    problems,
  });
  if (item === undefined) return unpriced(['item_not_found']);
  if (!item.available) return unpriced(['item_unavailable'], item.name);
  const chosen = line.optionIds.map((id) => {
    for (const group of item.optionGroups) {
      const option = group.options.find((entry) => entry.id === id);
      if (option) return { group, option };
    }
    return null;
  });
  if (chosen.some((entry) => entry === null)) return unpriced(['option_not_found'], item.name);
  const picks = chosen.filter((entry) => entry !== null);
  const problems: LineProblem[] = [];
  const repeated = new Set(line.optionIds).size !== line.optionIds.length;
  const outOfRule = item.optionGroups.some((group) => {
    const count = picks.filter((pick) => pick.group.id === group.id).length;
    return count < group.minChoices || count > group.maxChoices;
  });
  if (repeated || outOfRule) problems.push('options_invalid');
  if (picks.some((pick) => !pick.option.available)) problems.push('option_unavailable');
  const currencies = [item.price.currency, ...picks.map((pick) => pick.option.priceDelta.currency)];
  if (base !== null && currencies.some((currency) => currency !== base)) {
    problems.push('price_not_in_base_currency');
  }
  if (problems.length > 0) return unpriced(problems, item.name);

  const unitPrice = picks.reduce(
    (sum, pick) => sum + pick.option.priceDelta.amount,
    item.price.amount,
  );
  return {
    itemId: item.id,
    name: item.name,
    quantity: line.quantity,
    note: line.note,
    options: picks.map(({ option }) => ({
      id: option.id,
      name: option.name,
      priceDelta: option.priceDelta.amount,
    })),
    unitPrice,
    lineTotal: unitPrice * BigInt(line.quantity),
    problems: line.knownUnitPrice !== unitPrice ? ['price_changed'] : [],
  };
}

export interface QuoteMoney {
  itemsValue: bigint;
  deliveryFee: bigint;
  discount: bigint;
  // To the base currency's rounding unit (AP §8.4, §8.6); 0 without a rule.
  rounding: bigint;
  total: bigint;
}

// AP §8.4: customer_total = items_value + delivery_fee − discount_total +
// rounding_adjustment, never below 0. A discount is capped by its code
// (Phase 2), so the total is capped here only as the last guard.
export function quoteMoney({
  itemsValue,
  deliveryFee,
  discount,
  rounding,
}: {
  itemsValue: bigint;
  deliveryFee: bigint;
  discount: bigint;
  rounding: { unitMinor: bigint; mode: RoundingMode } | null;
}): QuoteMoney {
  const unrounded = itemsValue + deliveryFee - discount;
  const floor = unrounded < 0n ? 0n : unrounded;
  const total =
    rounding === null ? floor : roundToUnit(floor, 1n, rounding.unitMinor, rounding.mode);
  const kept = total < 0n ? 0n : total;
  return { itemsValue, deliveryFee, discount, rounding: kept - floor, total: kept };
}

// CU §10.2: both compared with the items value before discounts; neither is
// checked again after the order is placed (AP §9.3.3).
export function thresholds({
  itemsValue,
  minimumOrder,
  freeDeliveryFrom,
}: {
  itemsValue: bigint;
  minimumOrder: bigint;
  freeDeliveryFrom: bigint | null;
}) {
  const status = (threshold: bigint) => ({
    reached: itemsValue >= threshold,
    missing: itemsValue >= threshold ? 0n : threshold - itemsValue,
  });
  return {
    minimumOrder: status(minimumOrder),
    freeDelivery: freeDeliveryFrom === null ? null : status(freeDeliveryFrom),
  };
}

// CU §10.6: the quote version changes only when a money line, an
// equivalent, the exchange rates or a blocking problem changes; a new
// estimate alone does not change it. The order command carries it, and
// placing the order compares it (slice 1.8).
export function quoteVersion(parts: {
  lines: { itemId: string; optionIds: string[]; quantity: number; unitPrice: bigint | null }[];
  money: QuoteMoney;
  equivalents: { currency: string; amount: bigint }[];
  rateVersions: { currency: string; rateVersionId: string | null }[];
  problems: { code: string; line: number | null }[];
}): string {
  const canonical = JSON.stringify(parts, (_key, value: unknown) =>
    typeof value === 'bigint' ? value.toString() : value,
  );
  return createHash('sha256').update(canonical).digest('hex').slice(0, 32);
}

// AP §9.14: whether an app version such as 1.10.0 is below the minimum, part
// by part.
export function versionBelow(version: string, minimum: string): boolean {
  const parts = version.split('.').map(Number);
  const least = minimum.split('.').map(Number);
  for (let index = 0; index < least.length; index += 1) {
    const difference = (parts[index] ?? 0) - least[index]!;
    if (difference !== 0) return difference < 0;
  }
  return false;
}
