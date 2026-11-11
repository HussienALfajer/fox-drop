import { and, asc, eq, gt, isNull } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { CaptainsService } from '../captains/index.js';
import type { JournalRate, LedgerActor, LedgerService } from '../ledger/index.js';
import type { SettingsService } from '../settings/index.js';
import { captainPay } from './captain-pay.js';
import { frozenAtPickup } from './order-edits.js';
import { orderKey } from './order-views.js';
import type { OutcomeFacts, OutcomeJournal } from './outcome.js';
import { orderOutcomeRows, orders } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;
type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// What the outcome's entries depend on, read before the transaction: the
// order, what the pickup paid and its edits since booked (frozenAtPickup),
// the captain's pay (slow reads) and the dues rule; and the version they
// were read at, which the transaction compares under the lock. Shared by
// «تحديد النتيجة» and the collection of its amount (slice 2.11b).
export async function readOutcomeFacts(
  db: Executor,
  captains: Pick<CaptainsService, 'captain' | 'payParts'>,
  settings: Pick<SettingsService, 'get'>,
  order: { id: string; placedAt: Date; cityId: string; restaurantId: string },
  now: Date,
): Promise<{ facts: OutcomeFacts; version: number }> {
  const [row] = await db
    .select({
      version: orders.version,
      captainId: orders.captainId,
      customerAccountId: orders.customerAccountId,
      currency: orders.currency,
      testOrder: orders.testOrder,
      itemsValue: orders.itemsValue,
      deliveryFee: orders.deliveryFee,
      discount: orders.discount,
      total: orders.total,
    })
    .from(orders)
    .where(orderKey(order.id, order.placedAt));
  if (!row) throw new Error(`order ${order.id} not found`);
  if (row.captainId === null) throw new Error(`order ${order.id} has no captain`);
  const frozen = await frozenAtPickup(db, { ...order, ...row });
  const [{ pay, commissionBp }, rule, fixed] = await Promise.all([
    captainPay(db, captains, order, row.captainId, now),
    settings.get('customer.fake_order_dues_rule', { cityId: order.cityId }),
    settings.get('customer.fake_order_dues_fixed', { cityId: order.cityId }),
  ]);
  return {
    version: row.version,
    facts: {
      restaurantId: order.restaurantId,
      captainId: row.captainId,
      customerAccountId: row.customerAccountId,
      currency: row.currency,
      testOrder: row.testOrder,
      commissionBp,
      itemsValue: row.itemsValue,
      deliveryFee: row.deliveryFee,
      discount: row.discount,
      total: row.total,
      pickup: {
        itemsValue: frozen.itemsValue,
        restaurantCharge: frozen.restaurantCharge,
        restaurantCommissionCut: frozen.restaurantCommissionCut,
        captainCharge: frozen.captainCharge,
        platformCharge: frozen.platformCharge,
        feeCuts: frozen.feeCuts,
      },
      pay: pay && { orderPay: pay.orderPay, waiting: pay.waiting },
      duesRule: {
        kind: rule,
        // A fixed amount in another currency than the order's is unset.
        fixed:
          fixed !== null && (fixed.currency ?? row.currency) === row.currency
            ? BigInt(fixed.amountMinor)
            : null,
      },
    },
  };
}

// CA §9.10 (K9, slice 2.11b): the outcome operations set with an amount to
// collect that nobody has recorded yet, «بانتظار تسجيل التحصيل»; null
// otherwise. While it waits, the order takes no delivery, edit or other
// outcome.
export async function pendingOutcome(executor: Executor, order: { id: string; placedAt: Date }) {
  const [row] = await executor
    .select()
    .from(orderOutcomeRows)
    .where(
      and(
        eq(orderOutcomeRows.orderId, order.id),
        eq(orderOutcomeRows.orderPlacedAt, order.placedAt),
        gt(orderOutcomeRows.amountToCollect, 0n),
        isNull(orderOutcomeRows.collectedAt),
        isNull(orderOutcomeRows.replacedAt),
      ),
    );
  return row ?? null;
}

// «تغيير النتيجة» (slice 2.11c): the order's outcome in force, and the moment
// its first outcome was set (order.outcome_change_days count from it); null
// without an outcome.
export async function currentOutcome(executor: Executor, order: { id: string; placedAt: Date }) {
  const rows = await executor
    .select()
    .from(orderOutcomeRows)
    .where(
      and(
        eq(orderOutcomeRows.orderId, order.id),
        eq(orderOutcomeRows.orderPlacedAt, order.placedAt),
      ),
    )
    .orderBy(asc(orderOutcomeRows.setAt));
  const row = rows.find((each) => each.replacedAt === null);
  return row ? { row, firstSetAt: rows[0]!.setAt } : null;
}

// The journals of an order's change, posted in its transaction, all with
// the order as their source (E3); their ids, which an outcome keeps so a
// change can reverse them (slice 2.11c).
export async function postOrderJournals(
  tx: Tx,
  ledger: LedgerService,
  order: { id: string; cityId: string },
  actor: LedgerActor,
  journals: (Pick<OutcomeJournal, 'type' | 'reason' | 'entries'> & {
    rates?: JournalRate[] | undefined;
  })[],
): Promise<string[]> {
  const ids: string[] = [];
  for (const journal of journals) {
    const entries = [];
    for (const entry of journal.entries) {
      const accountId = await ledger.openAccount(
        {
          cityId: order.cityId,
          purpose: entry.account,
          ownerId: entry.party.id,
          currency: entry.currency,
        },
        tx,
      );
      entries.push({ accountId, currency: entry.currency, amount: entry.amount });
    }
    const id = await ledger.post(
      {
        cityId: order.cityId,
        type: journal.type,
        source: { kind: 'order', id: order.id },
        actor,
        reason: journal.reason,
        entries,
        rates: journal.rates,
      },
      tx,
    );
    ids.push(id);
  }
  return ids;
}
