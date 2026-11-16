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
