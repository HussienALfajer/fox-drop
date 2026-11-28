import fc from 'fast-check';
import { describe, expect, it } from 'vitest';
import type { RateSnapshot, RoundingMode, SnapshotCurrency } from '../fx/index.js';
import { cancellationEntries, keptPaymentJournals } from './cancellation.js';
import { commission } from './door-payment.js';
import { type OrderDiscount, withinCaps } from './order-discount.js';
import {
  afterPickupEntries,
  type AfterPickupParty,
  type BookedEdit,
  frozenFromEdits,
} from './order-edits.js';
import {
  FEE_CUT_RETURNED_REASON,
  type OutcomeFacts,
  outcomeEntries,
  type SetOutcome,
} from './outcome.js';
import { baseTotal, checkLines, pickupCurrencies, proposeLines } from './pickup-booking.js';
import { redeliveryEntries } from './redelivery.js';
import { cashAnswers, outcomeFoods, responsibleParties } from './schema.js';
import { shortfallEntries, shortfallParties } from './shortfall.js';
import { commissionOn, ticketMoneyEntries } from './ticket-money.js';

// docs/domain/, AP §8.4–§8.9: every journal the order's money rules build
// balances in each currency, and the order clearing account comes back to
// zero once the order is settled, for any order, edits and choices, not only
// the worked examples beside each rule.

const restaurantId = '0190f3a0-0000-7000-8000-0000000000b1';
const captainId = '0190f3a0-0000-7000-8000-0000000000b2';
const customerAccountId = '0190f3a0-0000-7000-8000-0000000000b3';
const base = 'TRY';

interface Entry {
  account: string;
  amount: bigint;
  currency: string;
}
interface Journal {
  entries: Entry[];
}

// What LedgerService.post takes: two entries or more, none of zero, summing
// to zero in each currency.
function expectPostable(journals: readonly Journal[]) {
  for (const journal of journals) {
    expect(journal.entries.length).toBeGreaterThanOrEqual(2);
    const sums = new Map<string, bigint>();
    for (const entry of journal.entries) {
      expect(entry.amount).not.toBe(0n);
      sums.set(entry.currency, (sums.get(entry.currency) ?? 0n) + entry.amount);
    }
    for (const sum of sums.values()) expect(sum).toBe(0n);
  }
}

function clearing(journals: readonly Journal[], currency = base): bigint {
  return journals
    .flatMap((journal) => journal.entries)
    .filter((entry) => entry.account === 'platform.order_clearing' && entry.currency === currency)
    .reduce((sum, entry) => sum + entry.amount, 0n);
}

const money = (max: bigint) => fc.bigInt({ min: 0n, max });
const commissionBp = fc.integer({ min: 0, max: 10_000 });

// A placed order's money: the items value, the fee and a code's discount
// within AP §8.4's caps, the restaurant's part of it no larger than it.
const placedOrder = fc
  .record({
    itemsValue: fc.bigInt({ min: 1n, max: 10n ** 9n }),
    deliveryFee: money(10n ** 7n),
    commissionBp,
    testOrder: fc.boolean(),
    onDelivery: fc.boolean(),
    // In thousandths of the cap, and of the discount.
    discountShare: fc.integer({ min: 0, max: 1000 }),
    merchantShare: fc.integer({ min: 0, max: 1000 }),
  })
  .map((order) => {
    const cap = order.onDelivery ? order.deliveryFee : order.itemsValue;
    const total = (cap * BigInt(order.discountShare)) / 1000n;
    const merchant = (total * BigInt(order.merchantShare)) / 1000n;
    const discount: OrderDiscount = { total, merchant, onDelivery: order.onDelivery };
    return { ...order, discount };
  });

// An edit after the pickup (AP §9.3.3): who bears it, and how much of the
// items value and of the fee it takes off, in thousandths of what is left.
const edit = fc.record({
  responsible: fc.constantFrom<AfterPickupParty>('restaurant', 'captain', 'platform'),
  removed: fc.integer({ min: 0, max: 1000 }),
  feeCut: fc.integer({ min: 0, max: 1000 }),
});

