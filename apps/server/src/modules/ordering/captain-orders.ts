import { Inject, Injectable } from '@nestjs/common';
import { and, eq, inArray } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import { CaptainsRefusedError, CaptainsService } from '../captains/index.js';
import { type Point, straightLineMetres } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { CAPTAIN_ACTIVE } from './order-assignments.js';
import { commandHash, IdempotencyKeyReusedError, keepKey, replayKey } from './idempotency-keys.js';
import { lockOrder, type OrderRow, recordTransition } from './order-events.js';
import { orderKey, readOrders, type OrderView } from './order-views.js';
import { orders } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

const MINUTE_MS = 60_000;
// CA Appendix A: a fix worse than this is a weak signal, «إشارة الموقع ضعيفة —
// اتصل بالعمليات لتسجيل وصولك» (K3); operations record the arrival instead.
export const WEAK_GPS_METRES = 100;

export type CaptainOrderRefusal =
  | 'unknown_order'
  | 'order_state_changed'
  | 'too_far_from_restaurant'
  | 'weak_location'
  | 'simulated_location'
  | 'invalid_location'
  | 'not_online'
  | 'idempotency_key_reused';

// A command on an order that the order or the captain refuses;
// order_state_changed carries the order as it is now, too_far_from_restaurant
// the distance measured.
export class CaptainOrderRefusedError extends Error {
  override readonly name = 'CaptainOrderRefusedError';
  constructor(
    readonly refusal: CaptainOrderRefusal,
    message: string,
    readonly order: OrderView | null = null,
    readonly distanceMetres: number | null = null,
  ) {
    super(message);
  }
}

// The captain's fix sent with a command (CA §15: every command records the
// location).
export interface CommandLocation {
  latitude: number;
  longitude: number;
  accuracyMetres: number;
  recordedAt: Date;
  simulated: boolean;
}

// A captain's command: their app account (whose keys these are), their
// captain record and the app installation (CA §15).
export interface CaptainOrderCommand {
  orderId: string;
  captainId: string;
  accountId: string;
  deviceId: string;
  idempotencyKey: string;
}

// An operations command (AP §9.3.2), with its reason and audit context.
export interface AdminOrderCommand {
  orderId: string;
  admin: { accountId: string; roles: string[] };
  context: AuditRequestContext;
  reason: string;
  idempotencyKey: string;
}

// The captain's active order (CA §9) with the restaurant it is picked up
// from.
export interface CaptainActiveOrder {
  order: OrderView;
  restaurant: { name: string; address: string | null; location: Point };
}

