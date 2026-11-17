import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, desc, eq, gt, gte, inArray, isNotNull, isNull, lt, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { CaptainsService } from '../captains/index.js';
import {
  type CustomersRefusal,
  CustomersRefusedError,
  CustomersService,
  customerOrderLock,
  type UnsavedAddressFields,
} from '../customers/index.js';
import { FxRefusedError, FxService, type RateSnapshot } from '../fx/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PromoCodeUsesService } from '../marketing/index.js';
import { SettingsService } from '../settings/index.js';
import { ActiveOrders, UNTIL_ENDED } from './active-orders.js';
import { recordTransition } from './order-events.js';
import type { AutoCancelJob } from './order-timers.js';
import { EmergencyStops } from './emergency-stop.js';
import { type Quote, type QuoteRequest, QuoteRefusedError, QuoteService } from './quote.service.js';
import { CANCELLED_AFTER_PLACING_MS, orderKey, readOrders, type OrderView } from './order-views.js';
import { commandHash, IdempotencyKeyReusedError, keepKey, replayKey } from './idempotency-keys.js';
import { frozenAtPickup } from './order-edits.js';
import { ownerMoney, type OwnerMoney } from './owner-money.js';
import type { CostOrder } from './platform-costs.js';
import {
  collections,
  orderLines,
  orderNumbers,
  orderOutcomeRows,
  orders,
  pickupRequests,
} from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Executor = Pick<NodePgDatabase, 'select'>;

// AP §4.8: a city's first order number (owner decision 2026-11-06).
export const FIRST_ORDER_NUMBER = 10001n;

export type OrderRefusal =
  | 'unknown_restaurant'
  | 'quote_changed'
  | 'order_blocked'
  | 'idempotency_key_reused'
  | Extract<CustomersRefusal, 'unknown_address' | 'outside_zones'>;

// A command the ordering module refuses; quote_changed and order_blocked
// carry the new quote, which shows what changed or what blocks (CU §10.7).
export class OrderRefusedError extends Error {
  override readonly name = 'OrderRefusedError';
  constructor(
    readonly refusal: OrderRefusal,
    message: string,
    readonly quote: Quote | null = null,
  ) {
    super(message);
  }
}

// RA §12.2 «قبضت اليوم من الكباتن» (slice 2.19d): a pickup confirmed since a
// moment, with the lines booked (the captain's when none were).
export interface RestaurantPickup {
  orderId: string;
  number: bigint;
  at: Date;
  captainId: string;
  currency: string;
  amount: bigint;
  lines: { currency: string; amount: bigint }[];
}

// An order is picked up within days of its placing: the read bounds
// `placed_at` by this much before the moment, so the partitions prune.
const PICKED_UP_AFTER_PLACING_MS = 2 * 24 * 60 * 60_000;

// CA §9.8, §10.6: a delivered order's pay as the collection recorded it.
// The restaurant's weekly statement (slice 2.19a): an order's number and
// its confirmed pickup payment, null without one.
export interface OrderPickup {
  number: bigint;
  pickup: {
    currency: string;
    amount: bigint;
    lines: { currency: string; amount: bigint }[];
  } | null;
}

export interface OrderPayParts {
  basePay: bigint;
  distancePay: bigint;
  topUpPay: bigint;
  waitingPay: bigint;
  peakBonus: bigint;
}

// CU §10.7 item 5: the command carries the quote version, the address, the
// notes and the pay-in currency; the delivery point is the address pin.
export interface PlaceOrder {
  accountId: string;
  idempotencyKey: string;
  quoteVersion: string;
  request: Omit<QuoteRequest, 'location' | 'customerAccountId'>;
  address: { addressId: string } | { fields: UnsavedAddressFields };
  note: string | null;
}

// A check the transaction failed (a limit reached, the rates changed since
// the quote): the quote is run again after the rollback and shows it.
// RA §8.14: how long an unacknowledged cancellation stays on the board.
export const CANCELLATION_RING_MS = 24 * 60 * 60 * 1000;

class Requote extends Error {}

// The order and its placing (architecture §4.2, §5.5; CU §10.7). The quote is
// re-run first, through the pool, so a placing never holds a connection while
// it waits for another; then one transaction takes the customer's and the
// restaurant's locks, counts both limits, takes the rate snapshot and numbers
// the order.
// How long before a period an order delivered in it may have been placed
// (an order is delivered within hours; two days spare).
const DELIVERED_LOOKBACK_MS = 2 * 86_400_000;

