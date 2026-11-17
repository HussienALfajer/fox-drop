import type { AfterPickupEntry, AfterPickupJournal } from './order-edits.js';

// AP §9.9.3 «إعادة توصيل مجانية» (slice 2.23d): who bears a free
// re-delivery. Never the customer (a resolution refuses it).
export const redeliveryParties = ['restaurant', 'captain', 'platform'] as const;
export type RedeliveryParty = (typeof redeliveryParties)[number];

// The reasons the re-delivery's own journals carry: the items' cost and its
// captain's pay charged to the responsible party (ours, to confirm with the
// owner).
export const REDELIVERY_REASON = 'إعادة توصيل مجانية';
export const REDELIVERY_PAY_REASON = 'أجر كابتن إعادة التوصيل';

// AP §9.9.3: with the restaurant responsible it replaces the items for free,
// so their lines carry no price and the pickup payment and the commission
// are 0; otherwise the captain pays the restaurant the items as usual.
export function redeliveryLinePrice(responsible: RedeliveryParty, unitPrice: bigint): bigint {
  return responsible === 'restaurant' ? 0n : unitPrice;
}

// AP §9.9.3, docs/domain/10, §8.9: the journals a free re-delivery adds at its
// normal delivery, against the order clearing account and
// platform.compensation_cost (its captain's pay is booked there by the
// delivery). The customer pays 0, so the clearing account still holds the
// pickup payment: it goes to the remedy's cost, where the commission's
// revenue leaves the platform the merchant net, which the responsible
// captain is charged (`earn.charge`, once, on this order). With the
// restaurant responsible the pickup and the commission are 0 and nothing
// more is posted. When operations charge the captain's pay to the
// responsible restaurant or captain, `merchant.debit` or `earn.charge` of
// it recovers it. A test order's cost is the test cost, charged to nobody.
export function redeliveryEntries(facts: {
  responsible: RedeliveryParty;
  restaurantId: string;
  // The captain who delivered the original order.
  responsibleCaptainId: string | null;
  currency: string;
  // At the pickup.
  itemsValue: bigint;
  commission: bigint;
  payTotal: bigint;
  chargePay: boolean;
  testOrder: boolean;
}): AfterPickupJournal[] {
  const { currency } = facts;
  const platform = { kind: 'platform' as const, id: null };
  const costAccount = facts.testOrder ? 'platform.test_cost' : 'platform.compensation_cost';
  const recovered = (amount: bigint): AfterPickupEntry => ({
    account: 'platform.compensation_cost',
    party: platform,
    amount: -amount,
    currency,
  });
  const captain = () => {
    if (facts.responsibleCaptainId === null) throw new Error('the original order had a captain');
    return { kind: 'captain' as const, id: facts.responsibleCaptainId };
  };
  const journals: AfterPickupJournal[] = [];
  if (facts.responsible !== 'restaurant' && facts.itemsValue > 0n) {
    journals.push({
      type: costAccount,
      reason: REDELIVERY_REASON,
      entries: [
        {
          account: 'platform.order_clearing',
          party: platform,
          amount: -facts.itemsValue,
          currency,
        },
        { account: costAccount, party: platform, amount: facts.itemsValue, currency },
      ],
    });
  }
  if (facts.testOrder) return journals;
  const net = facts.itemsValue - facts.commission;
  if (facts.responsible === 'captain' && net > 0n) {
    journals.push({
      type: 'earn.charge',
      reason: REDELIVERY_REASON,
      entries: [
        { account: 'captain.earnings', party: captain(), amount: net, currency },
        recovered(net),
      ],
    });
  }
  if (facts.chargePay && facts.payTotal > 0n) {
    if (facts.responsible === 'restaurant') {
      journals.push({
        type: 'merchant.debit',
        reason: REDELIVERY_PAY_REASON,
        entries: [
          {
            account: 'merchant.account',
            party: { kind: 'merchant', id: facts.restaurantId },
            amount: facts.payTotal,
            currency,
          },
          recovered(facts.payTotal),
        ],
      });
    } else if (facts.responsible === 'captain') {
      journals.push({
        type: 'earn.charge',
        reason: REDELIVERY_PAY_REASON,
        entries: [
          { account: 'captain.earnings', party: captain(), amount: facts.payTotal, currency },
          recovered(facts.payTotal),
        ],
      });
    }
  }
  return journals;
}