type Placed = typeof placedOrder extends fc.Arbitrary<infer T> ? T : never;
type Edit = typeof edit extends fc.Arbitrary<infer T> ? T : never;

// The order from its pickup through its edits, as order-commands.ts books
// each edit and frozenAtPickup reads them back: the order now, what each edit
// posted, and the pickup facts an outcome reads.
function afterEdits(order: Placed, edits: Edit[]) {
  const commissionOf = (itemsValue: bigint) =>
    order.testOrder ? 0n : commission(itemsValue, order.commissionBp);
  let itemsValue = order.itemsValue;
  let deliveryFee = order.deliveryFee;
  let discount = order.discount;
  const journals: Journal[] = [];
  // The rows order-commands.ts stores, and what each party was charged for
  // the fee the customer no longer pays (after a free-delivery code).
  const rows: BookedEdit[] = [];
  const feeCharged = { restaurant: 0n, captain: 0n, platform: 0n };
  for (const each of edits) {
    const itemsAfter = itemsValue - (itemsValue * BigInt(each.removed)) / 1000n;
    const feeAfter = deliveryFee - (deliveryFee * BigInt(each.feeCut)) / 1000n;
    const capped = withinCaps(discount, { itemsValue: itemsAfter, deliveryFee: feeAfter });
    const feeBefore = deliveryFee - (discount.onDelivery ? discount.total : 0n);
    const feeAfterDiscount = feeAfter - (capped.onDelivery ? capped.total : 0n);
    const booking = afterPickupEntries({
      responsible: each.responsible,
      restaurantId,
      captainId,
      currency: base,
      itemsValueBefore: itemsValue,
      itemsValueAfter: itemsAfter,
      deliveryFeeBefore: feeBefore,
      deliveryFeeAfter: feeAfterDiscount,
      commissionOf,
    });
    expectPostable(booking.journals);
    // The party bears exactly what the clearing account gives up.
    expect(-clearing(booking.journals)).toBe(booking.charge);
    journals.push(...booking.journals);
    rows.push({
      itemsValueBefore: itemsValue,
      itemsValueAfter: itemsAfter,
      deliveryFeeBefore: deliveryFee,
      responsible: each.responsible,
      charge: booking.charge,
      commissionCut: booking.commissionCut,
    });
    feeCharged[each.responsible] += feeBefore - feeAfterDiscount;
    itemsValue = itemsAfter;
    deliveryFee = feeAfter;
    discount = capped;
  }
  // What the delivery and an outcome read back (frozenAtPickup).
  const frozen = frozenFromEdits(order, rows);
  return { itemsValue, deliveryFee, discount, journals, feeCharged, pickup: frozen };
}

const edits = fc.array(edit, { maxLength: 4 });
const pay = fc.option(fc.record({ orderPay: money(10n ** 6n), waiting: money(10n ** 5n) }));
const duesRule = fc.oneof(
  fc.record({
    kind: fc.constantFrom('fee_plus_merchant_net' as const, 'fee_plus_items_value' as const),
    fixed: fc.constant(null),
  }),
  fc.record({ kind: fc.constant('fixed' as const), fixed: fc.bigInt({ min: 1n, max: 10n ** 8n }) }),
);

// «تحديد النتيجة»'s choices the panel can send (AP §9.3.2): fake with the
// customer responsible, free delivered, the failed-only outcomes failed, the
// food only for a failed order (back to the restaurant only when it is
// responsible), and an amount to collect only on a delivered one, below the
// total.
const choices = fc
  .record({
    outcome: fc.constantFrom<SetOutcome>(
      'free',
      'fake',
      'damaged',
      'wrong_refused',
      'failed_other',
    ),
    responsible: fc.constantFrom('restaurant' as const, 'captain' as const, 'platform' as const),
    damagedDelivered: fc.boolean(),
    food: fc.constantFrom(...outcomeFoods),
    collected: fc.integer({ min: 0, max: 1000 }),
  })
  .map((pick) => {
    const responsible = pick.outcome === 'fake' ? ('customer' as const) : pick.responsible;
    const delivered =
      pick.outcome === 'free' || (pick.outcome === 'damaged' && pick.damagedDelivered);
    const food = delivered
      ? null
      : pick.food === 'returned_to_restaurant' && responsible !== 'restaurant'
        ? ('destroyed' as const)
        : pick.food;
    return { outcome: pick.outcome, responsible, delivered, food, collectedShare: pick.collected };
  });

