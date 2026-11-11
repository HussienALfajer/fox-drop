import { Inject, Injectable, Module, type OnModuleInit } from '@nestjs/common';
import { and, count, desc, eq, gte, inArray, isNotNull, isNull, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DatabaseModule, DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { JobsModule } from '../../jobs/jobs.module.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { CaptainsModule, CaptainsService } from '../captains/index.js';
import type { Point } from '../geo/index.js';
import { openCannotComplete } from './cannot-complete.js';
import { canHandOver, type HandoverRefusal } from './handover.js';
import { type CaptainTrack, recordTransition } from './order-events.js';
import { pendingOutcome } from './outcome-facts.js';
import { handovers, type handoverCloseReasons, orders, type orderStatuses } from './schema.js';
import type { AfterCommit } from './delivery-booking.js';

type OrderStatus = (typeof orderStatuses)[number];
type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Executor = Pick<NodePgDatabase, 'select'>;

// AP §9.12.6: a captain's assigned order counts until it ends.
export const CAPTAIN_ACTIVE: OrderStatus[] = ['accepted', 'ready', 'picked_up', 'arrived'];

// What dispatch reads of an order (AP §9.3.2, §9.12.6; CA §8.2): its state,
// its captain track and what an offer shows. Money is in the order's
// currency, the city's base, in minor units.
export interface DispatchOrder {
  id: string;
  placedAt: Date;
  cityId: string;
  number: bigint;
  restaurantId: string;
  customerAccountId: string;
  status: OrderStatus;
  version: number;
  captainTrack: CaptainTrack | null;
  captainId: string | null;
  searchStartedAt: Date | null;
  // The motorbike's trip kept at placing (docs/domain/03), 0 for an order
  // placed before slice 1.10.
  tripMetres: number;
  acceptedAt: Date | null;
  prepMin: number | null;
  readyAt: Date | null;
  currency: string;
  itemsValue: bigint;
  total: bigint;
  // captains' pay table in force at placing; null while the city had none.
  payTableId: string | null;
  // «الحي» of the address (CA §8.2 shows it, never the pin, before acceptance).
  neighbourhood: string;
  location: Point;
}

// A change of the captain track that dispatch makes (AP §8.2): an offer
// opened, an offer closed (declined or expired), a captain assigned.
export type AssignmentChange =
  // pay: the order pay the offer shows (CA §8.2) and expiresAt its end, for
  // the captain's push.
  | {
      type: 'order.offered';
      captainId: string;
      pay: { amount: bigint; currency: string } | null;
      expiresAt: Date;
    }
  | { type: 'order.offer_closed'; captainId: string; reason: 'declined' | 'expired' | 'withdrawn' }
  | { type: 'order.assigned'; captainId: string };

// AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b): an order's open handover, from
// its captain to a second one: offered (offerId, not yet assigned) or
// assigned (the second captain has it, busy), not yet received.
export interface OpenHandover {
  id: string;
  fromCaptainId: string;
  toCaptainId: string;
  offerId: string | null;
  assignedAt: Date | null;
}

export type HandoverCloseReason = (typeof handoverCloseReasons)[number];

// Dispatch's part of an order's end (a cancellation, an outcome, operations'
// delivery), in its transaction on the locked order.
export type CancelListener = (
  tx: Tx,
  order: DispatchOrder,
  actor: AssignmentActor,
  now: Date,
) => Promise<void>;

export interface AssignmentActor {
  type: 'captain' | 'admin' | 'system';
  id: string | null;
  // CA §15: the captain's app installation the command ran on.
  device?: string;
}

// The orders' side of dispatch (architecture §4.2): the dispatch module owns
// the offers; this module owns the order, its captain and its captain track,
// and writes each change with its event and outbox row in the dispatch
// command's transaction.
@Injectable()
export class OrderAssignments implements OnModuleInit {
  // CA §7.3, K18 (slice 2.13a): what runs after a transaction commits once a
  // closed handover took the order from its second captain, until the
  // transaction's owner takes it (takeAfterCommit).
  private readonly afterCommits = new WeakMap<Tx, AfterCommit[]>();

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly captains: CaptainsService,
  ) {}

  // The work a closed handover left for after the commit of this
  // transaction; the caller runs it once the transaction committed.
  takeAfterCommit(tx: Tx): AfterCommit {
    const pending = this.afterCommits.get(tx) ?? [];
    this.afterCommits.delete(tx);
    return async () => {
      for (const after of pending) await after();
    };
  }

  // CA §7.1: a captain with an active order is busy (AP §9.12.6, no
  // stacking), in every process that reads a captain's state.
  onModuleInit(): void {
    this.captains.useActiveOrders((captainIds, executor) =>
      captainsWithActiveOrders(executor, captainIds),
    );
  }

  // AP §9.3.2 «إلغاء الطلب», CA §9.10 (slice 2.8b): dispatch owns the offers,
  // and ordering cannot import it, so dispatch registers what a cancellation
  // does to them: in the cancellation's transaction, before its own
  // transition, the order's open offer is withdrawn (order.offer_closed).
  private readonly cancelListeners: CancelListener[] = [];

  onCancel(listener: CancelListener): void {
    this.cancelListeners.push(listener);
  }

  // The locked order is about to end (cancelled, an outcome set, delivered
  // by operations): dispatch withdraws its open offer, a handover's
  // included, and an assigned handover closes as ended (slice 2.12b). An
  // offered order with no listener would leave its offer open, so it fails.
  // The order's version may move: the caller locks it again.
  async beforeEnd(
    tx: Tx,
    orderId: string,
    placedAt: Date,
    actor: AssignmentActor,
    now: Date,
  ): Promise<void> {
    const order = await this.lock(tx, orderId, placedAt);
    if (order === null) throw new Error(`order ${orderId} not found`);
    const handover = await this.openHandover(tx, order);
    const offered =
      order.captainTrack === 'offered' || (handover !== null && handover.assignedAt === null);
    if (offered && this.cancelListeners.length === 0) {
      throw new Error('an offered order ends without dispatch to withdraw its offer');
    }
    for (const listener of this.cancelListeners) await listener(tx, order, actor, now);
    const still = await this.openHandover(tx, order);
    if (still === null) return;
    const current = await this.lock(tx, orderId, placedAt);
    await this.closeHandover(tx, current!, still, 'ended', actor, now);
  }

  // AP §9.3.2 «تسليم لكابتن آخر»: whether operations may hand the order to
  // this captain now (handover.ts), read with the executor given (the
  // command's transaction under the order's lock, or the pool before it).
  async handoverProblem(
    executor: Executor,
    order: DispatchOrder,
    toCaptainId: string,
  ): Promise<HandoverRefusal | null> {
    const outcomePending = await pendingOutcome(executor, order);
    return canHandOver(order, { outcomePending: outcomePending !== null }, toCaptainId);
  }

  // AP §9.3.2, CA §9.10.1 (slice 2.12b): the order's open handover, if any.
  async openHandover(
    executor: Executor,
    order: { id: string; placedAt: Date },
  ): Promise<OpenHandover | null> {
    return openHandoverOf(executor, order);
  }

  // AP §9.3.2 «تسليم لكابتن آخر»: operations open the handover of the locked
  // picked-up order to a second captain, as an offer (dispatch's, with its
  // pay and end) or an assignment. The order stays its captain's until the
  // receipt; the event is about the second captain and reaches the first.
  async startHandover(
    tx: Tx,
    order: DispatchOrder,
    start: {
      toCaptainId: string;
      note: string;
      adminId: string;
      // AP §9.7.6 (slice 2.13b): the fault operations chose while the first
      // captain's «لا أستطيع إكمال الطلب» is open; null counts as theirs.
      captainFault: boolean | null;
      offer: {
        id: string;
        pay: { amount: bigint; currency: string } | null;
        expiresAt: Date;
      } | null;
    },
    now: Date,
  ): Promise<void> {
    if (order.captainId === null) throw new Error(`order ${order.id} has no captain`);
    const problem = await openCannotComplete(tx, order);
    await tx.insert(handovers).values({
      orderId: order.id,
      orderPlacedAt: order.placedAt,
      cityId: order.cityId,
      fromCaptainId: order.captainId,
      toCaptainId: start.toCaptainId,
      offerId: start.offer?.id ?? null,
      note: start.note,
      adminId: start.adminId,
      openedAt: now,
      assignedAt: start.offer === null ? now : null,
      captainFault: problem?.captainId === order.captainId ? (start.captainFault ?? true) : null,
    });
    await this.handoverEvent(
      tx,
      order,
      start.offer === null ? 'order.handover_assigned' : 'order.handover_offered',
      start.toCaptainId,
      { type: 'admin', id: start.adminId },
      { reason: start.note, publicReason: null },
      now,
      start.offer === null
        ? {}
        : { offerPay: start.offer.pay, offerExpiresAt: start.offer.expiresAt },
    );
  }

  // CA §8.3: the second captain accepted the handover offer; they are busy
  // with the order from now on.
  async assignHandover(
    tx: Tx,
    order: DispatchOrder,
    handover: OpenHandover,
    actor: AssignmentActor,
    now: Date,
  ): Promise<DispatchOrder> {
    await tx.update(handovers).set({ assignedAt: now }).where(eq(handovers.id, handover.id));
    return this.handoverEvent(
      tx,
      order,
      'order.handover_assigned',
      handover.toCaptainId,
      actor,
      { reason: null },
      now,
    );
  }

  // The handover closed without the receipt: its offer declined, expired or
  // withdrawn, or the order ended first.
  async closeHandover(
    tx: Tx,
    order: DispatchOrder,
    handover: OpenHandover,
    reason: HandoverCloseReason,
    actor: AssignmentActor,
    now: Date,
  ): Promise<DispatchOrder> {
    await tx
      .update(handovers)
      .set({ closedAt: now, closeReason: reason })
      .where(eq(handovers.id, handover.id));
    // An assigned handover was the second captain's active order: their
    // last-order mode may end with it (CA §7.3, K18).
    if (handover.assignedAt !== null) {
      const after = await this.captains.afterOrderLeft(tx, handover.toCaptainId, now);
      this.afterCommits.set(tx, [...(this.afterCommits.get(tx) ?? []), after]);
    }
    return this.handoverEvent(
      tx,
      order,
      'order.handover_closed',
      handover.toCaptainId,
      actor,
      { reason },
      now,
    );
  }

  private async handoverEvent(
    tx: Tx,
    order: DispatchOrder,
    type: 'order.handover_offered' | 'order.handover_assigned' | 'order.handover_closed',
    toCaptainId: string,
    actor: AssignmentActor,
    reason: { reason: string | null; publicReason?: string | null },
    now: Date,
    offer: {
      offerPay?: { amount: bigint; currency: string } | null;
      offerExpiresAt?: Date;
    } = {},
  ): Promise<DispatchOrder> {
    const version = order.version + 1;
    await tx
      .update(orders)
      .set({ version })
      .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
    await recordTransition(tx, this.jobs, order, {
      type,
      from: order.status,
      to: order.status,
      version,
      actor,
      ...reason,
      at: now,
      captainId: toCaptainId,
      ...(order.captainId === null ? {} : { otherCaptainId: order.captainId }),
      ...offer,
    });
    return { ...order, version };
  }

  // The order without a lock, by its id alone; null when unknown.
  async find(orderId: string): Promise<DispatchOrder | null> {
    const [order] = await selectOrders(this.database.db, eq(orders.id, orderId));
    return order ?? null;
  }

  // The order locked for a change, in the command's transaction.
  async lock(tx: Tx, orderId: string, placedAt: Date): Promise<DispatchOrder | null> {
    const [order] = await selectOrders(
      tx,
      and(eq(orders.id, orderId), eq(orders.placedAt, placedAt)),
      true,
    );
    return order ?? null;
  }

  // AP §9.3.2: each captain's orders assigned since the moment (the
  // picker's «طلبات اليوم»), whatever became of them.
  async assignedSince(captainIds: string[], since: Date): Promise<Map<string, number>> {
    if (captainIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ captainId: orders.captainId, n: count() })
      .from(orders)
      .where(and(inArray(orders.captainId, captainIds), gte(orders.assignedAt, since)))
      .groupBy(orders.captainId);
    return new Map(rows.map((row) => [row.captainId!, row.n]));
  }

  // AP §9.3.2 «تعيين كابتن»: accepted or ready, no captain and no open offer.
  // An order still placed waits for the restaurant (CA §8.1).
  assignable(order: DispatchOrder): boolean {
    return (
      (order.status === 'accepted' || order.status === 'ready') &&
      order.captainId === null &&
      order.captainTrack !== 'offered'
    );
  }

  // Writes the change on the locked order with its event, version and outbox
  // row. An offer that closes returns the order to «بحاجة لتعيين» once its
  // search started (docs/domain/03), or to no track before that.
  async change(
    tx: Tx,
    order: DispatchOrder,
    change: AssignmentChange,
    actor: AssignmentActor,
    now: Date,
  ): Promise<DispatchOrder> {
    const version = order.version + 1;
    const captainTrack: CaptainTrack | null =
      change.type === 'order.offered'
        ? 'offered'
        : change.type === 'order.assigned'
          ? 'assigned'
          : order.searchStartedAt === null
            ? null
            : 'searching';
    const assigned = change.type === 'order.assigned';
    await tx
      .update(orders)
      .set({
        version,
        captainTrack,
        ...(assigned ? { captainId: change.captainId, assignedAt: now } : {}),
      })
      .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
    await recordTransition(tx, this.jobs, order, {
      type: change.type,
      from: order.status,
      to: order.status,
      version,
      actor,
      reason: change.type === 'order.offer_closed' ? change.reason : null,
      at: now,
      captainTrack,
      captainId: change.captainId,
      ...(change.type === 'order.offered'
        ? { offerPay: change.pay, offerExpiresAt: change.expiresAt }
        : {}),
    });
    return {
      ...order,
      version,
      captainTrack,
      captainId: assigned ? change.captainId : order.captainId,
    };
  }
}

