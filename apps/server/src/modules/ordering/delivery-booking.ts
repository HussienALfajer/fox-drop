import { Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { Jobs } from '../../jobs/jobs.module.js';
import type { PayParts } from '../captains/index.js';
import type { RateSnapshot } from '../fx/index.js';
import {
  type AccountPurpose,
  type JournalType,
  type LedgerActor,
  type LedgerEntry,
  LedgerService,
} from '../ledger/index.js';
import { commission, type DoorPayment } from './door-payment.js';
import { frozenAtPickup } from './order-edits.js';
import { type OrderRow, recordTransition } from './order-events.js';
import { orderKey, snapshotOf } from './order-views.js';
import { postOrderJournals } from './outcome-facts.js';
import { captainNet, type OutcomeJournal, type SetOutcome } from './outcome.js';
import { type PaymentLine, storedLines } from './pickup-booking.js';
import type { ChosenReason } from '../content/index.js';
import { collections, orderOutcomeRows, orders } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// The order as a delivery reads it under its lock (AP §8.4).
export interface DeliveryOrder extends OrderRow {
  currency: string;
  itemsValue: bigint;
  deliveryFee: bigint;
  discount: bigint;
  rounding: bigint;
  total: bigint;
  snapshot: RateSnapshot;
}

export async function lockForDelivery(tx: Tx, order: OrderRow): Promise<DeliveryOrder> {
  const [money] = await tx
    .select({
      currency: orders.currency,
      itemsValue: orders.itemsValue,
      deliveryFee: orders.deliveryFee,
      discount: orders.discount,
      rounding: orders.rounding,
      total: orders.total,
      rateSnapshot: orders.rateSnapshot,
    })
    .from(orders)
    .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
  return { ...order, ...money!, snapshot: snapshotOf(money!.rateSnapshot) };
}

// What the delivery books, worked out before its transaction.
export interface Delivery {
  received: PaymentLine[];
  change: PaymentLine[];
  payment: DoorPayment;
  // K16, checked against Content's shortfall list.
  shortfall: ChosenReason | null;
  pay: PayParts;
  waitingMinutes: number;
  // AP §8.4: the order's commission rate, null on a test restaurant's
  // order, which posts none (AP §9.6.3).
  commissionBp: number | null;
  // The total the payment was checked against; an edit since refuses it.
  amountDue: bigint;
}

// CA §9.10 (K9, slice 2.11b): the payment of an outcome's amount to collect
// and the outcome's journals, worked out before the transaction from the
// facts read at the order's version, which it compares under the lock.
export interface OutcomeCollection {
  received: PaymentLine[];
  change: PaymentLine[];
  payment: DoorPayment;
  shortfall: ChosenReason | null;
  // The pay parts the outcome pays (CA §9.8), null when it pays none.
  pay: PayParts | null;
  waitingMinutes: number;
  outcome: {
    id: string;
    outcome: SetOutcome;
    amountToCollect: bigint;
    journals: OutcomeJournal[];
    loss: bigint;
    merchantDebit: bigint | null;
    captainPay: bigint;
  };
}

export interface DeliveredBy {
  actor: { type: 'captain' | 'admin'; id: string; device?: string };
  // Operations' reason (AP §9.3.2), kept with the collection and the audit.
  reason: string | null;
}

// AP §8.1, §8.4–8.6, CA §9.8: the order delivered with outcome normal, its
// collection, and every journal of its money in the transaction that holds
// the order's lock, so the order clearing account comes back to zero with
// the delivery (or holds the shortfall until operations resolve it).
@Injectable()
export class DeliveryBooking {
  constructor(
    private readonly jobs: Jobs,
    private readonly ledger: LedgerService,
  ) {}

  async complete(
    tx: Tx,
    order: DeliveryOrder,
    delivery: Delivery,
    by: DeliveredBy,
    now: Date,
    away: ChosenReason | null,
  ): Promise<void> {
    if (order.captainId === null) throw new Error(`order ${order.id} has no captain`);
    // AP §8.4: a discount needs platform.discount_cost or
    // merchant.discount_share, which come with codes (Phase 2); until then
    // the clearing account would not settle.
    if (order.discount !== 0n) throw new Error(`order ${order.id} has a discount, not booked yet`);
    const version = order.version + 1;
    await tx
      .update(orders)
      .set({
        status: 'delivered',
        version,
        captainTrack: 'done',
        deliveredAt: now,
        outcome: 'normal',
        ...(away
          ? { awayReason: away.code, awayReasonLabel: away.label, awayNote: away.note }
          : {}),
      })
      .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
    await tx.insert(collections).values({
      orderId: order.id,
      orderPlacedAt: order.placedAt,
      cityId: order.cityId,
      captainId: order.captainId,
      currency: order.currency,
      amountDue: order.total,
      receivedLines: storedLines(delivery.received),
      changeLines: storedLines(delivery.change),
      netReceived: delivery.payment.netBase,
      shortfall: delivery.payment.shortfall,
      shortfallReason: delivery.shortfall?.code ?? null,
      shortfallReasonLabel: delivery.shortfall?.label ?? null,
      shortfallNote: delivery.shortfall?.note ?? null,
      basePay: delivery.pay.base,
      distancePay: delivery.pay.distance,
      topUpPay: delivery.pay.topUp,
      waitingPay: delivery.pay.waiting,
      waitingMinutes: delivery.waitingMinutes,
      recordedAt: now,
      recordedByType: by.actor.type,
      recordedById: by.actor.id,
      recordedByDevice: by.actor.device ?? null,
      reason: by.reason,
    });
    // AP §9.3.3 (slice 2.10b): the commission on the pickup's items value,
    // the part the captain's or the platform's edits after it bore going to
    // the order clearing account, and the pickup's fee as the revenue; read
    // under the order's lock, so an edit committed since counts.
    const frozen = await frozenAtPickup(tx, order);
    await this.post(tx, order, order.captainId, delivery, by.actor, {
      commission:
        delivery.commissionBp === null
          ? null
          : commission(frozen.itemsValue, delivery.commissionBp),
      commissionToClearing: delivery.commissionBp === null ? 0n : frozen.commissionToClearing,
      deliveryFee: frozen.deliveryFee,
    });
    await recordTransition(tx, this.jobs, order, {
      type: 'order.delivered',
      from: order.status,
      to: 'delivered',
      version,
      actor: by.actor,
      reason: by.reason,
      publicReason: null,
      at: now,
      captainTrack: 'done',
    });
  }

  // CA §9.10 (K9, slice 2.11b): the payment of an outcome's amount to
  // collect, recorded by the captain or operations: the order delivered with
  // its outcome (track done), its collection (the amount to collect as the
  // amount due), the custody lines, the door's gap within rounding, the
  // outcome's journals, and the outcome's row with the money it posted, in
  // the transaction that holds the order's lock. A shortfall stays on the
  // order clearing account for operations (AP §8.6), as at a delivery.
  async completeOutcome(
    tx: Tx,
    order: DeliveryOrder,
    collection: OutcomeCollection,
    by: DeliveredBy,
    now: Date,
  ): Promise<void> {
    if (order.captainId === null) throw new Error(`order ${order.id} has no captain`);
    const version = order.version + 1;
    const { outcome } = collection;
    await tx
      .update(orders)
      .set({
        status: 'delivered',
        version,
        captainTrack: 'done',
        deliveredAt: now,
        outcome: outcome.outcome,
      })
      .where(orderKey(order.id, order.placedAt));
    const pay = collection.pay;
    await tx.insert(collections).values({
      orderId: order.id,
      orderPlacedAt: order.placedAt,
      cityId: order.cityId,
      captainId: order.captainId,
      currency: order.currency,
      amountDue: outcome.amountToCollect,
      receivedLines: storedLines(collection.received),
      changeLines: storedLines(collection.change),
      netReceived: collection.payment.netBase,
      shortfall: collection.payment.shortfall,
      shortfallReason: collection.shortfall?.code ?? null,
      shortfallReasonLabel: collection.shortfall?.label ?? null,
      shortfallNote: collection.shortfall?.note ?? null,
      basePay: pay?.base ?? 0n,
      distancePay: pay?.distance ?? 0n,
      topUpPay: pay?.topUp ?? 0n,
      waitingPay: pay?.waiting ?? 0n,
      waitingMinutes: collection.waitingMinutes,
      recordedAt: now,
      recordedByType: by.actor.type,
      recordedById: by.actor.id,
      recordedByDevice: by.actor.device ?? null,
      reason: by.reason,
    });
    const ledgerActor: LedgerActor = { type: by.actor.type, id: by.actor.id };
    const { post, account } = this.poster(tx, order, ledgerActor);
    await this.postCollection(tx, order, order.captainId, collection, ledgerActor);
    // AP §8.6: the door's gap within rounding, so the clearing account
    // counts the amount to collect as collected.
    const base = order.snapshot.baseCurrency;
    const gap = collection.payment.roundingGap;
    await post('platform.fx_rounding', [
      { accountId: await account('platform.order_clearing', base), currency: base, amount: -gap },
      { accountId: await account('platform.fx_rounding', base), currency: base, amount: gap },
    ]);
    const journalIds = await postOrderJournals(
      tx,
      this.ledger,
      order,
      ledgerActor,
      outcome.journals,
    );
    await tx
      .update(orderOutcomeRows)
      .set({
        journalIds,
        captainNet: captainNet(outcome.journals),
        loss: outcome.loss,
        merchantDebit: outcome.merchantDebit,
        captainPay: outcome.captainPay,
        collectedAt: now,
        // The captain recorded it on the payment screen: no outcome card.
        ...(by.actor.type === 'captain' ? { captainSeenAt: now } : {}),
      })
      .where(eq(orderOutcomeRows.id, outcome.id));
    await recordTransition(tx, this.jobs, order, {
      type: 'order.outcome_collected',
      from: order.status,
      to: 'delivered',
      version,
      actor: by.actor,
      reason: by.reason,
      publicReason: outcome.outcome,
      at: now,
      captainTrack: 'done',
    });
  }

  private poster(tx: Tx, order: DeliveryOrder, actor: LedgerActor) {
    const { cityId } = order;
    const source = { kind: 'order' as const, id: order.id };
    const account = (purpose: AccountPurpose, currency: string, ownerId: string | null = null) =>
      this.ledger.openAccount({ cityId, purpose, ownerId, currency }, tx);
    const post = async (type: JournalType, entries: LedgerEntry[]) => {
      const nonZero = entries.filter((entry) => entry.amount !== 0n);
      if (nonZero.length > 0) {
        await this.ledger.post({ cityId, type, source, actor, entries: nonZero }, tx);
      }
    };
    return { account, post };
  }

  // AP §8.5.1, §8.6: the custody lines of a door payment, one entry per
  // currency received and per currency of change against the order clearing
  // account, and what was collected in another currency brought into the
  // base at the order's rates.
  private async postCollection(
    tx: Tx,
    order: DeliveryOrder,
    captainId: string,
    delivery: Pick<Delivery, 'received' | 'change' | 'payment'>,
    actor: LedgerActor,
  ): Promise<void> {
    const base = order.snapshot.baseCurrency;
    const { account, post } = this.poster(tx, order, actor);
    const custodyAndClearing = async (lines: PaymentLine[], sign: 1n | -1n) => {
      const entries: LedgerEntry[] = [];
      for (const line of lines) {
        const custody = await account('captain.custody', line.currency, captainId);
        const clearing = await account('platform.order_clearing', line.currency);
        entries.push(
          { accountId: custody, currency: line.currency, amount: sign * line.amount },
          { accountId: clearing, currency: line.currency, amount: -sign * line.amount },
        );
      }
      return entries;
    };
    await post('custody.collect', await custodyAndClearing(delivery.received, 1n));
    await post('custody.change_given', await custodyAndClearing(delivery.change, -1n));
    // AP §8.6: what was collected in another currency is brought into the
    // base at the order's rates, so the clearing account settles in the base.
    const foreign = delivery.payment.perCurrency.filter(
      (each) => each.currency !== base && each.net !== 0n,
    );
    if (foreign.length > 0) {
      const entries: LedgerEntry[] = [];
      let inBase = 0n;
      for (const each of foreign) {
        entries.push(
          {
            accountId: await account('platform.order_clearing', each.currency),
            currency: each.currency,
            amount: each.net,
          },
          {
            accountId: await account('platform.fx_rounding', each.currency),
            currency: each.currency,
            amount: -each.net,
          },
        );
        inBase += each.base;
      }
      entries.push(
        {
          accountId: await account('platform.order_clearing', base),
          currency: base,
          amount: -inBase,
        },
        { accountId: await account('platform.fx_rounding', base), currency: base, amount: inBase },
      );
      await post('platform.fx_rounding', entries);
    }
  }

  private async post(
    tx: Tx,
    order: DeliveryOrder,
    captainId: string,
    delivery: Delivery,
    actor: DeliveredBy['actor'],
    money: { commission: bigint | null; commissionToClearing: bigint; deliveryFee: bigint },
  ): Promise<void> {
    const base = order.snapshot.baseCurrency;
    const ledgerActor: LedgerActor = { type: actor.type, id: actor.id };
    const { account, post } = this.poster(tx, order, ledgerActor);
    await this.postCollection(tx, order, captainId, delivery, ledgerActor);
    const clearing = await account('platform.order_clearing', base);
    // AP §8.11: the delivery fee is the platform's revenue.
    await post('platform.revenue_delivery', [
      { accountId: clearing, currency: base, amount: money.deliveryFee },
      {
        accountId: await account('platform.revenue_delivery', base),
        currency: base,
        amount: -money.deliveryFee,
      },
    ]);
    // AP §8.4, §8.6: the total's rounding and the door's gap within rounding.
    const rounding = order.rounding - delivery.payment.roundingGap;
    await post('platform.fx_rounding', [
      { accountId: clearing, currency: base, amount: rounding },
      { accountId: await account('platform.fx_rounding', base), currency: base, amount: -rounding },
    ]);
    if (money.commission !== null) {
      await post('merchant.commission', [
        {
          accountId: await account('merchant.account', base, order.restaurantId),
          currency: base,
          amount: money.commission,
        },
        {
          accountId: await account('platform.revenue_commission', base),
          currency: base,
          amount: -(money.commission - money.commissionToClearing),
        },
        // docs/domain/09 rule 3: the commission on items removed after the
        // pickup with the captain or the platform responsible recovers the
        // pickup payment.
        { accountId: clearing, currency: base, amount: -money.commissionToClearing },
      ]);
    }
    // AP §8.5.2, AP §9.6.3: a test order's pay is the platform's test cost.
    const payCounter = await account(
      money.commission === null ? 'platform.test_cost' : 'platform.captain_pay',
      base,
    );
    const earnings = await account('captain.earnings', base, captainId);
    for (const [type, amount] of [
      ['earn.order_pay', delivery.pay.orderPay],
      ['earn.waiting_pay', delivery.pay.waiting],
    ] as const) {
      await post(type, [
        { accountId: earnings, currency: base, amount: -amount },
        { accountId: payCounter, currency: base, amount },
      ]);
    }
  }
}
