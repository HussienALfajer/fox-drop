import { Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { CaptainsService } from '../captains/index.js';
import { GeoService, tripMinutes } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { commandHash, IdempotencyKeyReusedError, keepKey, replayKey } from './idempotency-keys.js';
import { lockOrder, recordTransition } from './order-events.js';
import type { SearchStartJob } from './order-timers.js';
import { orderKey, readOrders, type OrderView } from './order-views.js';
import { orders } from './schema.js';

const MINUTE_MS = 60_000;
// docs/domain/03: the promised time is rounded up to the next 5 minutes.
const PROMISE_STEP_MS = 5 * MINUTE_MS;

export type OrderCommandRefusal =
  | 'unknown_order'
  | 'order_state_changed'
  | 'invalid_prep_time'
  | 'idempotency_key_reused'
  // RA §8.10: payment lines (pickup-commands.ts).
  | 'invalid_lines'
  | 'currency_not_accepted'
  | 'amount_mismatch'
  | 'pickup_already_disputed';

// A restaurant command the order refuses; order_state_changed carries the
// order as it is now, which the app explains (RA §4.7).
export class OrderCommandRefusedError extends Error {
  override readonly name = 'OrderCommandRefusedError';
  constructor(
    readonly refusal: OrderCommandRefusal,
    message: string,
    readonly order: OrderView | null = null,
  ) {
    super(message);
  }
}

// RA §18: who runs a restaurant command and on which order.
export interface MerchantCommand {
  restaurantId: string;
  accountId: string;
  // The app installation (RA §18 records the device).
  deviceId: string;
  idempotencyKey: string;
  orderId: string;
}

// RA §8.5: the prep-time chooser of the accept prompt.
export interface PrepTimeChooser {
  options: number[];
  stepMin: number;
  floorMin: number;
  ceilingMin: number;
  // The restaurant's default prep time plus the busy-mode minutes while it is
  // on, within the floor and the ceiling.
  defaultMin: number;
}

// The state a command needs and the one it leaves.
type Transition = {
  verb: 'accept' | 'ready';
  from: 'placed' | 'accepted';
  to: 'accepted' | 'ready';
};

// A state change of the command (the columns it sets) and what the
// transaction sends with it.
type Change = {
  set: Partial<typeof orders.$inferInsert>;
  searchStartAt?: Date;
};

// The restaurant's commands on an order (RA §8.5–8.8, §18): each takes the
// order's lock, checks its state, writes the change, its event, its outbox row
// and its timers in one transaction (architecture §5.5), and keeps the
// command's key with the order (architecture §5.3). Whatever is slow (the
// settings, the nearest captain and its distance) is read before the
// transaction, so it never holds the order's lock while it waits.
@Injectable()
export class OrderCommands {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly jobs: Jobs,
  ) {}

  async prepTimeChooser(restaurantId: string, now: Date): Promise<PrepTimeChooser> {
    const [restaurant, state] = await Promise.all([
      this.merchants.restaurant(restaurantId, now),
      this.merchants.operatingState(restaurantId, now),
    ]);
    if (!restaurant) throw new Error(`restaurant ${restaurantId} not found`);
    const cityId = restaurant.cityId;
    const [options, stepMin, floorMin, ceilingMin] = await Promise.all([
      this.settings.get('merchant.prep_time_options', { cityId }),
      this.settings.get('merchant.prep_time_step_min', { cityId }),
      this.settings.get('merchant.prep_time_floor_min', { cityId }),
      this.settings.get('merchant.prep_time_ceiling_min', { cityId }),
    ]);
    // RA §7.3: busy mode counts only while the restaurant is open, as in the
    // quote's estimate.
    const busyExtraMin = state.state === 'open' ? (state.busyExtraMin ?? 0) : 0;
    const preselected = restaurant.defaultPrepMin + busyExtraMin;
    return {
      options,
      stepMin,
      floorMin,
      ceilingMin,
      defaultMin: Math.min(Math.max(preselected, floorMin), ceilingMin),
    };
  }

  // RA §8.5: a placed order becomes accepted with the chosen prep time, any
  // whole minute from merchant.prep_time_floor_min to its ceiling. It sets
  // the promised time (docs/domain/03), the search-start moment with its
  // timer (AP §8.3, §9.12.6) and operations' prep-late moment.
  async accept(command: MerchantCommand & { prepMin: number }, now: Date): Promise<OrderView> {
    return this.run(
      command,
      { verb: 'accept', from: 'placed', to: 'accepted' },
      { prepMin: command.prepMin },
      now,
      async (order) => {
        const { cityId } = order;
        const [floor, ceiling, bufferMin, speedKmh, searchBufferMin, prepLateMin] =
          await Promise.all([
            this.settings.get('merchant.prep_time_floor_min', { cityId }),
            this.settings.get('merchant.prep_time_ceiling_min', { cityId }),
            this.settings.get('order.eta_buffer_min', { cityId }),
            this.settings.get('order.eta_speed_kmh', { cityId }),
            this.settings.get('dispatch.search_start_buffer_min', { cityId }),
            this.settings.get('order.prep_late_ops_alert_min', { cityId }),
          ]);
        const { prepMin } = command;
        if (!Number.isInteger(prepMin) || prepMin < floor || prepMin > ceiling) {
          throw new OrderCommandRefusedError(
            'invalid_prep_time',
            `the prep time is whole minutes from ${floor} to ${ceiling}`,
          );
        }
        const prepDue = now.getTime() + prepMin * MINUTE_MS;
        // An order placed before slice 1.10 kept no trip.
        const promisedAt = new Date(
          Math.ceil(
            (prepDue + (order.tripSeconds ?? 0) * 1000 + bufferMin * MINUTE_MS) / PROMISE_STEP_MS,
          ) * PROMISE_STEP_MS,
        );
        const etaMs = await this.nearestCaptainEta(order, speedKmh, now);
        // Owner decision 2026-11-06: once, at acceptance; at once when the
        // moment has passed or no captain is online.
        const searchStartAt = new Date(
          etaMs === null
            ? now.getTime()
            : Math.max(now.getTime(), Math.round(prepDue - etaMs - searchBufferMin * MINUTE_MS)),
        );
        return {
          set: {
            acceptedAt: now,
            prepMin,
            promisedAt,
            searchStartAt,
            prepLateAlertAt: new Date(prepDue + prepLateMin * MINUTE_MS),
          },
          searchStartAt,
        };
      },
    );
  }

  // RA §8.8: an accepted order becomes ready, early or late, with no undo.
  // No captain is ever assigned yet, so operations' no-captain moment is set
  // at dispatch.no_captain_after_ready_min (AP §8.3). A ready order has no
  // prep time left, so a search start still ahead moves to now (AP §9.12.6),
  // with its timer.
  async ready(command: MerchantCommand, now: Date): Promise<OrderView> {
    return this.run(
      command,
      { verb: 'ready', from: 'accepted', to: 'ready' },
      {},
      now,
      async (order) => {
        const noCaptainMin = await this.settings.get('dispatch.no_captain_after_ready_min', {
          cityId: order.cityId,
        });
        const early = order.searchStartAt !== null && order.searchStartAt.getTime() > now.getTime();
        return {
          set: {
            readyAt: now,
            noCaptainAlertAt: new Date(now.getTime() + noCaptainMin * MINUTE_MS),
            ...(early ? { searchStartAt: now } : {}),
          },
          ...(early ? { searchStartAt: now } : {}),
        };
      },
    );
  }

  private async run(
    command: MerchantCommand,
    transition: Transition,
    body: object,
    now: Date,
    change: (order: OrderAtStart) => Promise<Change>,
  ): Promise<OrderView> {
    const requestHash = commandHash({ verb: transition.verb, orderId: command.orderId, ...body });
    const earlier = await this.replay(this.database.db, command, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const order = await this.find(command);
    if (order.status !== transition.from) {
      // A repeat sent with the first may read the order after the first
      // committed: it answers the first's order (architecture §5.3).
      const first = await this.replay(this.database.db, command, requestHash, now);
      if (first !== null) return this.read(first);
      throw await this.stateChanged(order);
    }
    const prepared = await change(order);
    const noCaptainAlertMin = prepared.searchStartAt
      ? await this.settings.get('dispatch.no_captain_alert_min', { cityId: order.cityId })
      : 0;

    // pg-boss connects before the lock is taken, never while it is held.
    await this.jobs.ready();
    const outcome = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      // A repeat sent with the first waits on the lock, then answers the
      // first's order.
      const repeat = await this.replay(tx, command, requestHash, now);
      if (repeat !== null) return { done: true as const };
      if (locked.status !== transition.from) return { done: false as const };
      const version = locked.version + 1;
      await tx
        .update(orders)
        .set({ ...prepared.set, status: transition.to, version })
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
      await recordTransition(tx, this.jobs, locked, {
        type: `order.${transition.to}`,
        from: transition.from,
        to: transition.to,
        version,
        actor: { type: 'restaurant', id: command.accountId, device: command.deviceId },
        reason: null,
        at: now,
      });
      if (prepared.searchStartAt) {
        // AP §8.3: the timer exists exactly when its moment does.
        const job: SearchStartJob = {
          orderId: order.id,
          placedAt: order.placedAt.toISOString(),
          searchStartAt: prepared.searchStartAt.toISOString(),
          noCaptainAlertMin,
        };
        await this.jobs.send(QUEUES.searchStart, job, {
          startAfter: prepared.searchStartAt,
          db: inTransaction(tx),
        });
      }
      await keepKey(tx, command.accountId, command.idempotencyKey, requestHash, order, now);
      return { done: true as const };
    });
    if (!outcome.done) throw await this.stateChanged(order);
    return this.read(order);
  }

  // The restaurant's own order, read without a lock: another restaurant's or
  // an unknown one is unknown_order.
  private async find(command: MerchantCommand): Promise<OrderAtStart> {
    const [order] = await this.database.db
      .select({
        id: orders.id,
        placedAt: orders.placedAt,
        cityId: orders.cityId,
        restaurantId: orders.restaurantId,
        status: orders.status,
        tripSeconds: orders.tripSeconds,
        tripMetres: orders.tripMetres,
        searchStartAt: orders.searchStartAt,
      })
      .from(orders)
      .where(and(eq(orders.id, command.orderId), eq(orders.restaurantId, command.restaurantId)));
    if (!order) throw new OrderCommandRefusedError('unknown_order', 'no such order');
    return order;
  }

  // AP §9.12.6: the nearest eligible captain's time to the restaurant at
  // order.eta_speed_kmh, by pricing.distance_method and its vehicle; null
  // without one.
  private async nearestCaptainEta(
    order: OrderAtStart,
    speedKmh: number,
    now: Date,
  ): Promise<number | null> {
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const captain = await this.captains.nearestEligible(
      order.cityId,
      restaurant.location,
      order.tripMetres ?? 0,
      now,
    );
    if (captain === null) return null;
    const distance = await this.geo.distance(captain.position, restaurant.location, {
      vehicle: captain.vehicle,
    });
    return tripMinutes(distance.metres, speedKmh) * MINUTE_MS;
  }

  private async stateChanged(order: { id: string; placedAt: Date }) {
    return new OrderCommandRefusedError(
      'order_state_changed',
      'the order is no longer in the state the command needs',
      await this.read(order),
    );
  }

  private async read({ id, placedAt }: { id: string; placedAt: Date }): Promise<OrderView> {
    const [order] = await readOrders(this.database.db, orderKey(id, placedAt));
    if (!order) throw new Error(`order ${id} not found`);
    return order;
  }

  private async replay(
    executor: Parameters<typeof replayKey>[0],
    command: MerchantCommand,
    requestHash: string,
    now: Date,
  ) {
    try {
      return await replayKey(executor, command.accountId, command.idempotencyKey, requestHash, now);
    } catch (error) {
      if (!(error instanceof IdempotencyKeyReusedError)) throw error;
      throw new OrderCommandRefusedError('idempotency_key_reused', error.message);
    }
  }
}

type OrderAtStart = {
  id: string;
  placedAt: Date;
  cityId: string;
  restaurantId: string;
  status: OrderView['status'];
  tripSeconds: number | null;
  tripMetres: number | null;
  searchStartAt: Date | null;
};
