import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gt, inArray, isNotNull, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import { CaptainsRefusedError, CaptainsService } from '../captains/index.js';
import { CustomersService } from '../customers/index.js';
import { FxService } from '../fx/index.js';
import { LedgerService } from '../ledger/index.js';
import { type Point, straightLineMetres } from '../geo/index.js';
import { CustomerAccountsService, PhoneCipher } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import {
  type ChosenReason,
  ContentRefusedError,
  ContentService,
  type ReasonList,
} from '../content/index.js';
import { openItemReport } from './item-reports.js';
import { frozenAtPickup, unacknowledgedAdditionAt } from './order-edits.js';
import { acceptedPrepMin } from './time-changes.js';
import { CAPTAIN_ACTIVE } from './order-assignments.js';
import { commandHash, IdempotencyKeyReusedError, keepKey, replayKey } from './idempotency-keys.js';
import { lockOrder, type OrderRow, recordTransition } from './order-events.js';
import {
  CANCELLED_AFTER_PLACING_MS,
  orderKey,
  readOrders,
  snapshotOf,
  type OrderView,
} from './order-views.js';
import {
  checkLines,
  lockForPickup,
  type PaymentLine,
  type PickupAutoConfirmJob,
  storedLines,
} from './pickup-booking.js';
import {
  type PickupDisputeView,
  pickupDisputesOf,
  type PickupRequestView,
  pickupRequestsOf,
} from './pickup-views.js';
import { collections, orders, pickupRequests } from './schema.js';
import { type Delivery, DeliveryBooking, lockForDelivery } from './delivery-booking.js';
import { checkDoorPayment, commission, waitingMinutes } from './door-payment.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

const MINUTE_MS = 60_000;
// CA Appendix A: a fix worse than this is a weak signal, «إشارة الموقع ضعيفة —
// اتصل بالعمليات لتسجيل وصولك» (K3); operations record the arrival instead.
export const WEAK_GPS_METRES = 100;
// C6 uses the latest fix: one older than this proves no arrival now (the app
// sends a fix every 10 seconds while online, CA §4.3).
export const FIX_MAX_AGE_MS = 60_000;

export type CaptainOrderRefusal =
  | 'unknown_order'
  | 'order_state_changed'
  | 'too_far_from_restaurant'
  | 'too_far_from_customer'
  | 'weak_location'
  | 'simulated_location'
  | 'stale_location'
  | 'invalid_location'
  | 'not_online'
  | 'invalid_lines'
  | 'currency_not_accepted'
  | 'amount_mismatch'
  // CA §9.7 item 4: the amount due changed since the screen showed it.
  | 'amount_due_changed'
  // «سجّل الباقي الذي أعدته للزبون».
  | 'overpaid'
  // K16: «المبلغ المقبوض أقل من المطلوب بـ {المبلغ}» needs a reason.
  | 'shortfall_reason_required'
  // A reason that is not an active one of its Content list, or «أخرى»
  // without its text, or a text with another reason (AP §9.13).
  | 'unknown_reason'
  | 'reason_note_required'
  | 'reason_note_not_allowed'
  // RA §8.10, §8.12: an open item report blocks the pickup (CA §9 step 2:
  // «بانتظار تعديل الطلب من العمليات»).
  | 'item_report_open'
  // RA §8.10, §8.13: an edit that added items, not yet acknowledged by the
  // restaurant (CA §9 step 2: «بانتظار تأكيد المطعم للتعديل»).
  | 'edit_unacknowledged'
  | 'idempotency_key_reused';