// AP §9.3.2, CA §9.10.1 (slice 2.12b): the order's open handover, if any.
export async function openHandoverOf(
  executor: Executor,
  order: { id: string; placedAt: Date },
): Promise<OpenHandover | null> {
  const [row] = await executor
    .select({
      id: handovers.id,
      fromCaptainId: handovers.fromCaptainId,
      toCaptainId: handovers.toCaptainId,
      offerId: handovers.offerId,
      assignedAt: handovers.assignedAt,
    })
    .from(handovers)
    .where(
      and(
        eq(handovers.orderId, order.id),
        eq(handovers.orderPlacedAt, order.placedAt),
        isNull(handovers.receivedAt),
        isNull(handovers.closedAt),
      ),
    );
  return row ?? null;
}

// The handover the order was received by, if any: its second captain
// delivers it, without the first's waiting, and paid nothing at the pickup.
export async function receivedHandoverOf(
  executor: Executor,
  order: { id: string; placedAt: Date },
): Promise<{ fromCaptainId: string; toCaptainId: string } | null> {
  const [row] = await executor
    .select({ fromCaptainId: handovers.fromCaptainId, toCaptainId: handovers.toCaptainId })
    .from(handovers)
    .where(
      and(
        eq(handovers.orderId, order.id),
        eq(handovers.orderPlacedAt, order.placedAt),
        isNotNull(handovers.receivedAt),
      ),
    )
    .orderBy(desc(handovers.receivedAt))
    .limit(1);
  return row ?? null;
}