// The orders delivered in a period, in one currency (`deliveredTotals`).
export interface DeliveredTotals {
  currency: string;
  count: number;
  gmv: bigint;
  itemsValue: bigint;
}

@Injectable()
export class OrdersService implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly quotes: QuoteService,
    private readonly activeOrders: ActiveOrders,
    private readonly customers: CustomersService,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly fx: FxService,
    private readonly settings: SettingsService,
    private readonly jobs: Jobs,
    private readonly emergencyStops: EmergencyStops,
    private readonly promoCodes: PromoCodeUsesService,
  ) {}

  // RA §7.4: the restaurant is busy at its maximum active orders.
  onModuleInit(): void {
    this.merchants.countActiveOrders((restaurantId) => this.activeOrders.restaurant(restaurantId));
    // AP §9.8 (slice 2.25a): the panel's customer profile.
    this.customers.useOrderFacts(async (accountId, cityId) => {
      const rules = await this.activeOrders.rules(cityId);
      const [limit, fakeOrders] = await Promise.all([
        this.activeOrders.customer(accountId, rules),
        this.activeOrders.fakeOrders(accountId),
      ]);
      return {
        trusted: limit.trusted,
        delivered: limit.delivered,
        trustedAfter: rules.trustedAfter,
        fakeOrders,
      };
    });
  }

  async place(command: PlaceOrder, now: Date): Promise<OrderView> {
    const requestHash = hashOf(command);
    const earlier = await this.replay(this.database.db, command, requestHash, now);
    if (earlier !== null) return this.placed(earlier);
    try {
      return await this.placeOnce(command, requestHash, now);
    } catch (error) {
      // A repeat sent with the first can be refused by what the first
      // changed (its restaurant now busy, the customer at the limit): it
      // answers the first's order (architecture §5.3).
      if (error instanceof OrderRefusedError && error.refusal !== 'idempotency_key_reused') {
        const placed = await this.replay(this.database.db, command, requestHash, now);
        if (placed !== null) return this.placed(placed);
      }
      throw error;
    }
  }

  private async placeOnce(command: PlaceOrder, requestHash: string, now: Date) {
    const address = await this.orderAddress(command);
    const request: QuoteRequest = {
      ...command.request,
      location: address.location,
      customerAccountId: command.accountId,
    };
    const priced = await this.price(request, now);
    const { quote, restaurant } = priced;
    if (quote.problems.length > 0) {
      throw new OrderRefusedError('order_blocked', 'a problem blocks ordering', quote);
    }
    if (quote.version !== command.quoteVersion) {
      throw new OrderRefusedError('quote_changed', 'the quote changed', quote);
    }
    // Without problems the city has its rates and fee rule (CU §10.6).
    const snapshot = priced.snapshot!;
    const feeRuleId = priced.feeRuleId!;
    const commissionBp = restaurant.commissionBp;
    if (commissionBp === null) {
      throw new Error(`restaurant ${restaurant.id} has no commission in effect`);
    }
    const { cityId } = restaurant;
    const [rules, payTable, acceptAlertMin, autoCancelMin] = await Promise.all([
      this.activeOrders.rules(cityId),
      this.captains.payTable(cityId, now),
      this.settings.get('order.merchant_accept_alert_min', { cityId }),
      this.settings.get('order.merchant_auto_cancel_min', { cityId }),
    ]);

    // The quote's captain_pay_unset checked it just before.
    if (payTable === null) throw new Error(`city ${cityId} has no pay table in force`);

    // RA §8.2–8.3: the restaurant is late from the first, and the
    // countdown ends when the job runs.
    const acceptAlertAt = new Date(now.getTime() + acceptAlertMin * 60_000);
    const autoCancelAt = new Date(now.getTime() + autoCancelMin * 60_000);

    // pg-boss connects before the locks are taken, never while they are held.
    await this.jobs.ready();
    let placed: { id: string; placedAt: Date };
    try {
      placed = await this.database.db.transaction(async (tx) => {
        // The customer's lock first, then the restaurant's, so two placings
        // never wait on each other in turn.
        await lock(tx, customerOrderLock(command.accountId));
        const repeat = await this.replay(tx, command, requestHash, now);
        if (repeat !== null) return repeat;
        if ((await this.activeOrders.customer(command.accountId, rules, tx)).reached) {
          throw new Requote('the customer reached the active-order limit');
        }
        // docs/domain/08: a review stop opened since the quote (it opens
        // under this lock) refuses the order.
        if (await this.customers.reviewStopped(command.accountId, tx)) {
          throw new Requote('the account is stopped for review');
        }
        // AP §9.8: a block started since the quote (it starts under this
        // lock) refuses the order.
        if ((await this.customers.activeBlock(command.accountId, now, tx)) !== null) {
          throw new Requote('the account is blocked');
        }
        // AP §8.8: dues charged since the quote (a block «حتى دفع مستحق»
        // charges them under this lock) refuse the order.
        if ((await this.customers.dues(cityId, command.accountId, tx)) !== null) {
          throw new Requote('the customer owes dues');
        }
        await lock(tx, `orders:restaurant:${restaurant.id}`);
        if (
          restaurant.maxActiveOrders !== null &&
          (await this.activeOrders.restaurant(restaurant.id, tx)) >= restaurant.maxActiveOrders
        ) {
          throw new Requote('the restaurant reached its maximum active orders');
        }
        // AP §9.1.6: a stop started since the quote refuses the order.
        if (await this.emergencyStops.stopsOrders(tx, cityId)) {
          throw new Requote('the emergency stop started');
        }

        // AP §8.6: the rates the order keeps are the ones it was priced with.
        const kept = await this.fx.snapshotForOrder(cityId, tx).catch((error: unknown) => {
          if (error instanceof FxRefusedError) throw new Requote(error.message);
          throw error;
        });
        if (rateKey(kept) !== rateKey(snapshot)) throw new Requote('the rates changed');

        // CU §10.4, §10.7: the code is held again under its lock; one that
        // stopped working since the quote (its last use or its day's budget
        // taken) refuses the order with the new quote.
        const code = priced.code;
        const held = code === null ? null : await this.promoCodes.hold(tx, code.cart, now);
        if (
          code !== null &&
          (held === null ||
            !held.applied ||
            held.code.discount.total !== code.applied.discount.total ||
            held.code.discount.merchant !== code.applied.discount.merchant)
        ) {
          throw new Requote('the code stopped working');
        }

        // Last, so the city's number row is held briefly and a refused order
        // leaves no gap.
        const [{ number }] = (await tx
          .insert(orderNumbers)
          .values({ cityId, lastNumber: FIRST_ORDER_NUMBER })
          .onConflictDoUpdate({
            target: orderNumbers.cityId,
            set: { lastNumber: sql`${orderNumbers.lastNumber} + 1` },
          })
          .returning({ number: orderNumbers.lastNumber })) as [{ number: bigint }];
        const { latitude, longitude } = address.location;
        const [{ id }] = (await tx
          .insert(orders)
          .values({
            placedAt: now,
            cityId,
            number,
            customerAccountId: command.accountId,
            restaurantId: restaurant.id,
            status: 'placed',
            version: 1,
            captainTrack: null,
            captainId: null,
            currency: snapshot.baseCurrency,
            ...quote.money,
            ...(code && {
              discountMerchant: code.applied.discount.merchant,
              promoCodeId: code.applied.codeId,
              promoCode: code.applied.code,
              promoTerms: plain(code.applied.terms),
            }),
            deliveryFree: quote.deliveryFree,
            feeRuleId,
            commissionBp,
            payTableId: payTable.id,
            // AP §9.6.3: a test restaurant's order, flagged for its money and
            // the reports.
            testOrder: restaurant.accountStatus === 'test',
            rateSnapshot: plain(kept),
            payIn: quote.payIn?.currency ?? null,
            note: command.note,
            acceptAlertAt,
            autoCancelAt,
            estimateFromMin: quote.estimate.fromMin,
            estimateToMin: quote.estimate.toMin,
            tripSeconds: priced.trip.seconds,
            tripMetres: priced.trip.metres,
            addressId: address.addressId,
            location: sql`ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)`,
            zoneId: address.zone.id,
            neighbourhood: address.zone.name,
            label: address.label,
            customLabel: address.customLabel,
            street: address.street,
            floor: address.floor,
            landmark: address.landmark,
            contactPhoneEncrypted: address.contactPhoneEncrypted,
            recipientName: address.recipientName,
            directions: address.directions,
          })
          .returning({ id: orders.id })) as [{ id: string }];
        await tx.insert(orderLines).values(
          quote.lines.map((line, position) => ({
            orderId: id,
            orderPlacedAt: now,
            position,
            cityId,
            itemId: line.itemId,
            itemName: line.name!,
            quantity: line.quantity,
            options: plain(line.options),
            unitPrice: line.unitPrice!,
            lineTotal: line.lineTotal!,
            note: line.note,
          })),
        );
        await held?.record?.({ id, placedAt: now });
        await recordTransition(
          tx,
          this.jobs,
          {
            id,
            placedAt: now,
            cityId,
            number,
            restaurantId: restaurant.id,
            customerAccountId: command.accountId,
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
            actor: { type: 'customer', id: command.accountId },
            reason: null,
            at: now,
          },
        );
        // AP §8.3: the timer exists exactly when the placed order does.
        const job: AutoCancelJob = { orderId: id, placedAt: now.toISOString(), version: 1 };
        await this.jobs.send(QUEUES.merchantAutoCancel, job, {
          startAfter: autoCancelAt,
          db: inTransaction(tx),
        });
        await keepKey(
          tx,
          command.accountId,
          command.idempotencyKey,
          requestHash,
          { id, placedAt: now },
          now,
        );
        return { id, placedAt: now };
      });
    } catch (error) {
      if (!(error instanceof Requote)) throw error;
      const { quote: fresh } = await this.price(request, now);
      throw fresh.problems.length > 0
        ? new OrderRefusedError('order_blocked', error.message, fresh)
        : new OrderRefusedError('quote_changed', error.message, fresh);
    }
    return this.placed(placed);
  }

  // The order the command placed, the answer of the command and of its
  // repeats: its money, lines and address never change; its status may have
  // moved on since.
  private async placed({ id, placedAt }: { id: string; placedAt: Date }): Promise<OrderView> {
    const [order] = await readOrders(this.database.db, orderKey(id, placedAt));
    if (!order) throw new Error(`order ${id} not found`);
    return order;
  }

  // The numbers of some orders (AP §4.8), for the captain's custody lines
  // (CA §10.2); an unknown id is left out.
  async orderNumbers(orderIds: readonly string[]): Promise<Map<string, bigint>> {
    if (orderIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ id: orders.id, number: orders.number })
      .from(orders)
      .where(inArray(orders.id, [...new Set(orderIds)]));
    return new Map(rows.map((row) => [row.id, row.number]));
  }

  // AP §9.10.6 (slice 2.22d): what the cost report reads of some orders: the
  // restaurant, how the order ended and who operations named responsible
  // (the cancellation's party, the party of the outcome in force, and every
  // outcome that posted journals with their ids), and its code; an unknown
  // id is left out.
  async costOrders(orderIds: readonly string[]): Promise<Map<string, CostOrder>> {
    if (orderIds.length === 0) return new Map();
    const ids = [...new Set(orderIds)];
    // Every outcome that posted journals, the replaced ones included.
    const posted = await this.database.db
      .select({
        orderId: orderOutcomeRows.orderId,
        outcome: orderOutcomeRows.outcome,
        responsible: orderOutcomeRows.responsible,
        journalIds: orderOutcomeRows.journalIds,
      })
      .from(orderOutcomeRows)
      .where(inArray(orderOutcomeRows.orderId, ids));
    const rows = await this.database.db
      .select({
        id: orders.id,
        restaurantId: orders.restaurantId,
        status: orders.status,
        cancelResponsible: orders.cancelResponsible,
        outcome: orders.outcome,
        outcomeResponsible: orderOutcomeRows.responsible,
        promoCodeId: orders.promoCodeId,
        promoCode: orders.promoCode,
      })
      .from(orders)
      .leftJoin(
        orderOutcomeRows,
        and(
          eq(orderOutcomeRows.orderId, orders.id),
          eq(orderOutcomeRows.orderPlacedAt, orders.placedAt),
          isNull(orderOutcomeRows.replacedAt),
          // An outcome still waiting for its collection has posted nothing.
          isNotNull(orders.outcome),
        ),
      )
      .where(inArray(orders.id, ids));
    const outcomes = new Map<string, CostOrder['outcomes'][number][]>();
    for (const { orderId, journalIds, ...outcome } of posted) {
      if (journalIds === null) continue;
      const list = outcomes.get(orderId) ?? [];
      list.push({ ...outcome, journalIds });
      outcomes.set(orderId, list);
    }
    return new Map(
      rows.map(({ id, ...order }) => [id, { ...order, outcomes: outcomes.get(id) ?? [] }]),
    );
  }

  // AP §8.5.5 (slice 2.18a): the distance part of each delivered order's pay,
  // as the collection recorded it, for the captain's weekly statement; an
  // order without a collection is left out.
  async distancePay(orderIds: readonly string[]): Promise<Map<string, bigint>> {
    if (orderIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ orderId: collections.orderId, distancePay: collections.distancePay })
      .from(collections)
      .where(inArray(collections.orderId, [...new Set(orderIds)]));
    return new Map(rows.map((row) => [row.orderId, row.distancePay]));
  }

  // CA §10.6 (slice 2.18b): each delivered order's pay in its parts, as the
  // collection recorded it (CA §9.8), for «أرباحي»; an order without a
  // collection (ended by an outcome without one) is left out.
  async payParts(orderIds: readonly string[]): Promise<Map<string, OrderPayParts>> {
    if (orderIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({
        orderId: collections.orderId,
        basePay: collections.basePay,
        distancePay: collections.distancePay,
        topUpPay: collections.topUpPay,
        waitingPay: collections.waitingPay,
        peakBonus: collections.peakBonus,
      })
      .from(collections)
      .where(inArray(collections.orderId, [...new Set(orderIds)]));
    return new Map(rows.map(({ orderId, ...parts }) => [orderId, parts]));
  }

  // AP §9.10.1 «التقرير اليومي» (slice 2.20d): the city's orders delivered
  // normally from `from` (included) to `to` (excluded), test orders and the
  // outcomes of «تحديد النتيجة» left out (the customer paid the total of a
  // normal delivery only), with their customer totals (GMV) and items value,
  // per currency (the base). Orders placed up to DELIVERED_LOOKBACK_MS
  // before `from` are read, so the month partitions prune.
  async deliveredTotals(cityId: string, from: Date, to: Date): Promise<DeliveredTotals[]> {
    const rows = await this.database.db
      .select({
        currency: orders.currency,
        count: sql<number>`count(*)::int`,
        gmv: sql<string>`sum(${orders.total})::text`,
        itemsValue: sql<string>`sum(${orders.itemsValue})::text`,
      })
      .from(orders)
      .where(
        and(
          eq(orders.cityId, cityId),
          eq(orders.status, 'delivered'),
          eq(orders.outcome, 'normal'),
          eq(orders.testOrder, false),
          gte(orders.placedAt, new Date(from.getTime() - DELIVERED_LOOKBACK_MS)),
          lt(orders.placedAt, to),
          gte(orders.deliveredAt, from),
          lt(orders.deliveredAt, to),
        ),
      )
      .groupBy(orders.currency);
    return rows.map((row) => ({
      currency: row.currency,
      count: row.count,
      gmv: BigInt(row.gmv),
      itemsValue: BigInt(row.itemsValue),
    }));
  }

  // AP §8.7, RA §12.3 (slice 2.19a): each order's number and its confirmed
  // pickup payment, the full items value in the order's currency with the
  // currency lines booked (the captain's when none were), for the
  // restaurant's weekly statement; an order without a confirmed pickup has
  // `pickup` null.
  async pickups(orderIds: readonly string[]): Promise<Map<string, OrderPickup>> {
    if (orderIds.length === 0) return new Map();
    const ids = [...new Set(orderIds)];
    const [numbers, rows] = await Promise.all([
      this.orderNumbers(ids),
      this.database.db
        .select({
          orderId: pickupRequests.orderId,
          currency: pickupRequests.currency,
          amount: pickupRequests.amount,
          lines: pickupRequests.lines,
          bookedLines: pickupRequests.bookedLines,
        })
        .from(pickupRequests)
        .where(and(inArray(pickupRequests.orderId, ids), eq(pickupRequests.status, 'confirmed'))),
    ]);
    const confirmed = new Map(rows.map((row) => [row.orderId, row]));
    const pickups = new Map<string, OrderPickup>();
    for (const [orderId, number] of numbers) {
      const row = confirmed.get(orderId);
      pickups.set(orderId, {
        number,
        pickup: row
          ? {
              currency: row.currency,
              amount: row.amount,
              lines: ((row.bookedLines ?? row.lines) as { currency: string; amount: string }[]).map(
                (line) => ({ currency: line.currency, amount: BigInt(line.amount) }),
              ),
            }
          : null,
      });
    }
    return pickups;
  }

  // RA §8.4, R10 (slice 2.19d): the owners' money lines of the board's
  // orders, null for a test order; a cancelled or rejected order has none.
  // After the pickup they read the edits that froze its values.
  async ownerMoney(views: readonly OrderView[]): Promise<Map<string, OwnerMoney | null>> {
    const shown = views.filter(
      (order) => order.status !== 'cancelled' && order.status !== 'rejected',
    );
    const lines = await Promise.all(
      shown.map(async (order) => {
        const frozen =
          order.pickup === null
            ? null
            : await frozenAtPickup(this.database.db, {
                id: order.id,
                placedAt: order.placedAt,
                itemsValue: order.money.itemsValue,
                deliveryFee: order.money.deliveryFee,
              });
        // AP §8.9: an outcome the restaurant bears takes the pickup payment
        // back; without its debit kept, the pickup less its own edits.
        const outcome = order.outcome?.responsible === 'restaurant' ? order.outcome : null;
        const debit =
          outcome === null || frozen === null
            ? null
            : (outcome.merchantDebit ??
              frozen.itemsValue - frozen.restaurantCharge + frozen.restaurantCommissionCut);
        return [
          order.id,
          ownerMoney(
            {
              itemsValue: order.money.itemsValue,
              commissionBp: order.commissionBp,
              testOrder: order.testOrder,
              discount: { merchant: order.discountMerchant, onDelivery: order.discountOnDelivery },
            },
            frozen,
            debit,
          ),
        ] as const;
      }),
    );
    return new Map(lines);
  }

  // RA §12.2 (slice 2.19d): the restaurant's pickups confirmed since a
  // moment, newest first.
  async restaurantPickups(restaurantId: string, since: Date): Promise<RestaurantPickup[]> {
    const rows = await this.database.db
      .select({
        orderId: orders.id,
        number: orders.number,
        at: pickupRequests.closedAt,
        captainId: pickupRequests.captainId,
        currency: pickupRequests.currency,
        amount: pickupRequests.amount,
        lines: pickupRequests.lines,
        bookedLines: pickupRequests.bookedLines,
      })
      .from(orders)
      .innerJoin(
        pickupRequests,
        and(
          eq(pickupRequests.orderId, orders.id),
          eq(pickupRequests.orderPlacedAt, orders.placedAt),
          eq(pickupRequests.status, 'confirmed'),
        ),
      )
      .where(
        and(
          eq(orders.restaurantId, restaurantId),
          gte(orders.pickedUpAt, since),
          gt(orders.placedAt, new Date(since.getTime() - PICKED_UP_AFTER_PLACING_MS)),
        ),
      )
      .orderBy(desc(orders.pickedUpAt));
    return rows.map((row) => ({
      orderId: row.orderId,
      number: row.number,
      at: row.at!,
      captainId: row.captainId,
      currency: row.currency,
      amount: row.amount,
      lines: ((row.bookedLines ?? row.lines) as { currency: string; amount: string }[]).map(
        (line) => ({ currency: line.currency, amount: BigInt(line.amount) }),
      ),
    }));
  }

  // CU §11: the customer's own order, or null for another's or an unknown
  // one.
  async customerOrder(accountId: string, orderId: string): Promise<OrderView | null> {
    const [order] = await readOrders(
      this.database.db,
      and(eq(orders.id, orderId), eq(orders.customerAccountId, accountId)),
    );
    return order ?? null;
  }

  // CU §12.3 (slice 2.24a): «إعادة توصيل مجانية» orders placed for this
  // order, newest first, for the link on its detail.
  redeliveriesOf(orderId: string): Promise<{ orderId: string; number: bigint }[]> {
    return this.database.db
      .select({ orderId: orders.id, number: orders.number })
      .from(orders)
      .where(eq(orders.redeliveryOfId, orderId))
      .orderBy(desc(orders.placedAt));
  }

  // CU §12.2: when the order was delivered, null otherwise (an outcome
  // delivered counts).
  async deliveredAt(
    orderId: string,
    placedAt: Date,
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<Date | null> {
    const [row] = await executor
      .select({ deliveredAt: orders.deliveredAt })
      .from(orders)
      .where(and(eq(orders.id, orderId), eq(orders.placedAt, placedAt)));
    return row?.deliveredAt ?? null;
  }

  // CU §6 (the active-order bar), CU §4.3: the customer's orders until they
  // end, newest first.
  customerActiveOrders(accountId: string): Promise<OrderView[]> {
    return readOrders(
      this.database.db,
      and(eq(orders.customerAccountId, accountId), inArray(orders.status, UNTIL_ENDED)),
      { newestFirst: true },
    );
  }

  // RA §8.2: the restaurant's board, every order until it is delivered or
  // ends, oldest first; RA §4.3: the full state an app fetches after a
  // reconnect. A delivered order stays until order.pickup_dispute_window_min
  // after its pickup, so «المبلغ غير صحيح» keeps its place (RA §8.10 item 8;
  // owner decision 2026-11-06).
  async restaurantActiveOrders(restaurantId: string, now: Date): Promise<OrderView[]> {
    const restaurant = await this.merchants.restaurant(restaurantId, now);
    const windowMin = restaurant
      ? await this.settings.get('order.pickup_dispute_window_min', { cityId: restaurant.cityId })
      : 0;
    const disputableSince = new Date(now.getTime() - windowMin * 60_000);
    return readOrders(
      this.database.db,
      and(
        eq(orders.restaurantId, restaurantId),
        or(
          inArray(orders.status, UNTIL_ENDED),
          and(eq(orders.status, 'delivered'), gt(orders.pickedUpAt, disputableSince)),
          // RA §8.14, §18 (slice 2.8b): an order operations cancelled after
          // acceptance rings until «حسناً» on any device, for a day at most.
          and(
            eq(orders.status, 'cancelled'),
            isNotNull(orders.acceptedAt),
            isNotNull(orders.cancelReasonLabel),
            isNull(orders.cancelAcknowledgedAt),
            gt(orders.cancelledAt, new Date(now.getTime() - CANCELLATION_RING_MS)),
            gt(
              orders.placedAt,
              new Date(now.getTime() - CANCELLATION_RING_MS - CANCELLED_AFTER_PLACING_MS),
            ),
          ),
        ),
      ),
    );
  }

  // The order a key placed in the last 24 hours, or null; the key sent
  // with another command is refused.
  private async replay(
    executor: Executor,
    command: PlaceOrder,
    requestHash: string,
    now: Date,
  ): Promise<{ id: string; placedAt: Date } | null> {
    try {
      return await replayKey(executor, command.accountId, command.idempotencyKey, requestHash, now);
    } catch (error) {
      if (!(error instanceof IdempotencyKeyReusedError)) throw error;
      throw new OrderRefusedError('idempotency_key_reused', error.message);
    }
  }

  private async orderAddress(command: PlaceOrder) {
    try {
      return await this.customers.orderAddress(command.accountId, command.address);
    } catch (error) {
      if (
        error instanceof CustomersRefusedError &&
        (error.refusal === 'unknown_address' || error.refusal === 'outside_zones')
      ) {
        throw new OrderRefusedError(error.refusal, error.message);
      }
      throw error;
    }
  }

  private async price(request: QuoteRequest, now: Date) {
    try {
      return await this.quotes.price(request, now);
    } catch (error) {
      if (!(error instanceof QuoteRefusedError)) throw error;
      throw new OrderRefusedError(error.refusal, error.message);
    }
  }
}

async function lock(tx: Tx, name: string): Promise<void> {
  await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtextextended(${name}, 0))`);
}

// JSON with the bigints as strings, as the order keeps them.
export function plain(value: unknown): unknown {
  return JSON.parse(
    JSON.stringify(value, (_key, entry: unknown) =>
      typeof entry === 'bigint' ? entry.toString() : entry,
    ),
  );
}

// What makes two snapshots price alike: the currencies, their rates, rate
// versions and rounding; not the moment each was taken.
function rateKey(snapshot: RateSnapshot): string {
  return JSON.stringify(plain({ base: snapshot.baseCurrency, currencies: snapshot.currencies }));
}

// The command without its key, so a repeat is recognised and another
// command with the same key refused.
function hashOf(command: PlaceOrder): string {
  return commandHash({ ...command, idempotencyKey: null });
}
