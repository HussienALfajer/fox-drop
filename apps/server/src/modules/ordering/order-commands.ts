import { Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { AuditService } from '../audit/index.js';
import { CaptainsService } from '../captains/index.js';
import { ContentRefusedError, ContentService } from '../content/index.js';
import { GeoService, tripMinutes } from '../geo/index.js';
import {
  type MerchantChange,
  MerchantsService,
  RestaurantStatusService,
} from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import type { AdminOrderCommand } from './captain-orders.js';
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
  // RA §8.6: a reason not on the list, or steps that do not fit it.
  | 'unknown_reason'
  | 'invalid_rejection'
  // CU §11.4: «سبب آخر» takes its optional text; the other reasons none.
  | 'reason_note_required'
  | 'reason_note_not_allowed'
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
  // The user's role and address, which the audit of a rejection's side
  // effects keeps (RA §8.6).
  role?: string;
  ipAddress?: string | null;
}

// CU §11.4: the customer's own command on their order.
export interface CustomerCommand {
  accountId: string;
  idempotencyKey: string;
  orderId: string;
}

// RA §8.6, R3: the three reasons of Content's closed merchant_rejection
// list, each with its own behaviour.
export const REJECTION_REASONS = ['item_unavailable', 'restaurant_closed', 'too_busy'] as const;
export type RejectionReason = (typeof REJECTION_REASONS)[number];

// RA §8.6: the rejection with its steps: the items of «صنف غير متوفر», each
// «حتى الغد» or «حتى أعيده»; for «ضغط طلبات» optionally «تفعيل وضع الضغط»
// (its minutes) or «إيقاف 30 د».
export interface Rejection {
  // The reason's code in Content's merchant_rejection list.
  code: string;
  items: { itemId: string; until: 'tomorrow' | 'turned_back_on' }[];
  busyExtraMin: number | null;
  pauseMin: number | null;
}

// RA §8.6: «إيقاف 30 د» is the only pause «ضغط طلبات» offers.
export const TOO_BUSY_PAUSE_MIN = 30;

// RA §8.6: why the rejection's steps do not fit its reason, or null. The
// items are the order's (each once) and only for «صنف غير متوفر», where at
// least one is required; busy mode or the 30-minute pause, not both, only
// for «ضغط طلبات».
export function rejectionProblem(rejection: Rejection, orderItemIds: string[]): string | null {
  if (!(REJECTION_REASONS as readonly string[]).includes(rejection.code)) {
    return 'unknown_reason';
  }
  const ids = rejection.items.map((item) => item.itemId);
  if (rejection.code === 'item_unavailable') {
    if (ids.length === 0) return 'pick the unavailable items';
    if (new Set(ids).size !== ids.length) return 'each item once';
    if (ids.some((id) => !orderItemIds.includes(id))) return "the items are the order's";
  } else if (ids.length > 0) {
    return 'items only for item_unavailable';
  }
  if (rejection.code !== 'too_busy') {
    if (rejection.busyExtraMin !== null || rejection.pauseMin !== null) {
      return 'busy mode or a pause only for too_busy';
    }
  } else if (rejection.busyExtraMin !== null && rejection.pauseMin !== null) {
    return 'busy mode or a pause, not both';
  } else if (rejection.pauseMin !== null && rejection.pauseMin !== TOO_BUSY_PAUSE_MIN) {
    return `the pause is ${TOO_BUSY_PAUSE_MIN} minutes`;
  }
  return null;
}