// A command on an order that the order or the captain refuses;
// order_state_changed carries the order as it is now, too_far_from_restaurant
// and too_far_from_customer the distance measured.
export class CaptainOrderRefusedError extends Error {
  override readonly name = 'CaptainOrderRefusedError';
  constructor(
    readonly refusal: CaptainOrderRefusal,
    message: string,
    readonly order: OrderView | null = null,
    readonly distanceMetres: number | null = null,
    // shortfall_reason_required: the missing amount, in the base currency.
    readonly shortfall: { amount: bigint; currency: string } | null = null,
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

// CA §9.10: how long an unacknowledged cancellation card stays.
export const CANCELLED_CARD_MS = 12 * 60 * 60 * 1000;

// CA §9.10: operations cancelled the captain's order.
export interface CaptainCancellation {
  orderId: string;
  number: bigint;
  // The ops_cancel reason's label (owner decision 2026-11-09).
  reason: string;
  cash: 'returned' | 'not_returned' | 'not_paid' | null;
  compensation: { amount: bigint; currency: string } | null;
  at: Date;
}

// The captain's active order (CA §9) with the restaurant it is picked up
// from.
export interface CaptainActiveOrder {
  order: OrderView;
  // CA §9.5: who to deliver to and the number the call button dials.
  customer: { name: string | null; phone: string | null };
  // CA §9.4: the latest pickup request and the restaurant's dispute after
  // the pickup, if any.
  pickupRequest: PickupRequestView | null;
  pickupDispute: PickupDisputeView | null;
  restaurant: { name: string; address: string | null; phone: string | null; location: Point };
  // C6, K4: the radii the arrival and delivery buttons are enabled within.
  radii: { restaurantMetres: number; customerMetres: number };
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
    private readonly customers: CustomersService,
    private readonly customerAccounts: CustomerAccountsService,
    private readonly phones: PhoneCipher,
    private readonly booking: DeliveryBooking,
    private readonly ledger: LedgerService,
    private readonly fx: FxService,
    private readonly content: ContentService,
  ) {}

  // A reason checked against its Content list, before the transaction.
  private async chosen(
    list: ReasonList,
    given: { reason: string; note: string | null },
  ): Promise<ChosenReason> {
    try {
      return await this.content.choose(list, { code: given.reason, note: given.note });
    } catch (error) {
      if (!(error instanceof ContentRefusedError)) throw error;
      const refusal =
        error.refusal === 'reason_note_required' || error.refusal === 'reason_note_not_allowed'
          ? error.refusal
          : 'unknown_reason';
      throw new CaptainOrderRefusedError(refusal, error.message);
    }
  }

  // CA §9.10 (slice 2.8b): the captain's latest order operations cancelled
  // (only their path keeps the label) within CANCELLED_CARD_MS that the
  // captain has not acknowledged, for the card «أُلغيت المهمة: {السبب}» with
  // the cash instruction and «تعويض: {المبلغ}»; null otherwise. An offered
  // captain never had the order, so gets none.
  async cancelled(captainId: string, now: Date): Promise<CaptainCancellation | null> {
    const [row] = await this.database.db
      .select({
        orderId: orders.id,
        number: orders.number,
        label: orders.cancelReasonLabel,
        cash: orders.cancelCash,
        compensation: orders.cancelCaptainCompensation,
        currency: orders.currency,
        at: orders.cancelledAt,
      })
      .from(orders)
      .where(
        and(
          eq(orders.captainId, captainId),
          eq(orders.status, 'cancelled'),
          isNotNull(orders.cancelReasonLabel),
          isNull(orders.cancelCaptainSeenAt),
          gt(orders.cancelledAt, new Date(now.getTime() - CANCELLED_CARD_MS)),
          gt(
            orders.placedAt,
            new Date(now.getTime() - CANCELLED_CARD_MS - CANCELLED_AFTER_PLACING_MS),
          ),
        ),
      )
      .orderBy(desc(orders.cancelledAt))
      .limit(1);
    if (!row || row.label === null || row.at === null) return null;
    return {
      orderId: row.orderId,
      number: row.number,
      reason: row.label,
      cash: row.cash,
      compensation:
        row.compensation === null ? null : { amount: row.compensation, currency: row.currency },
      at: row.at,
    };
  }

  // CA §9.10 «حسناً» on the cancellation card: the order keeps when the
  // captain saw it, so the card shows no more. Idempotent by its nature (it
  // sets a moment once), it records nothing about the place, so it takes no
  // fix. Another captain's order is unknown_order; one operations did not
  // cancel is order_state_changed.
  async acknowledgeCancellation(captainId: string, orderId: string, now: Date): Promise<void> {
    const [row] = await this.database.db
      .select({
        placedAt: orders.placedAt,
        status: orders.status,
        label: orders.cancelReasonLabel,
        seenAt: orders.cancelCaptainSeenAt,
      })
      .from(orders)
      .where(and(eq(orders.id, orderId), eq(orders.captainId, captainId)));
    if (!row) throw new CaptainOrderRefusedError('unknown_order', 'no such order');
    if (row.status !== 'cancelled' || row.label === null) {
      throw new CaptainOrderRefusedError('order_state_changed', 'not cancelled by operations');
    }
    if (row.seenAt !== null) return;
    await this.database.db
      .update(orders)
      .set({ cancelCaptainSeenAt: now })
      .where(and(orderKey(orderId, row.placedAt), isNull(orders.cancelCaptainSeenAt)));
  }

  // CA §9: the order assigned to the captain until it ends, or null (no
  // stacking in V1, AP §9.12.6).
  async active(captainId: string, now: Date): Promise<CaptainActiveOrder | null> {
    const [order] = await readOrders(
      this.database.db,
      and(eq(orders.captainId, captainId), inArray(orders.status, CAPTAIN_ACTIVE)),
      { newestFirst: true },
    );
    return order ? this.withRestaurant(order, captainId, now) : null;
  }

  // CA §9.2 (C6): «وصلت إلى المطعم», only within
  // captain.merchant_arrival_radius_m of the restaurant by the fix sent,
  // which is recorded (CA §15); a weak, old or simulated fix is refused, and
  // operations record the arrival instead (K3).
  async arrive(
    command: CaptainOrderCommand & { location: CommandLocation },
    now: Date,
  ): Promise<CaptainActiveOrder> {
    // The fix is not part of the command: a retry sends a newer one.
    const requestHash = commandHash({ verb: 'arrive', orderId: command.orderId });
    const earlier = await this.replay(command.accountId, command, requestHash, now);
    if (earlier !== null) return this.answer(earlier, command.captainId, now);
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
    checkFix(command.location, now);
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
    return this.answer(order, command.captainId, now);
  }

  // CA §9.6 (K4): «وصلت» at the customer, after the pickup. Within
  // captain.customer_radius_m of the pin by the fix sent; farther away only
  // with a reason (Appendix C), which also covers the delivery and gives
  // operations «تسليم بعيد عن العنوان». The fix follows the arrival at the
  // restaurant's rules (owner decision 2026-11-06): recent, accurate and not
  // simulated. The order becomes arrived (track at_customer) and the
  // customer sees «الكابتن عند الباب».
  async arriveAtCustomer(
    command: CaptainOrderCommand & { location: CommandLocation; away: AwayGiven | null },
    now: Date,
  ): Promise<CaptainActiveOrder> {
    const requestHash = commandHash({
      verb: 'arrive_at_customer',
      orderId: command.orderId,
      away: command.away,
    });
    const earlier = await this.replay(command.accountId, command, requestHash, now);
    if (earlier !== null) return this.answer(earlier, command.captainId, now);
    const order = await this.captainsOrder(command);
    if (!customerArrivable(order, command.captainId)) {
      throw await this.refusedState(order, command.accountId, command, requestHash, now);
    }
    const radius = await this.settings.get('captain.customer_radius_m', { cityId: order.cityId });
    await this.recordLocation(command.captainId, command.location, now);
    checkFix(command.location, now);
    const distanceMetres = Math.round(straightLineMetres(command.location, order.location));
    const far = distanceMetres > radius;
    if (far && command.away === null) {
      throw new CaptainOrderRefusedError(
        'too_far_from_customer',
        `${distanceMetres} m from the customer, more than ${radius} m`,
        null,
        distanceMetres,
      );
    }
    // Within the radius no reason is needed, and none is kept.
    const away = far && command.away ? await this.chosen('captain_away', command.away) : null;
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      if ((await this.replay(command.accountId, command, requestHash, now, tx)) !== null) {
        return true;
      }
      if (!customerArrivable(locked, command.captainId)) return false;
      const version = locked.version + 1;
      await tx
        .update(orders)
        .set({
          status: 'arrived',
          version,
          captainTrack: 'at_customer',
          arrivedAtCustomerAt: now,
          awayReason: away?.code ?? null,
          awayReasonLabel: away?.label ?? null,
          awayNote: away?.note ?? null,
        })
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
      await recordTransition(tx, this.jobs, locked, {
        type: 'order.arrived_at_customer',
        from: locked.status,
        to: 'arrived',
        version,
        actor: { type: 'captain', id: command.captainId, device: command.deviceId },
        reason: away?.code ?? null,
        // The customer sees «الكابتن عند الباب» only, never the reason.
        publicReason: null,
        at: now,
        captainTrack: 'at_customer',
      });
      await keepKey(tx, command.accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) throw await this.stateChanged(order);
    return this.answer(order, command.captainId, now);
  }

  // CA §9.7–9.8 (C9, K4, K16): «تم التسليم» at the customer with the door
  // payment. Within captain.customer_radius_m of the pin, or with a reason
  // given now or at the arrival. The payment is checked against the amount
  // due the screen showed (AP §8.6); a shortfall needs its reason. The order
  // becomes delivered with outcome normal, its collection and every journal
  // of its money in one transaction (DeliveryBooking), and the captain is
  // free for the next offer. Answers the order summary.
  async deliver(
    command: CaptainOrderCommand &
      DoorCollection & { location: CommandLocation; away: AwayGiven | null },
    now: Date,
  ): Promise<DeliverySummary> {
    const requestHash = commandHash({
      verb: 'deliver',
      orderId: command.orderId,
      ...collectionHash(command),
      away: command.away,
    });
    const earlier = await this.replay(command.accountId, command, requestHash, now);
    if (earlier !== null) return this.summary(earlier, now);
    const order = await this.captainsOrder(command);
    if (!deliverable(order, command.captainId)) {
      throw await this.refusedState(order, command.accountId, command, requestHash, now);
    }
    const delivery = await this.prepareDelivery(order, command, now);
    const radius = await this.settings.get('captain.customer_radius_m', { cityId: order.cityId });
    await this.recordLocation(command.captainId, command.location, now);
    checkFix(command.location, now);
    const distanceMetres = Math.round(straightLineMetres(command.location, order.location));
    const far = distanceMetres > radius;
    if (far && command.away === null && order.awayReason === null) {
      throw new CaptainOrderRefusedError(
        'too_far_from_customer',
        `${distanceMetres} m from the customer, more than ${radius} m`,
        null,
        distanceMetres,
      );
    }
    // K4: a reason given at the arrival covers the delivery and is kept.
    const away =
      far && order.awayReason === null && command.away
        ? await this.chosen('captain_away', command.away)
        : null;
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      if ((await this.replay(command.accountId, command, requestHash, now, tx)) !== null) {
        return true;
      }
      if (!deliverable(locked, command.captainId)) return false;
      const due = await lockForDelivery(tx, locked);
      // An edit since the payment was checked (AP §9.3.3).
      if (due.total !== delivery.amountDue) return false;
      await this.booking.complete(
        tx,
        due,
        delivery,
        {
          actor: { type: 'captain', id: command.captainId, device: command.deviceId },
          reason: null,
        },
        now,
        away,
      );
      await keepKey(tx, command.accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) throw await this.stateChanged(order);
    return this.summary(order, now);
  }

  // AP §9.3.2 «تسجيل التسليم نيابة عن الكابتن»: for a captain without a
  // working phone, operations enter the payment lines and change the captain
  // reports, with a reason; picked_up or arrived. The same checks and entries
  // as the captain's delivery, without a location; audited.
  async recordDelivery(command: AdminOrderCommand & DoorCollection, now: Date): Promise<OrderView> {
    const accountId = command.admin.accountId;
    const requestHash = commandHash({
      verb: 'record_delivery',
      orderId: command.orderId,
      ...collectionHash(command),
      reason: command.reason,
    });
    const earlier = await this.replay(accountId, command, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const order = await this.anyOrder(command.orderId);
    if (!deliverableByOperations(order)) {
      throw await this.refusedState(order, accountId, command, requestHash, now);
    }
    const delivery = await this.prepareDelivery(order, command, now);
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      if ((await this.replay(accountId, command, requestHash, now, tx)) !== null) return true;
      if (!deliverableByOperations(locked) || locked.captainId !== order.captainId) return false;
      const due = await lockForDelivery(tx, locked);
      // An edit since the payment was checked (AP §9.3.3).
      if (due.total !== delivery.amountDue) return false;
      await this.booking.complete(
        tx,
        due,
        delivery,
        { actor: { type: 'admin', id: accountId }, reason: command.reason },
        now,
        null,
      );
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: accountId, role: command.admin.roles.join(',') },
          context: command.context,
          cityId: locked.cityId,
          action: 'order.record_delivery',
          target: { type: 'order', id: locked.id },
          before: { status: locked.status },
          after: {
            status: 'delivered',
            outcome: 'normal',
            receivedLines: storedLines(command.received),
            changeLines: storedLines(command.change),
            shortfall: delivery.payment.shortfall.toString(),
          },
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

  // The door payment checked and the order's money worked out before the
  // transaction (AP §8.1 item 4); an edit after the pickup (AP §9.3.3) changes
  // the total, which the transaction compares again.
  private async prepareDelivery(
    order: OrderAtStart,
    collection: DoorCollection,
    now: Date,
  ): Promise<Delivery> {
    const base = snapshotOf(order.rateSnapshot).baseCurrency;
    if (collection.amountDue.amount !== order.total || collection.amountDue.currency !== base) {
      throw new CaptainOrderRefusedError(
        'amount_due_changed',
        'the amount due changed',
        await this.read(order),
      );
    }
    const payment = checkDoorPayment(
      snapshotOf(order.rateSnapshot),
      collection.received,
      collection.change,
      order.total,
    );
    if (typeof payment === 'string') {
      throw new CaptainOrderRefusedError(payment, 'the payment lines do not fit the amount due');
    }
    if (payment.shortfall > 0n && collection.shortfall === null) {
      throw new CaptainOrderRefusedError(
        'shortfall_reason_required',
        'the net received is short of the amount due',
        null,
        null,
        { amount: payment.shortfall, currency: base },
      );
    }
    if (order.captainId === null) throw new Error(`order ${order.id} has no captain`);
    const [money] = await this.database.db
      .select({
        payTableId: orders.payTableId,
        tripMetres: orders.tripMetres,
        commissionBp: orders.commissionBp,
        acceptedAt: orders.acceptedAt,
        prepMin: orders.prepMin,
        arrivedAtMerchantAt: orders.arrivedAtMerchantAt,
        captainWaitingAlertAt: orders.captainWaitingAlertAt,
        pickedUpAt: orders.pickedUpAt,
        testOrder: orders.testOrder,
        deliveryFee: orders.deliveryFee,
      })
      .from(orders)
      .where(orderKey(order.id, order.placedAt));
    const captain = await this.captains.captain(order.captainId, now);
    if (!money?.acceptedAt || money.prepMin === null || !money.pickedUpAt) {
      throw new Error(`order ${order.id} was not picked up`);
    }
    if (!captain) throw new Error(`captain ${order.captainId} not found`);
    // Placing needs a pay table in force (captain_pay_unset); only an order
    // placed before slice 1.13 can lack one.
    if (money.payTableId === null) throw new Error(`order ${order.id} kept no pay table`);
    const waiting = waitingMinutes({
      acceptedAt: money.acceptedAt,
      // docs/domain/04 (slice 2.9, to confirm with the owner): «تعديل الوقت»
      // never shortens the captain's paid waiting; it counts from the prep
      // time chosen at acceptance.
      prepMin: (await acceptedPrepMin(this.database.db, order)) ?? money.prepMin,
      arrivedAtMerchantAt: money.arrivedAtMerchantAt,
      captainWaitingAlertAt: money.captainWaitingAlertAt,
      pickedUpAt: money.pickedUpAt,
    });
    const pay = await this.captains.payParts(
      money.payTableId,
      captain.vehicle,
      money.tripMetres ?? 0,
      waiting,
    );
    if (!pay) throw new Error(`pay table ${money.payTableId} has no rate for ${captain.vehicle}`);
    const frozen = await frozenAtPickup(this.database.db, {
      id: order.id,
      placedAt: order.placedAt,
      itemsValue: order.itemsValue,
      deliveryFee: money.deliveryFee,
    });
    return {
      received: collection.received,
      change: collection.change,
      payment,
      // A reason sent without a shortfall is not kept.
      shortfall:
        payment.shortfall > 0n && collection.shortfall
          ? await this.chosen('shortfall', collection.shortfall)
          : null,
      pay,
      waitingMinutes: waiting,
      // AP §9.6.3: a test order, flagged at placing, posts no commission.
      commission: money.testOrder ? null : commission(frozen.itemsValue, money.commissionBp),
      commissionToClearing: money.testOrder ? 0n : frozen.commissionToClearing,
      deliveryFee: frozen.deliveryFee,
      amountDue: order.total,
    };
  }

  // CA §9.8: «ربحت من هذا الطلب», «تغيّرت عهدتك» and «عليك تسليم اليوم»,
  // from the order's collection.
  private async summary(key: { id: string; placedAt: Date }, now: Date): Promise<DeliverySummary> {
    const [row] = await this.database.db
      .select({
        number: orders.number,
        currency: orders.currency,
        itemsValue: orders.itemsValue,
        deliveryFee: orders.deliveryFee,
        captainId: collections.captainId,
        netReceived: collections.netReceived,
        basePay: collections.basePay,
        distancePay: collections.distancePay,
        topUpPay: collections.topUpPay,
        waitingPay: collections.waitingPay,
      })
      .from(collections)
      .innerJoin(
        orders,
        and(eq(orders.id, collections.orderId), eq(orders.placedAt, collections.orderPlacedAt)),
      )
      .where(and(eq(collections.orderId, key.id), eq(collections.orderPlacedAt, key.placedAt)));
    if (!row) throw new Error(`order ${key.id} has no collection`);
    // The pickup payment, which an edit after the pickup leaves as it was.
    const paid = (await frozenAtPickup(this.database.db, { ...key, ...row })).itemsValue;
    const orderPay = row.basePay + row.distancePay + row.topUpPay;
    return {
      orderId: key.id,
      number: row.number,
      currency: row.currency,
      pay: {
        base: row.basePay,
        distance: row.distancePay,
        topUp: row.topUpPay,
        waiting: row.waitingPay,
        total: orderPay + row.waitingPay,
      },
      custodyChange: row.netReceived - paid,
      handInToday: await this.custodyTotal(row.captainId, now),
    };
  }

  // CA §9.8, §10.2: «عليك تسليم اليوم», the captain's custody in every
  // currency at current rates, in the base; below zero the desk owes the
  // captain («لك عند المكتب»).
  private async custodyTotal(
    captainId: string,
    now: Date,
  ): Promise<{ amount: bigint; currency: string }> {
    const captain = await this.captains.captain(captainId, now);
    if (!captain) throw new Error(`captain ${captainId} not found`);
    const [accounts, { base, toBase }] = await Promise.all([
      this.ledger.ownerAccounts(captain.cityId, captainId, 'captain.custody'),
      this.fx.currentValue(captain.cityId),
    ]);
    let total = 0n;
    for (const account of accounts) {
      const { amount } = await this.ledger.balance(account.id);
      total +=
        account.currency === base || amount === 0n ? amount : toBase(amount, account.currency);
    }
    return { amount: total, currency: base };
  }

  // CA §9.4, RA §8.10 items 1-2: «دفعت للمطعم واستلمت الطلب» with the lines
  // the captain paid, at the restaurant (track at_merchant), checked against
  // the pickup payment (AP §8.1). It opens the request (track
  // pickup_pending) with its automatic confirmation after
  // order.pickup_confirm_timeout_sec. The item check (C7) is the app's: the
  // payment section appears only once every item is ticked.
  async requestPickup(
    command: CaptainOrderCommand & { lines: PaymentLine[]; location: CommandLocation },
    now: Date,
  ): Promise<CaptainActiveOrder> {
    const requestHash = commandHash({
      verb: 'request_pickup',
      orderId: command.orderId,
      lines: storedLines(command.lines),
    });
    const earlier = await this.replay(command.accountId, command, requestHash, now);
    if (earlier !== null) return this.answer(earlier, command.captainId, now);
    const order = await this.captainsOrder(command);
    if (!requestable(order, command.captainId)) {
      throw await this.refusedState(order, command.accountId, command, requestHash, now);
    }
    const refusal = checkLines(snapshotOf(order.rateSnapshot), command.lines, order.itemsValue);
    if (refusal !== null) {
      throw new CaptainOrderRefusedError(refusal, 'the payment lines do not match the pickup');
    }
    const timeoutSec = await this.settings.get('order.pickup_confirm_timeout_sec', {
      cityId: order.cityId,
    });
    await this.recordLocation(command.captainId, command.location, now);
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await lockForPickup(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      if ((await this.replay(command.accountId, command, requestHash, now, tx)) !== null) {
        return true;
      }
      if (!requestable(locked, command.captainId)) return false;
      if ((await openItemReport(tx, order.id, order.placedAt)) !== null) {
        throw new CaptainOrderRefusedError('item_report_open', 'an item report is open');
      }
      if ((await unacknowledgedAdditionAt(tx, order.id, order.placedAt)) !== null) {
        throw new CaptainOrderRefusedError(
          'edit_unacknowledged',
          'the restaurant has not acknowledged an edit that added items',
        );
      }
      const confirmBy = new Date(now.getTime() + timeoutSec * 1000);
      const [request] = await tx
        .insert(pickupRequests)
        .values({
          orderId: order.id,
          orderPlacedAt: order.placedAt,
          cityId: locked.cityId,
          captainId: command.captainId,
          // RA §8.10 item 2: always the order's current pickup payment.
          currency: locked.currency,
          amount: locked.itemsValue,
          lines: storedLines(command.lines),
          openedAt: now,
          confirmBy,
          status: 'open',
        })
        .returning({ id: pickupRequests.id });
      const version = locked.version + 1;
      await tx
        .update(orders)
        .set({ version, captainTrack: 'pickup_pending' })
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
      await recordTransition(tx, this.jobs, locked, {
        type: 'order.pickup_requested',
        from: locked.status,
        to: locked.status,
        version,
        actor: { type: 'captain', id: command.captainId, device: command.deviceId },
        reason: null,
        at: now,
        captainTrack: 'pickup_pending',
      });
      const job: PickupAutoConfirmJob = {
        requestId: request!.id,
        orderId: order.id,
        placedAt: order.placedAt.toISOString(),
      };
      await this.jobs.send(QUEUES.pickupAutoConfirm, job, {
        startAfter: confirmBy,
        db: inTransaction(tx),
      });
      await keepKey(tx, command.accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) throw await this.stateChanged(order);
    return this.answer(order, command.captainId, now);
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
      publicReason: null,
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
        itemsValue: orders.itemsValue,
        total: orders.total,
        awayReason: orders.awayReason,
        rateSnapshot: orders.rateSnapshot,
        latitude: sql<number>`ST_Y(${orders.location})`.mapWith(Number),
        longitude: sql<number>`ST_X(${orders.location})`.mapWith(Number),
      })
      .from(orders)
      .where(eq(orders.id, orderId));
    if (!order) throw new CaptainOrderRefusedError('unknown_order', 'no such order');
    const { latitude, longitude, ...rest } = order;
    return { ...rest, location: { latitude, longitude } };
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
    captainId: string,
    now: Date,
  ): Promise<CaptainActiveOrder> {
    return this.withRestaurant(await this.read(key), captainId, now);
  }

  private async withRestaurant(
    order: OrderView,
    captainId: string,
    now: Date,
  ): Promise<CaptainActiveOrder> {
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const [requests, disputes, customer, restaurantMetres, customerMetres] = await Promise.all([
      pickupRequestsOf(this.database.db, [order]),
      pickupDisputesOf(this.database.db, [order]),
      this.customerOf(order, captainId),
      this.settings.get('captain.merchant_arrival_radius_m', { cityId: order.cityId }),
      this.settings.get('captain.customer_radius_m', { cityId: order.cityId }),
    ]);
    return {
      order,
      customer,
      pickupRequest: requests.get(order.id)?.[0] ?? null,
      pickupDispute: disputes.get(order.id) ?? null,
      restaurant: {
        name: restaurant.nameAr,
        address: restaurant.address,
        phone: restaurant.phone,
        location: restaurant.location,
      },
      radii: { restaurantMetres, customerMetres },
    };
  }

  // CA §9.5 (C2, C10): the recipient's name when the order is for someone
  // else, else the customer's first name; the address's contact number, else
  // the account's own, for «اتصال بالزبون» and «واتساب الزبون».
  // C10: the buttons work only while the order is active, so a command
  // replayed once the order ended or left the captain answers no number.
  private async customerOf(
    order: OrderView,
    captainId: string,
  ): Promise<CaptainActiveOrder['customer']> {
    const [row] = await this.database.db
      .select({ contactPhoneEncrypted: orders.contactPhoneEncrypted })
      .from(orders)
      .where(orderKey(order.id, order.placedAt));
    const [names, phone] = await Promise.all([
      order.address.recipientName === null
        ? this.customers.firstNames([order.customerAccountId])
        : null,
      order.captainId !== captainId || !CAPTAIN_ACTIVE.includes(order.status)
        ? null
        : row?.contactPhoneEncrypted
          ? this.phones.decrypt(row.contactPhoneEncrypted)
          : this.customerAccounts.phone(order.customerAccountId),
    ]);
    return {
      name: order.address.recipientName ?? names?.get(order.customerAccountId) ?? null,
      phone,
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

// RA §8.10 rules: accepted or ready, the assigned captain at the restaurant
// with no open request (the track would be pickup_pending). The blocks of an
// item-unavailable report and an unacknowledged edit come with them.
function requestable(
  order: Pick<OrderAtStart, 'status' | 'captainTrack' | 'captainId'>,
  captainId: string,
): boolean {
  return (
    (order.status === 'accepted' || order.status === 'ready') &&
    order.captainTrack === 'at_merchant' &&
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
  itemsValue: bigint;
  total: bigint;
  rateSnapshot: unknown;
  // The customer's pin, and the reason given at the arrival away from it.
  location: Point;
  awayReason: string | null;
};

// The door payment a delivery records (AP §8.6, CA §9.7): the lines
// received and given back, the amount due the screen showed, and the reason
// of a shortfall (K16).
export interface DoorCollection {
  received: PaymentLine[];
  change: PaymentLine[];
  amountDue: { amount: bigint; currency: string };
  // K16: the reason's code in Content's shortfall list.
  shortfall: { reason: string; note: string | null } | null;
}

function collectionHash(collection: DoorCollection) {
  return {
    received: storedLines(collection.received),
    change: storedLines(collection.change),
    amountDue: {
      amount: collection.amountDue.amount.toString(),
      currency: collection.amountDue.currency,
    },
    shortfall: collection.shortfall,
  };
}

// CA §9.8: the order summary, in the base currency's minor units. The peak
// bonus waits for the peak windows (owner decision 2026-11-06).
export interface DeliverySummary {
  orderId: string;
  number: bigint;
  currency: string;
  pay: { base: bigint; distance: bigint; topUp: bigint; waiting: bigint; total: bigint };
  // The collection's net minus the pickup payment.
  custodyChange: bigint;
  // The positive custody positions now, converted at current rates.
  handInToday: { amount: bigint; currency: string };
}

// CA §9.8: the order's captain at the customer (AP §8.1: arrived →
// delivered by the captain).
function deliverable(
  order: Pick<OrderAtStart, 'status' | 'captainTrack' | 'captainId'>,
  captainId: string,
): boolean {
  return (
    order.status === 'arrived' &&
    order.captainTrack === 'at_customer' &&
    order.captainId === captainId
  );
}

// AP §9.3.2: operations record a delivery from picked_up or arrived.
function deliverableByOperations(
  order: Pick<OrderAtStart, 'status' | 'captainTrack' | 'captainId'>,
): boolean {
  return (
    order.captainId !== null &&
    ((order.status === 'picked_up' && order.captainTrack === 'picked_up') ||
      (order.status === 'arrived' && order.captainTrack === 'at_customer'))
  );
}

// The reason given away from the customer's pin (CA Appendix C), with its
// text for «أخرى».
export interface AwayGiven {
  // The code in Content's captain_away list.
  reason: string;
  note: string | null;
}

// CA §9.6: the order's captain on the way to the customer, after the pickup.
function customerArrivable(
  order: Pick<OrderAtStart, 'status' | 'captainTrack' | 'captainId'>,
  captainId: string,
): boolean {
  return (
    order.status === 'picked_up' &&
    order.captainTrack === 'picked_up' &&
    order.captainId === captainId
  );
}

// C6, K3, CA §9.6: a fix proves where the captain is only when it is real,
// recent and accurate enough; otherwise operations record the step.
function checkFix(location: CommandLocation, now: Date): void {
  if (location.simulated) {
    throw new CaptainOrderRefusedError('simulated_location', 'a simulated location');
  }
  if (now.getTime() - location.recordedAt.getTime() > FIX_MAX_AGE_MS) {
    throw new CaptainOrderRefusedError('stale_location', 'the fix is not recent');
  }
  if (location.accuracyMetres > WEAK_GPS_METRES) {
    throw new CaptainOrderRefusedError('weak_location', 'the location is not accurate enough');
  }
}
