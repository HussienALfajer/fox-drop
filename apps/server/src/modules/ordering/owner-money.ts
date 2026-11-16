import { commission } from './door-payment.js';

// RA §8.4, §12.1, R10 (slice 2.19d): the owners' money lines of an order,
// «العمولة {النسبة}% — تُسدَّد يوم السبت» and «صافيك من الطلب»; null on a
// test order, which shows «طلب تجريبي — لا عمولة» instead (AP §9.6.3).
// Before the pickup they follow the items value; after it (`frozen`, from
// `frozenAtPickup`) the pickup's items value is the commission's base, and
// only the restaurant's own edits change them (AP §9.3.3, docs/domain/09).
// An outcome with the restaurant responsible (`restaurantDebit`, the
// outcome's whole debit) books no commission and takes the pickup payment
// back, so its net is what is left after that debit (AP §8.9).
// No restaurant-funded discount until codes (Phase 2).
export interface OwnerMoney {
  commissionBp: number;
  commission: bigint;
  merchantNet: bigint;
}

export function ownerMoney(
  order: { itemsValue: bigint; commissionBp: number; testOrder: boolean },
  frozen: { itemsValue: bigint; restaurantCommissionCut: bigint; restaurantCharge: bigint } | null,
  restaurantDebit: bigint | null = null,
): OwnerMoney | null {
  if (order.testOrder) return null;
  if (restaurantDebit !== null && frozen !== null) {
    return {
      commissionBp: order.commissionBp,
      commission: 0n,
      merchantNet:
        frozen.itemsValue -
        frozen.restaurantCharge +
        frozen.restaurantCommissionCut -
        restaurantDebit,
    };
  }
  if (frozen === null) {
    const cut = commission(order.itemsValue, order.commissionBp);
    return {
      commissionBp: order.commissionBp,
      commission: cut,
      merchantNet: order.itemsValue - cut,
    };
  }
  const cut = commission(frozen.itemsValue, order.commissionBp) - frozen.restaurantCommissionCut;
  return {
    commissionBp: order.commissionBp,
    commission: cut,
    merchantNet: frozen.itemsValue - cut - frozen.restaurantCharge,
  };
}
