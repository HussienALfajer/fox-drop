import { Inject, Injectable, Module, type OnModuleInit } from '@nestjs/common';
import { and, eq, inArray, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DatabaseModule, DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { JobsModule } from '../../jobs/jobs.module.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { CaptainsModule, CaptainsService } from '../captains/index.js';
import type { Point } from '../geo/index.js';
import { type CaptainTrack, recordTransition } from './order-events.js';
import { orders, type orderStatuses } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Executor = Pick<NodePgDatabase, 'select'>;

// AP §9.12.6: a captain's assigned order counts until it ends.
const CAPTAIN_ACTIVE: OrderStatus[] = ['accepted', 'ready', 'picked_up', 'arrived'];

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
  | { type: 'order.offered'; captainId: string }
  | { type: 'order.offer_closed'; captainId: string; reason: 'declined' | 'expired' }
  | { type: 'order.assigned'; captainId: string };

export interface AssignmentActor {
  type: 'captain' | 'admin' | 'system';
  id: string | null;
}

// The orders' side of dispatch (architecture §4.2): the dispatch module owns
// the offers; this module owns the order, its captain and its captain track,
// and writes each change with its event and outbox row in the dispatch
// command's transaction.
@Injectable()
export class OrderAssignments implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly captains: CaptainsService,
  ) {}

  // CA §7.1: a captain with an active order is busy (AP §9.12.6, no
  // stacking), in every process that reads a captain's state.
  onModuleInit(): void {
    this.captains.useActiveOrders((captainIds, executor) =>
      captainsWithActiveOrders(executor, captainIds),
    );
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
    });
    return {
      ...order,
      version,
      captainTrack,
      captainId: assigned ? change.captainId : order.captainId,
    };
  }
}

// Which of these captains have an active order now.
export async function captainsWithActiveOrders(
  executor: Executor,
  captainIds: string[],
): Promise<Set<string>> {
  if (captainIds.length === 0) return new Set();
  const rows = await executor
    .select({ captainId: orders.captainId })
    .from(orders)
    .where(and(inArray(orders.captainId, captainIds), inArray(orders.status, CAPTAIN_ACTIVE)))
    .groupBy(orders.captainId);
  return new Set(rows.map((row) => row.captainId!));
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
