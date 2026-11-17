import { and, eq, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import type { Jobs } from '../../jobs/jobs.module.js';
import { FxRefusedError, type FxService } from '../fx/index.js';
import { TicketRefusedError } from '../support/index.js';
import type { EmergencyStops } from './emergency-stop.js';
import { recordTransition } from './order-events.js';
import type { AutoCancelJob } from './order-timers.js';
import { orderKey } from './order-views.js';
import { FIRST_ORDER_NUMBER, plain } from './orders.service.js';
import { type RedeliveryParty, redeliveryLinePrice } from './redelivery.js';
import { orderLines, orderNumbers, orders } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// What a re-delivery reads before the resolution's transaction (never a slow
// read under its locks): the restaurant's timers and the pay table in force.
export interface RedeliveryBasis {
  acceptAlertMin: number;
  autoCancelMin: number;
  payTableId: string;
}

// AP §9.9.3, CU §11.2 (slice 2.23d): the free re-delivery support creates
// from a ticket, in the resolution's transaction: a new order of the
// original's customer and restaurant with the affected items (at no price
// when the restaurant is responsible), to the original's address snapshot,
// a customer total of 0 and the link to the original order and the ticket.
// It is placed as any order (owner decision 2026-11-17: the restaurant
// accepts or rejects it like any order): `placed`, its first event (actor
// the admin) with its outbox row, which rings the restaurant, and the
// automatic cancellation's job. Its commission is the original's, its pay
// table the one in force, its rates the city's now.
export async function placeRedelivery(
  tx: Tx,
  deps: { jobs: Jobs; fx: FxService; emergencyStops: EmergencyStops },
  input: {
    original: { id: string; placedAt: Date };
    ticketId: string;
    responsible: RedeliveryParty;
    chargePay: boolean;
    affected: { position: number; quantity: number }[];
    basis: RedeliveryBasis;
    adminId: string;
    now: Date;
  },
): Promise<{ id: string; placedAt: Date; number: bigint }> {
  const { now } = input;
  const key = orderKey(input.original.id, input.original.placedAt);
  const [original] = await tx.select().from(orders).where(key);
  if (!original) throw new Error(`order ${input.original.id} not found`);
  const lines = await tx
    .select()
    .from(orderLines)
    .where(
      and(
        eq(orderLines.orderId, original.id),
        eq(orderLines.orderPlacedAt, original.placedAt),
        isNull(orderLines.removedByEdit),
      ),
    );
  const byPosition = new Map(lines.map((line) => [line.position, line]));
  const newLines = input.affected.map((each, position) => {
    const line = byPosition.get(each.position);
    if (!line) throw new Error(`order ${original.id} has no line ${each.position}`);
    const unitPrice = redeliveryLinePrice(input.responsible, line.unitPrice);
    return {
      position,
      itemId: line.itemId,
      itemName: line.itemName,
      quantity: each.quantity,
      options: line.options,
      unitPrice,
      lineTotal: unitPrice * BigInt(each.quantity),
      note: line.note,
    };
  });
  const itemsValue = newLines.reduce((sum, line) => sum + line.lineTotal, 0n);
  const { cityId } = original;
  // AP §9.1.6: a stop started since the check refuses it, as a placing.
  if (await deps.emergencyStops.stopsOrders(tx, cityId)) {
    throw new TicketRefusedError('emergency_stop', 'the emergency stop is on');
  }
  // AP §8.6: the city's rates now; without them no order is placed.
  const snapshot = await deps.fx.snapshotForOrder(cityId, tx).catch((error: unknown) => {
    if (error instanceof FxRefusedError) {
      throw new TicketRefusedError('no_base_currency', error.message);
    }
    throw error;
  });
  const [{ number }] = (await tx
    .insert(orderNumbers)
    .values({ cityId, lastNumber: FIRST_ORDER_NUMBER })
    .onConflictDoUpdate({
      target: orderNumbers.cityId,
      set: { lastNumber: sql`${orderNumbers.lastNumber} + 1` },
    })
    .returning({ number: orderNumbers.lastNumber })) as [{ number: bigint }];
  const autoCancelAt = new Date(now.getTime() + input.basis.autoCancelMin * 60_000);
  const [{ id }] = (await tx
    .insert(orders)
    .values({
      placedAt: now,
      cityId,
      number,
      customerAccountId: original.customerAccountId,
      restaurantId: original.restaurantId,
      status: 'placed',
      version: 1,
      captainTrack: null,
      captainId: null,
      currency: original.currency,
      itemsValue,
      deliveryFee: 0n,
      discount: 0n,
      rounding: 0n,
      total: 0n,
      deliveryFree: true,
      feeRuleId: original.feeRuleId,
      commissionBp: original.commissionBp,
      payTableId: input.basis.payTableId,
      testOrder: original.testOrder,
      rateSnapshot: plain(snapshot),
      payIn: null,
      note: null,
      acceptAlertAt: new Date(now.getTime() + input.basis.acceptAlertMin * 60_000),
      autoCancelAt,
      estimateFromMin: original.estimateFromMin,
      estimateToMin: original.estimateToMin,
      tripSeconds: original.tripSeconds,
      tripMetres: original.tripMetres,
      addressId: original.addressId,
      location: sql`(SELECT o.location FROM ordering.orders o WHERE o.id = ${original.id} AND o.placed_at = ${original.placedAt})`,
      zoneId: original.zoneId,
      neighbourhood: original.neighbourhood,
      label: original.label,
      customLabel: original.customLabel,
      street: original.street,
      floor: original.floor,
      landmark: original.landmark,
      contactPhoneEncrypted: original.contactPhoneEncrypted,
      recipientName: original.recipientName,
      directions: original.directions,
      redeliveryOfId: original.id,
      redeliveryOfPlacedAt: original.placedAt,
      redeliveryOfNumber: original.number,
      redeliveryTicketId: input.ticketId,
      redeliveryResponsible: input.responsible,
      redeliveryChargePay: input.chargePay,
      // docs/domain/10: the captain who delivered the original order.
      redeliveryCaptainId: input.responsible === 'captain' ? original.captainId : null,
    })
    .returning({ id: orders.id })) as [{ id: string }];
  await tx
    .insert(orderLines)
    .values(newLines.map((line) => ({ ...line, orderId: id, orderPlacedAt: now, cityId })));
  await recordTransition(
    tx,
    deps.jobs,
    {
      id,
      placedAt: now,
      cityId,
      number,
      restaurantId: original.restaurantId,
      customerAccountId: original.customerAccountId,
      status: 'placed',
      version: 1,
      captainTrack: null,
      captainId: null,
    },
    {
      type: 'order.placed',
      from: null,
      to: 'placed',
      version: 1,
      actor: { type: 'admin', id: input.adminId },
      reason: null,
      at: now,
    },
  );
  // AP §8.3: the restaurant's automatic cancellation, as for any order.
  const job: AutoCancelJob = { orderId: id, placedAt: now.toISOString(), version: 1 };
  await deps.jobs.send(QUEUES.merchantAutoCancel, job, {
    startAfter: autoCancelAt,
    db: inTransaction(tx),
  });
  return { id, placedAt: now, number };
}