// Which of these captains have an active order now: as its captain, or as
// the second captain of an assigned handover not yet received (slice 2.12b;
// a handover closes when its order ends).
export async function captainsWithActiveOrders(
  executor: Executor,
  captainIds: string[],
): Promise<Set<string>> {
  if (captainIds.length === 0) return new Set();
  const [rows, receiving] = await Promise.all([
    executor
      .select({ captainId: orders.captainId })
      .from(orders)
      .where(and(inArray(orders.captainId, captainIds), inArray(orders.status, CAPTAIN_ACTIVE)))
      .groupBy(orders.captainId),
    executor
      .select({ captainId: handovers.toCaptainId })
      .from(handovers)
      .where(
        and(
          inArray(handovers.toCaptainId, captainIds),
          isNotNull(handovers.assignedAt),
          isNull(handovers.receivedAt),
          isNull(handovers.closedAt),
        ),
      ),
  ]);
  return new Set([...rows.map((row) => row.captainId!), ...receiving.map((row) => row.captainId)]);
}

async function selectOrders(
  executor: Executor,
  where: SQL | undefined,
  forUpdate = false,
): Promise<DispatchOrder[]> {
  const query = executor
    .select({
      id: orders.id,
      placedAt: orders.placedAt,
      cityId: orders.cityId,
      number: orders.number,
      restaurantId: orders.restaurantId,
      customerAccountId: orders.customerAccountId,
      status: orders.status,
      version: orders.version,
      captainTrack: orders.captainTrack,
      captainId: orders.captainId,
      searchStartedAt: orders.searchStartedAt,
      tripMetres: orders.tripMetres,
      acceptedAt: orders.acceptedAt,
      prepMin: orders.prepMin,
      readyAt: orders.readyAt,
      currency: orders.currency,
      itemsValue: orders.itemsValue,
      total: orders.total,
      payTableId: orders.payTableId,
      neighbourhood: orders.neighbourhood,
      latitude: sql<number>`ST_Y(${orders.location})`.mapWith(Number),
      longitude: sql<number>`ST_X(${orders.location})`.mapWith(Number),
    })
    .from(orders)
    .where(where);
  const rows = forUpdate ? await query.for('update') : await query;
  return rows.map(({ latitude, longitude, tripMetres, ...row }) => ({
    ...row,
    tripMetres: tripMetres ?? 0,
    location: { latitude, longitude },
  }));
}

// The orders' side of dispatch for every process that runs it: the API's
// routes and the worker's offer timers.
@Module({
  imports: [DatabaseModule, JobsModule, CaptainsModule],
  providers: [OrderAssignments],
  exports: [OrderAssignments],
})
export class OrderAssignmentsModule {}