// The captain's side of an order (CA §9, §15) and operations' commands on the
// captain track (AP §9.3.2). Every command locks the order, checks the
// captain track again and writes the change with its event and outbox row in
// one transaction (architecture §5.5); slow reads run before it.
@Injectable()
export class CaptainOrders {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
  ) {}

  // CA §9: the order assigned to the captain until it ends, or null (no
  // stacking in V1, AP §9.12.6).
  async active(captainId: string, now: Date): Promise<CaptainActiveOrder | null> {
    const [order] = await readOrders(
      this.database.db,
      and(eq(orders.captainId, captainId), inArray(orders.status, CAPTAIN_ACTIVE)),
      { newestFirst: true },
    );
    return order ? this.withRestaurant(order, now) : null;
  }

  // CA §9.2 (C6): «وصلت إلى المطعم», only within
  // captain.merchant_arrival_radius_m of the restaurant by the fix sent,
  // which is recorded (CA §15); a weak or simulated fix is refused, and
  // operations record the arrival instead (K3).
  async arrive(
    command: CaptainOrderCommand & { location: CommandLocation },
    now: Date,
  ): Promise<CaptainActiveOrder> {
    // The fix is not part of the command: a retry sends a newer one.
    const requestHash = commandHash({ verb: 'arrive', orderId: command.orderId });
    const earlier = await this.replay(command.accountId, command, requestHash, now);
    if (earlier !== null) return this.answer(earlier, now);
    const order = await this.captainsOrder(command);
    if (!arrivable(order, command.captainId)) {
      throw await this.refusedState(order, command.accountId, command, requestHash, now);
    }
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const [radius, thresholdMin] = await Promise.all([
      this.settings.get('captain.merchant_arrival_radius_m', { cityId: order.cityId }),
      this.settings.get('captain.waiting_threshold_min', { cityId: order.cityId }),
    ]);
    await this.recordLocation(command.captainId, command.location, now);
    if (command.location.simulated) {
      throw new CaptainOrderRefusedError('simulated_location', 'a simulated location');
    }
    if (command.location.accuracyMetres > WEAK_GPS_METRES) {
      throw new CaptainOrderRefusedError('weak_location', 'the location is not accurate enough');
    }
    const distanceMetres = Math.round(straightLineMetres(command.location, restaurant.location));
    if (distanceMetres > radius) {
      throw new CaptainOrderRefusedError(
        'too_far_from_restaurant',
        `${distanceMetres} m from the restaurant, more than ${radius} m`,
        null,
        distanceMetres,
      );
    }
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      if ((await this.replay(command.accountId, command, requestHash, now, tx)) !== null) {
        return true;
      }
      if (!arrivable(locked, command.captainId)) return false;
      await this.writeArrival(tx, locked, thresholdMin, now, {
        actor: { type: 'captain', id: command.captainId, device: command.deviceId },
        reason: null,
      });
      await keepKey(tx, command.accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) throw await this.stateChanged(order);
    return this.answer(order, now);
  }

  // AP §9.3.2 «تسجيل وصول الكابتن»: when GPS fails at the restaurant, OPS set
  // the captain track to at_merchant, with a reason, audited.
  async recordArrival(command: AdminOrderCommand, now: Date): Promise<OrderView> {
    const accountId = command.admin.accountId;
    const requestHash = commandHash({
      verb: 'record_arrival',
      orderId: command.orderId,
      reason: command.reason,
    });
    const earlier = await this.replay(accountId, command, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const order = await this.anyOrder(command.orderId);
    if (!arrivable(order, order.captainId)) {
      throw await this.refusedState(order, accountId, command, requestHash, now);
    }
    const thresholdMin = await this.settings.get('captain.waiting_threshold_min', {
      cityId: order.cityId,
    });
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      if ((await this.replay(accountId, command, requestHash, now, tx)) !== null) return true;
      if (!arrivable(locked, locked.captainId)) return false;
      await this.writeArrival(tx, locked, thresholdMin, now, {
        actor: { type: 'admin', id: accountId },
        reason: command.reason,
      });
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: accountId, role: command.admin.roles.join(',') },
          context: command.context,
          cityId: locked.cityId,
          action: 'order.record_arrival',
          target: { type: 'order', id: locked.id },
          before: { captainTrack: locked.captainTrack },
          after: { captainTrack: 'at_merchant', arrivedAtMerchantAt: now.toISOString() },
          reason: command.reason,
        },
        tx,
      );
      await keepKey(tx, accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) throw await this.stateChanged(order);
    return this.read(order);
  }

  // The arrival on the locked order: track at_merchant, the arrival and the
  // waiting alert's moment (RA §8.9, AP §9.1.3), its event and outbox row.
  private async writeArrival(
    tx: Tx,
    order: OrderRow,
    thresholdMin: number,
    now: Date,
    by: {
      actor: { type: 'captain' | 'admin'; id: string; device?: string };
      reason: string | null;
    },
  ): Promise<void> {
    const version = order.version + 1;
    await tx
      .update(orders)
      .set({
        version,
        captainTrack: 'at_merchant',
        arrivedAtMerchantAt: now,
        captainWaitingAlertAt: new Date(now.getTime() + thresholdMin * MINUTE_MS),
      })
      .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
    await recordTransition(tx, this.jobs, order, {
      type: 'order.captain_arrived',
      from: order.status,
      to: order.status,
      version,
      actor: by.actor,
      reason: by.reason,
      at: now,
      captainTrack: 'at_merchant',
    });
  }

  // CA §15: the command's fix joins the captain's route.
  private async recordLocation(captainId: string, location: CommandLocation, now: Date) {
    try {
      await this.captains.recordLocations(captainId, [location], now);
    } catch (error) {
      if (!(error instanceof CaptainsRefusedError)) throw error;
      if (error.refusal === 'invalid_location' || error.refusal === 'not_online') {
        throw new CaptainOrderRefusedError(error.refusal, error.message);
      }
      throw error;
    }
  }

  // The captain's own order, read without a lock; another captain's or an
  // unknown one is unknown_order.
  private async captainsOrder(command: CaptainOrderCommand): Promise<OrderAtStart> {
    const order = await this.anyOrder(command.orderId);
    if (order.captainId !== command.captainId) {
      throw new CaptainOrderRefusedError('unknown_order', 'no such order');
    }
    return order;
  }

  private async anyOrder(orderId: string): Promise<OrderAtStart> {
    const [order] = await this.database.db
      .select({
        id: orders.id,
        placedAt: orders.placedAt,
        cityId: orders.cityId,
        restaurantId: orders.restaurantId,
        status: orders.status,
        captainTrack: orders.captainTrack,
        captainId: orders.captainId,
      })
      .from(orders)
      .where(eq(orders.id, orderId));
    if (!order) throw new CaptainOrderRefusedError('unknown_order', 'no such order');
    return order;
  }

  // A repeat sent with the first may read the order after the first
  // committed: it answers the first's order (architecture §5.3).
  private async refusedState(
    order: OrderAtStart,
    accountId: string,
    command: { idempotencyKey: string },
    requestHash: string,
    now: Date,
  ): Promise<CaptainOrderRefusedError> {
    const first = await this.replay(accountId, command, requestHash, now);
    if (first !== null) {
      return new CaptainOrderRefusedError(
        'order_state_changed',
        'the command already ran',
        await this.read(first),
      );
    }
    return this.stateChanged(order);
  }

  private async stateChanged(order: { id: string; placedAt: Date }) {
    return new CaptainOrderRefusedError(
      'order_state_changed',
      'the order is no longer in the state the command needs',
      await this.read(order),
    );
  }

  private async answer(
    key: { id: string; placedAt: Date },
    now: Date,
  ): Promise<CaptainActiveOrder> {
    return this.withRestaurant(await this.read(key), now);
  }

  private async withRestaurant(order: OrderView, now: Date): Promise<CaptainActiveOrder> {
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    return {
      order,
      restaurant: {
        name: restaurant.nameAr,
        address: restaurant.address,
        location: restaurant.location,
      },
    };
  }

  private async read({ id, placedAt }: { id: string; placedAt: Date }): Promise<OrderView> {
    const [order] = await readOrders(this.database.db, orderKey(id, placedAt));
    if (!order) throw new Error(`order ${id} not found`);
    return order;
  }

  private async replay(
    accountId: string,
    command: { idempotencyKey: string },
    requestHash: string,
    now: Date,
    executor: Parameters<typeof replayKey>[0] = this.database.db,
  ) {
    try {
      return await replayKey(executor, accountId, command.idempotencyKey, requestHash, now);
    } catch (error) {
      if (!(error instanceof IdempotencyKeyReusedError)) throw error;
      throw new CaptainOrderRefusedError('idempotency_key_reused', error.message);
    }
  }
}

// CA §15, AP §9.3.2: the assigned captain, not yet at the restaurant, before
// pickup.
function arrivable(
  order: Pick<OrderAtStart, 'status' | 'captainTrack' | 'captainId'>,
  captainId: string | null,
): boolean {
  return (
    (order.status === 'accepted' || order.status === 'ready') &&
    order.captainTrack === 'assigned' &&
    order.captainId !== null &&
    order.captainId === captainId
  );
}

type OrderAtStart = {
  id: string;
  placedAt: Date;
  cityId: string;
  restaurantId: string;
  status: OrderView['status'];
  captainTrack: OrderView['captainTrack'];
  captainId: string | null;
};