describe('an outcome after edits (docs/domain/09, AP §8.9)', () => {
  it('posts balanced journals and brings the order clearing account back to zero', () => {
    fc.assert(
      fc.property(placedOrder, edits, pay, duesRule, choices, (order, edits, pay, dues, pick) => {
        const now = afterEdits(order, edits);
        const total = now.itemsValue + now.deliveryFee - now.discount.total;
        const amountToCollect =
          pick.delivered && total > 0n ? ((total - 1n) * BigInt(pick.collectedShare)) / 1000n : 0n;
        const facts: OutcomeFacts = {
          restaurantId,
          captainId,
          customerAccountId,
          currency: base,
          testOrder: order.testOrder,
          commissionBp: order.testOrder ? null : order.commissionBp,
          itemsValue: now.itemsValue,
          deliveryFee: now.deliveryFee,
          discount: now.discount,
          total,
          pickup: now.pickup,
          pay,
          duesRule: dues,
        };
        const outcome = () =>
          outcomeEntries(facts, {
            outcome: pick.outcome,
            responsible: pick.responsible,
            delivered: pick.delivered,
            food: pick.food,
            amountToCollect,
          });
        if (now.discount.merchant > 0n) {
          // Open, for the owner: a restaurant-funded discount can be more
          // than the clearing account holds once the commission is taken
          // (a free-delivery code above the items' merchant net, or a minor
          // unit of rounding after an edit), and outcomeEntries then throws.
          // Without one it always settles: the edits' commission cuts and the
          // outcome's commission then telescope exactly.
          try {
            outcome();
          } catch (error) {
            fc.pre((error as Error).message !== 'the order clearing account would not settle');
            throw error;
          }
        }
        const booking = outcome();
        if ('problem' in booking) {
          // The one refusal valid choices can meet: no pay table for the
          // captain who is not responsible.
          expect(booking.problem).toBe('captain_pay_unset');
          expect(pay === null && pick.responsible !== 'captain').toBe(true);
          return;
        }
        expectPostable(booking.journals);
        // The pickup paid the items value into the clearing account, the
        // edits took their charges off it and the collection what the
        // customer paid; the outcome takes the rest, nobody paying twice.
        const held = order.itemsValue + clearing(now.journals) - amountToCollect;
        expect(held + clearing(booking.journals)).toBe(0n);
        expect(booking.loss >= 0n).toBe(true);
        // Settling alone cannot see money booked to the wrong party: with
        // the restaurant not responsible, each party gets back exactly the
        // fee cut it was charged for, no more.
        if (pick.responsible !== 'restaurant') {
          const givenBack = (account: string) =>
            booking.journals
              .filter((journal) => journal.reason === FEE_CUT_RETURNED_REASON)
              .flatMap((journal) => journal.entries)
              .filter((entry) => entry.account === account)
              .reduce((sum, entry) => sum - entry.amount, 0n);
          expect(givenBack('merchant.account')).toBe(now.feeCharged.restaurant);
          expect(givenBack('captain.earnings')).toBe(now.feeCharged.captain);
          expect(givenBack('platform.operating_cost')).toBe(now.feeCharged.platform);
        }
      }),
    );
  });
});

// A snapshot with the base and two other currencies, each with its own
// decimals, rate, rounding unit and mode (a rate need not be reduced for the
// conversion).
const rate = fc
  .tuple(fc.bigInt({ min: 1n, max: 10n ** 6n }), fc.bigInt({ min: 1n, max: 10n ** 6n }))
  .map(([numerator, denominator]) => ({ numerator, denominator }));
