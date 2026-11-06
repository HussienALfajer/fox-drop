import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, eq, inArray, sql } from 'drizzle-orm';
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
  type UnsavedAddressFields,
} from '../customers/index.js';
import { FxRefusedError, FxService, type RateSnapshot } from '../fx/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { ActiveOrders, UNTIL_ENDED } from './active-orders.js';
import { recordTransition } from './order-events.js';
import type { AutoCancelJob } from './order-timers.js';
import { type Quote, type QuoteRequest, QuoteRefusedError, QuoteService } from './quote.service.js';
import { orderKey, readOrders, type OrderView } from './order-views.js';
import { commandHash, IdempotencyKeyReusedError, keepKey, replayKey } from './idempotency-keys.js';
import { orderLines, orderNumbers, orders } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Executor = Pick<NodePgDatabase, 'select'>;

// AP §4.8: a city's first order number (owner decision 2026-11-06).
const FIRST_ORDER_NUMBER = 10001n;

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
class Requote extends Error {}

// The order and its placing (architecture §4.2, §5.5; CU §10.7). The quote is
// re-run first, through the pool, so a placing never holds a connection while
// it waits for another; then one transaction takes the customer's and the
// restaurant's locks, counts both limits, takes the rate snapshot and numbers
// the order.
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
  ) {}

  // RA §7.4: the restaurant is busy at its maximum active orders. CA §7.1:
  // a captain with an active order is busy (AP §9.12.6, no stacking).
  onModuleInit(): void {
    this.merchants.countActiveOrders((restaurantId) => this.activeOrders.restaurant(restaurantId));
    this.captains.useActiveOrders((captainIds, executor) =>
      this.activeOrders.captains(captainIds, executor),
    );
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
        await lock(tx, `orders:customer:${command.accountId}`);
        const repeat = await this.replay(tx, command, requestHash, now);
        if (repeat !== null) return repeat;
        if ((await this.activeOrders.customer(command.accountId, rules, tx)).reached) {
          throw new Requote('the customer reached the active-order limit');
        }
        await lock(tx, `orders:restaurant:${restaurant.id}`);
        if (
          restaurant.maxActiveOrders !== null &&
          (await this.activeOrders.restaurant(restaurant.id, tx)) >= restaurant.maxActiveOrders
        ) {
          throw new Requote('the restaurant reached its maximum active orders');
        }

        // AP §8.6: the rates the order keeps are the ones it was priced with.
        const kept = await this.fx.snapshotForOrder(cityId, tx).catch((error: unknown) => {
          if (error instanceof FxRefusedError) throw new Requote(error.message);
          throw error;
        });
        if (rateKey(kept) !== rateKey(snapshot)) throw new Requote('the rates changed');

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
            deliveryFree: quote.deliveryFree,
            feeRuleId,
            commissionBp,
            payTableId: payTable?.id ?? null,
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

  // CU §11: the customer's own order, or null for another's or an unknown
  // one.
  async customerOrder(accountId: string, orderId: string): Promise<OrderView | null> {
    const [order] = await readOrders(
      this.database.db,
      and(eq(orders.id, orderId), eq(orders.customerAccountId, accountId)),
    );
    return order ?? null;
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
  // reconnect.
  restaurantActiveOrders(restaurantId: string): Promise<OrderView[]> {
    return readOrders(
      this.database.db,
      and(eq(orders.restaurantId, restaurantId), inArray(orders.status, UNTIL_ENDED)),
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
function plain(value: unknown): unknown {
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