// What a rejection's key hashes: the reason and its steps.
function rejectionHash(rejection: Rejection) {
  return {
    code: rejection.code,
    items: rejection.items,
    busyExtraMin: rejection.busyExtraMin,
    pauseMin: rejection.pauseMin,
  };
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

// AP §9.3.2: what operations choose from to accept or reject on the
// restaurant's behalf, as the restaurant's own prompt and sheet do (RA §8.5,
// §8.6).
export interface OnBehalfChoices {
  prepTime: PrepTimeChooser;
  // Content's active merchant_rejection reasons, in order.
  rejectionReasons: { code: string; label: string }[];
  // «تفعيل وضع الضغط» with «ضغط طلبات».
  busyExtraOptionsMin: number[];
}

// The state a command needs and the one it leaves.
type Transition = {
  verb: 'accept' | 'ready' | 'reject' | 'cancel';
  from: 'placed' | 'accepted';
  to: 'accepted' | 'ready' | 'rejected' | 'cancelled';
};

// Who runs a command: a user of the restaurant on its device (RA §18),
// operations on the restaurant's behalf (AP §9.3.2), on any order, with the
// reason the event and the audit keep, or the customer on their own order
// (CU §11.4).
type Caller =
  | { kind: 'restaurant'; command: MerchantCommand }
  | { kind: 'admin'; command: AdminOrderCommand }
  | { kind: 'customer'; command: CustomerCommand };

// A state change of the command (the columns it sets) and what the
// transaction sends with it.
type Change = {
  set: Partial<typeof orders.$inferInsert>;
  searchStartAt?: Date;
  // What the apps' channels publish as the reason (RA §8.6: the rejection's
  // code); the restaurant's event keeps it too, operations' keeps their note.
  publicReason?: string;
  // What the event row keeps as the reason, when not the public one: the
  // customer's text of «سبب آخر» (CU §11.4).
  eventReason?: string;
  // Written in the transaction after the order's own change (RA §8.6).
  effects?: (tx: Tx) => Promise<void>;
};

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

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
    private readonly content: ContentService,
    private readonly status: RestaurantStatusService,
    private readonly audit: AuditService,
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

  async onBehalfChoices(restaurantId: string, cityId: string, now: Date): Promise<OnBehalfChoices> {
    const [prepTime, lists, busyExtraOptionsMin] = await Promise.all([
      this.prepTimeChooser(restaurantId, now),
      this.content.listsFor('merchant'),
      this.settings.get('merchant.busy_extra_options_min', { cityId }),
    ]);
    return {
      prepTime,
      rejectionReasons: (lists.merchant_rejection ?? []).map(({ code, label }) => ({
        code,
        label,
      })),
      busyExtraOptionsMin,
    };
  }

  // RA §8.5: a placed order becomes accepted with the chosen prep time, any
  // whole minute from merchant.prep_time_floor_min to its ceiling. It sets
  // the promised time (docs/domain/03), the search-start moment with its
  // timer (AP §8.3, §9.12.6) and operations' prep-late moment.
  async accept(command: MerchantCommand & { prepMin: number }, now: Date): Promise<OrderView> {
    return this.run(
      { kind: 'restaurant', command },
      { verb: 'accept', from: 'placed', to: 'accepted' },
      { prepMin: command.prepMin },
      now,
      (order) => this.acceptance(order, command.prepMin, now),
    );
  }

  // AP §9.3.2 «قبول نيابة عن المطعم» (RA §8.15): the same acceptance by
  // operations, with their reason; the restaurant's devices chime with the
  // prep time (RA §16 #5) and its card shows «قبلته العمليات».
  async acceptFor(command: AdminOrderCommand & { prepMin: number }, now: Date): Promise<OrderView> {
    return this.run(
      { kind: 'admin', command },
      { verb: 'accept', from: 'placed', to: 'accepted' },
      { prepMin: command.prepMin, reason: command.reason },
      now,
      (order) => this.acceptance(order, command.prepMin, now),
    );
  }

  // RA §8.6: «رفض» with one of the three reasons and its steps. The order
  // becomes rejected and keeps the reason, its label, the customer's text
  // (CU Appendix C; «{الأصناف}» filled with the items' names) and the items;
  // in the same transaction the items are switched off, or the restaurant
  // paused «حتى أعيد الفتح» (S2), or busy mode or «إيقاف 30 د» set, each only
  // when the restaurant could set it now. 400 unknown_reason,
  // invalid_rejection.
  async reject(command: MerchantCommand & Rejection, now: Date): Promise<OrderView> {
    const change: MerchantChange = {
      actor: { type: 'merchant', id: command.accountId, role: command.role ?? null },
      context: { ipAddress: command.ipAddress ?? null, device: command.deviceId },
    };
    return this.run(
      { kind: 'restaurant', command },
      { verb: 'reject', from: 'placed', to: 'rejected' },
      rejectionHash(command),
      now,
      (order) => this.rejection(order, command, change, now),
    );
  }

  // AP §9.3.2 «رفض نيابة عن المطعم» (RA §8.15): the same rejection by
  // operations, with their reason; the restaurant's devices chime with the
  // rejection's label (RA §16 #6).
  async rejectFor(command: AdminOrderCommand & Rejection, now: Date): Promise<OrderView> {
    const change: MerchantChange = {
      actor: { type: 'admin', id: command.admin.accountId, role: command.admin.roles.join(',') },
      context: command.context,
      reason: command.reason,
    };
    return this.run(
      { kind: 'admin', command },
      { verb: 'reject', from: 'placed', to: 'rejected' },
      { ...rejectionHash(command), reason: command.reason },
      now,
      (order) => this.rejection(order, command, change, now),
    );
  }

  // CU §11.4: the customer cancels their own order while the restaurant has
  // not answered, with a reason of Content's customer_cancel list (AP
  // Appendix B) and the text «سبب آخر» takes. No food was prepared, no strike
  // applies and the restaurant's unanswered count is left alone (only the
  // automatic cancellation counts). Once the order left placed (the race
  // with acceptance) it answers order_state_changed with the order as it is
  // now. 400 unknown_reason, reason_note_required, reason_note_not_allowed.
  async cancelByCustomer(
    command: CustomerCommand & { reason: string; note: string | null },
    now: Date,
  ): Promise<OrderView> {
    return this.run(
      { kind: 'customer', command },
      { verb: 'cancel', from: 'placed', to: 'cancelled' },
      { reason: command.reason, note: command.note },
      now,
      async () => {
        let chosen: { code: string; note: string | null };
        try {
          chosen = await this.content.choose('customer_cancel', {
            code: command.reason,
            note: command.note,
          });
        } catch (error) {
          if (!(error instanceof ContentRefusedError)) throw error;
          const refusal =
            error.refusal === 'reason_note_required' || error.refusal === 'reason_note_not_allowed'
              ? error.refusal
              : 'unknown_reason';
          throw new OrderCommandRefusedError(refusal, error.message);
        }
        return {
          // CU §11.9 «ألغيت طلبك»: no customer text of a reason.
          set: {
            cancelledAt: now,
            cancelReason: chosen.code,
            cancelCustomerText: null,
            foodPrepared: false,
          },
          publicReason: chosen.code,
          ...(chosen.note === null ? {} : { eventReason: chosen.note }),
        };
      },
    );
  }

  private async rejection(
    order: OrderAtStart,
    rejection: Rejection,
    change: MerchantChange,
    now: Date,
  ): Promise<Change> {
    const view = await this.read(order);
    const problem = rejectionProblem(
      rejection,
      view.lines.map((line) => line.itemId),
    );
    if (problem !== null) {
      throw problem === 'unknown_reason'
        ? new OrderCommandRefusedError('unknown_reason', `${rejection.code} is not a reason`)
        : new OrderCommandRefusedError('invalid_rejection', problem);
    }
    const reason = rejection.code as RejectionReason;
    let label: string;
    try {
      ({ label } = await this.content.choose('merchant_rejection', { code: reason, note: null }));
    } catch (error) {
      if (!(error instanceof ContentRefusedError)) throw error;
      throw new OrderCommandRefusedError('unknown_reason', error.message);
    }
    const names = [
      ...new Set(
        view.lines
          .filter((line) => rejection.items.some((item) => item.itemId === line.itemId))
          .map((line) => line.name),
      ),
    ];
    const customerText = (await this.content.customerText('merchant_rejection', reason)).replace(
      '{الأصناف}',
      names.join('، '),
    );
    if (rejection.busyExtraMin !== null) {
      const options = await this.settings.get('merchant.busy_extra_options_min', {
        cityId: order.cityId,
      });
      if (!options.includes(rejection.busyExtraMin)) {
        throw new OrderCommandRefusedError(
          'invalid_rejection',
          `busy mode adds one of ${options.join(', ')} minutes`,
        );
      }
    }
    const ends = new Map<string, Date | null>();
    for (const until of new Set(rejection.items.map((item) => item.until))) {
      ends.set(until, await this.merchants.switchedOffUntil(order.restaurantId, until, now));
    }
    const { restaurantId } = order;
    return {
      set: {
        rejectedAt: now,
        rejectReason: reason,
        rejectReasonLabel: label,
        rejectCustomerText: customerText,
        rejectItemIds: rejection.items.map((item) => item.itemId),
      },
      publicReason: reason,
      effects: async (tx) => {
        if (reason === 'item_unavailable') {
          const switches = rejection.items.map((item) => ({
            itemId: item.itemId,
            until: ends.get(item.until) ?? null,
          }));
          await this.merchants.switchOffForRejection(tx, restaurantId, switches, change, now);
        } else if (reason === 'restaurant_closed') {
          await this.status.afterRejection(tx, restaurantId, { pauseMin: null }, change, now);
        } else if (rejection.busyExtraMin !== null) {
          const effect = { busyExtraMin: rejection.busyExtraMin };
          await this.status.afterRejection(tx, restaurantId, effect, change, now);
        } else if (rejection.pauseMin !== null) {
          const effect = { pauseMin: rejection.pauseMin };
          await this.status.afterRejection(tx, restaurantId, effect, change, now);
        }
      },
    };
  }

  // RA §8.5: the acceptance's columns and its search start.
  private async acceptance(order: OrderAtStart, prepMin: number, now: Date): Promise<Change> {
    const { cityId } = order;
    const [floor, ceiling, bufferMin, speedKmh, searchBufferMin, prepLateMin] = await Promise.all([
      this.settings.get('merchant.prep_time_floor_min', { cityId }),
      this.settings.get('merchant.prep_time_ceiling_min', { cityId }),
      this.settings.get('order.eta_buffer_min', { cityId }),
      this.settings.get('order.eta_speed_kmh', { cityId }),
      this.settings.get('dispatch.search_start_buffer_min', { cityId }),
      this.settings.get('order.prep_late_ops_alert_min', { cityId }),
    ]);
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
  }

  // RA §8.8: an accepted order becomes ready, early or late, with no undo.
  // No captain is ever assigned yet, so operations' no-captain moment is set
  // at dispatch.no_captain_after_ready_min (AP §8.3). A ready order has no
  // prep time left, so a search start still ahead moves to now (AP §9.12.6),
  // with its timer.
  async ready(command: MerchantCommand, now: Date): Promise<OrderView> {
    return this.run(
      { kind: 'restaurant', command },
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
    caller: Caller,
    transition: Transition,
    body: object,
    now: Date,
    change: (order: OrderAtStart) => Promise<Change>,
  ): Promise<OrderView> {
    const { command } = caller;
    const accountId =
      caller.kind === 'admin' ? caller.command.admin.accountId : caller.command.accountId;
    const owner =
      caller.kind === 'restaurant'
        ? { restaurantId: caller.command.restaurantId }
        : caller.kind === 'customer'
          ? { customerAccountId: caller.command.accountId }
          : {};
    const key = { accountId, idempotencyKey: command.idempotencyKey };
    const requestHash = commandHash({ verb: transition.verb, orderId: command.orderId, ...body });
    const earlier = await this.replay(this.database.db, key, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const order = await this.find(command.orderId, owner);
    if (order.status !== transition.from) {
      // A repeat sent with the first may read the order after the first
      // committed: it answers the first's order (architecture §5.3).
      const first = await this.replay(this.database.db, key, requestHash, now);
      if (first !== null) return this.read(first);
      throw await this.stateChanged(order);
    }
    const prepared = await change(order);
    const noCaptainAlertMin = prepared.searchStartAt
      ? await this.settings.get('dispatch.no_captain_alert_min', { cityId: order.cityId })
      : 0;
    const publicReason = prepared.publicReason ?? null;

    // pg-boss connects before the lock is taken, never while it is held.
    await this.jobs.ready();
    const outcome = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      // A repeat sent with the first waits on the lock, then answers the
      // first's order.
      const repeat = await this.replay(tx, key, requestHash, now);
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
        actor:
          caller.kind === 'restaurant'
            ? { type: 'restaurant', id: accountId, device: caller.command.deviceId }
            : { type: caller.kind, id: accountId },
        // An operations note stays in the event row and the audit (AP §10).
        reason:
          caller.kind === 'admin' ? caller.command.reason : (prepared.eventReason ?? publicReason),
        publicReason,
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
      await prepared.effects?.(tx);
      if (caller.kind === 'admin') {
        const { admin, context, reason } = caller.command;
        await this.audit.recordWrite(
          {
            actor: { type: 'admin', id: admin.accountId, role: admin.roles.join(',') },
            context,
            cityId: locked.cityId,
            action: `order.${transition.verb}`,
            target: { type: 'order', id: locked.id },
            before: { status: locked.status },
            after: { status: transition.to, ...body, reason: publicReason },
            reason,
          },
          tx,
        );
      }
      await keepKey(tx, accountId, command.idempotencyKey, requestHash, order, now);
      return { done: true as const };
    });
    if (!outcome.done) throw await this.stateChanged(order);
    return this.read(order);
  }

  // The order, read without a lock; the restaurant's own only when a
  // restaurant asks, the customer's own when a customer does: another's or an
  // unknown one is unknown_order.
  private async find(
    orderId: string,
    owner: { restaurantId?: string; customerAccountId?: string },
  ): Promise<OrderAtStart> {
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
      .where(
        and(
          eq(orders.id, orderId),
          owner.restaurantId === undefined
            ? undefined
            : eq(orders.restaurantId, owner.restaurantId),
          owner.customerAccountId === undefined
            ? undefined
            : eq(orders.customerAccountId, owner.customerAccountId),
        ),
      );
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
    key: { accountId: string; idempotencyKey: string },
    requestHash: string,
    now: Date,
  ) {
    try {
      return await replayKey(executor, key.accountId, key.idempotencyKey, requestHash, now);
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