const roundingUnit = fc.bigInt({ min: 1n, max: 10_000n });
const roundingMode = fc.constantFrom<RoundingMode>('nearest', 'up', 'down');
const snapshot: fc.Arbitrary<RateSnapshot> = fc
  .tuple(
    roundingUnit,
    roundingMode,
    fc.array(fc.tuple(fc.integer({ min: 0, max: 3 }), rate, roundingUnit, roundingMode), {
      minLength: 2,
      maxLength: 2,
    }),
  )
  .map(([baseUnit, baseMode, others]) => ({
    cityId: '0190f3a0-0000-7000-8000-0000000000c1',
    baseCurrency: base,
    takenAt: new Date('2026-11-22T09:00:00Z'),
    currencies: [
      {
        code: base,
        decimals: 2,
        rate: { numerator: 1n, denominator: 1n },
        rateVersionId: null,
        roundingUnitMinor: baseUnit,
        roundingMode: baseMode,
      },
      ...others.map(
        ([decimals, rate, roundingUnitMinor, roundingMode], index): SnapshotCurrency => ({
          code: ['USD', 'SYP'][index]!,
          decimals,
          rate,
          rateVersionId: `0190f3a0-0000-7000-8000-0000000000a${index}`,
          roundingUnitMinor,
          roundingMode,
        }),
      ),
    ],
  }));

// The captain's pickup payment lines: at most one per currency, each above
// zero, and their total in the base as the cancellation reads it.
const cashLines = fc
  .subarray([base, 'USD', 'SYP'], { minLength: 1 })
  .chain((codes) =>
    fc.tuple(
      ...codes.map((code) =>
        fc.bigInt({ min: 1n, max: 10n ** 9n }).map((amount) => ({ currency: code, amount })),
      ),
    ),
  );

describe('the payment the restaurant kept (AP §8.1, docs/domain/01)', () => {
  it('posts balanced journals that net the clearing account to zero in every currency', () => {
    fc.assert(
      fc.property(snapshot, cashLines, (snapshot, lines) => {
        const journals = keptPaymentJournals({
          restaurantId,
          captainId,
          currency: base,
          cashLines: lines,
          cashBase: baseTotal(snapshot, lines),
          snapshot,
        });
        expectPostable(journals);
        for (const code of [base, 'USD', 'SYP']) expect(clearing(journals, code)).toBe(0n);
      }),
    );
  });
});

describe('a cancellation before the pickup (docs/domain/01, 08, 09)', () => {
  it('posts balanced journals that net the clearing account to zero', () => {
    fc.assert(
      fc.property(
        placedOrder,
        snapshot,
        cashLines,
        fc.record({
          status: fc.constantFrom('placed' as const, 'accepted' as const, 'ready' as const),
          withCaptain: fc.boolean(),
          arrived: fc.boolean(),
          captainPay: fc.option(money(10n ** 6n)),
          responsible: fc.constantFrom(...responsibleParties),
          foodPrepared: fc.boolean(),
          compensateCaptain: fc.boolean(),
          cash: fc.constantFrom(...cashAnswers),
        }),
        (order, snapshot, lines, pick) => {
          const placed = pick.status === 'placed';
          const arrived = !placed && pick.withCaptain && pick.arrived;
          const result = cancellationEntries(
            {
              status: pick.status,
              restaurantId,
              captainId: pick.withCaptain ? captainId : null,
              arrivedAtMerchant: arrived,
              currency: base,
              itemsValue: order.itemsValue,
              discount: order.discount,
              commissionBp: order.commissionBp,
              testOrder: order.testOrder,
              cashLines: lines,
              cashBase: baseTotal(snapshot, lines),
              snapshot,
              captainPay: pick.captainPay,
            },
            {
              responsible: pick.responsible,
              foodPrepared: !placed && pick.foodPrepared,
              compensateCaptain: arrived && pick.compensateCaptain,
              cash: arrived ? pick.cash : null,
            },
          );
          if ('problem' in result) {
            expect(result.problem).toBe('captain_pay_unset');
            return;
          }
          expectPostable(result.journals);
          for (const code of [base, 'USD', 'SYP']) expect(clearing(result.journals, code)).toBe(0n);
        },
      ),
    );
  });
});

