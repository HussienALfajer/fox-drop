import type { CodeTerms } from '../marketing/index.js';

// AP §8.4 (slice 2.21b): an order's discount as it books it: the total, the
// restaurant-funded part (merchant_funded_discount) and whether it is on the
// fee (free delivery) or on the items.
export interface OrderDiscount {
  total: bigint;
  merchant: bigint;
  onDelivery: boolean;
}

// The code's terms the order kept (`promo_terms`, bigints as strings).
export function storedTerms(stored: unknown): CodeTerms | null {
  if (stored === null || stored === undefined) return null;
  const terms = stored as {
    kind: CodeTerms['kind'];
    percentBp: number | null;
    amount: string | null;
    maxDiscount: string | null;
    merchantShareBp: number;
  };
  return {
    kind: terms.kind,
    percentBp: terms.percentBp,
    amount: terms.amount === null ? null : BigInt(terms.amount),
    maxDiscount: terms.maxDiscount === null ? null : BigInt(terms.maxDiscount),
    merchantShareBp: terms.merchantShareBp,
  };
}

export function orderDiscount(order: {
  discount: bigint;
  discountMerchant: bigint;
  promoTerms: unknown;
}): OrderDiscount {
  return {
    total: order.discount,
    merchant: order.discountMerchant,
    onDelivery: storedTerms(order.promoTerms)?.kind === 'free_delivery',
  };
}

// docs/domain/04: the commission is on the items value after the
// restaurant-funded item discount; a restaurant-funded delivery discount
// leaves it alone.
export function merchantItemDiscount(discount: OrderDiscount): bigint {
  return discount.onDelivery ? 0n : discount.merchant;
}

// AP §8.4's caps on a discount kept after the pickup (slice 2.21b): never
// above the items value, or the fee for free delivery; a capped discount
// keeps the restaurant's part in proportion, half up.
export function withinCaps(
  discount: OrderDiscount,
  money: { itemsValue: bigint; deliveryFee: bigint },
): OrderDiscount {
  const cap = discount.onDelivery ? money.deliveryFee : money.itemsValue;
  if (discount.total <= cap) return discount;
  const total = cap < 0n ? 0n : cap;
  const merchant =
    discount.total === 0n
      ? 0n
      : (discount.merchant * total * 2n + discount.total) / (2n * discount.total);
  return { ...discount, total, merchant };
}