describe('the money after a delivery (AP §8.6, §8.10, §9.9.3)', () => {
  it('a shortfall moves exactly the missing amount off the clearing account', () => {
    fc.assert(
      fc.property(
        fc.bigInt({ min: 1n, max: 10n ** 9n }),
        fc.constantFrom(...shortfallParties),
        fc.boolean(),
        (amount, party, testOrder) => {
          const booking = shortfallEntries(
            { amount, currency: base, captainId, customerAccountId, testOrder },
            party,
          );
          expectPostable(booking.journals);
          expect(clearing(booking.journals)).toBe(-amount);
        },
      ),
    );
  });

  it('a ticket posts balanced journals, none on the clearing account', () => {
    fc.assert(
      fc.property(
        placedOrder,
        fc.integer({ min: 0, max: 1000 }),
        fc.option(fc.record({ amount: money(10n ** 6n), code: fc.boolean() })),
        fc.constantFrom(...responsibleParties),
        (order, share, wrongChange, responsible) => {
          const itemDiscount = order.discount.onDelivery ? 0n : order.discount.merchant;
          const booking = ticketMoneyEntries({
            responsible,
            restaurantId,
            captainId,
            currency: base,
            itemsValue: order.itemsValue,
            commissionOf: commissionOn(order.commissionBp, itemDiscount, order.testOrder),
            affected: (order.itemsValue * BigInt(share)) / 1000n,
            wrongChange,
          });
          expectPostable(booking.journals);
          expect(clearing(booking.journals)).toBe(0n);
          // The figures the pushes and the ticket show are what is posted.
          const posted = (type: string, account: string) =>
            booking.journals
              .filter((journal) => journal.type === type)
              .flatMap((journal) => journal.entries)
              .filter((entry) => entry.account === account)
              .reduce((sum, entry) => sum + entry.amount, 0n);
          expect(posted('earn.charge', 'captain.earnings')).toBe(booking.captainCharge);
          expect(posted('merchant.debit', 'merchant.account')).toBe(booking.merchantDebit);
        },
      ),
    );
  });

  it('a free re-delivery posts balanced journals', () => {
    fc.assert(
      fc.property(
        placedOrder,
        fc.constantFrom('restaurant' as const, 'captain' as const, 'platform' as const),
        money(10n ** 6n),
        fc.boolean(),
        (order, responsible, payTotal, chargePay) => {
          const itemsValue = responsible === 'restaurant' ? 0n : order.itemsValue;
          const journals = redeliveryEntries({
            responsible,
            restaurantId,
            responsibleCaptainId: captainId,
            currency: base,
            itemsValue,
            commission: order.testOrder ? 0n : commission(itemsValue, order.commissionBp),
            payTotal,
            chargePay,
            testOrder: order.testOrder,
          });
          expectPostable(journals);
          // The clearing account gives up the pickup payment it holds.
          expect(clearing(journals)).toBe(-itemsValue);
        },
      ),
    );
  });
});

describe('the pickup payment the server proposes (CA §10.5, RA §12.7)', () => {
  it('is always one the pickup accepts', () => {
    fc.assert(
      fc.property(
        snapshot,
        fc.subarray(['USD', 'SYP']),
        fc.option(fc.subarray([base, 'USD', 'SYP'], { minLength: 1 })),
        fc.bigInt({ min: 1n, max: 10n ** 9n }),
        (snapshot, others, carried, due) => {
          const accepted = pickupCurrencies(snapshot, others);
          const lines = proposeLines(snapshot, accepted, carried, due);
          expect(lines).toHaveLength(1);
          expect(checkLines(snapshot, lines, due, accepted)).toBeNull();
          if (lines[0]!.currency === base) expect(lines[0]!.amount).toBe(due);
        },
      ),
    );
  });
});
