import { createHash } from 'node:crypto';
import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, asc, eq, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainsService } from '../captains/index.js';
import {
  type CustomersRefusal,
  CustomersRefusedError,
  CustomersService,
  type UnsavedAddressFields,
} from '../customers/index.js';
import { FxRefusedError, FxService, type RateSnapshot } from '../fx/index.js';
import type { Point } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { ActiveOrders } from './active-orders.js';
import { type Quote, type QuoteRequest, QuoteRefusedError, QuoteService } from './quote.service.js';
import type { QuoteMoney } from './quote.js';
import {
  idempotencyKeys,
  orderEvents,
  orderLines,
  orderNumbers,
  orders,
  type orderStatuses,
} from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Executor = Pick<NodePgDatabase, 'select'>;

// Architecture §5.3: a key answers its order for 24 hours.
const KEY_LIFETIME_MS = 24 * 60 * 60 * 1000;

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

export interface PlacedOrder {
  id: string;
  number: bigint;
  status: OrderStatus;
  placedAt: Date;
  restaurantId: string;
  currency: string;
  money: QuoteMoney;
  deliveryFree: boolean;
  lines: {
    itemId: string;
    name: string;
    quantity: number;
    note: string | null;
    options: { id: string; name: string; priceDelta: bigint }[];
    unitPrice: bigint;
    lineTotal: bigint;
  }[];
  payIn: string | null;
  note: string | null;
  estimate: { fromMin: number; toMin: number };
  address: {
    location: Point;
    neighbourhood: string;
    label: 'home' | 'work' | 'other' | null;
    customLabel: string | null;
    street: string;
    floor: string | null;
    landmark: string;
    recipientName: string | null;
    directions: string | null;
  };
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
  ) {}

  // RA §7.4: the restaurant is busy at its maximum active orders.
  onModuleInit(): void {
    this.merchants.countActiveOrders((restaurantId) => this.activeOrders.restaurant(restaurantId));
  }

  async place(command: PlaceOrder, now: Date): Promise<PlacedOrder> {
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
    const [rules, payTable] = await Promise.all([
      this.activeOrders.rules(cityId),
      this.captains.payTable(cityId, now),
    ]);

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
            currency: snapshot.baseCurrency,
            ...quote.money,
            deliveryFree: quote.deliveryFree,
            feeRuleId,
            commissionBp,
            payTableId: payTable?.id ?? null,
            rateSnapshot: plain(kept),
            payIn: quote.payIn?.currency ?? null,
            note: command.note,
            estimateFromMin: quote.estimate.fromMin,
            estimateToMin: quote.estimate.toMin,
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
        await tx.insert(orderEvents).values({
          orderId: id,
          orderPlacedAt: now,
          version: 1,
          cityId,
          at: now,
          fromStatus: null,
          toStatus: 'placed',
          actorType: 'customer',
          actorId: command.accountId,
        });
        const key = { requestHash, orderId: id, orderPlacedAt: now, createdAt: now };
        // A key older than 24 hours is used again (architecture §5.3).
        await tx
          .insert(idempotencyKeys)
          .values({ accountId: command.accountId, key: command.idempotencyKey, ...key })
          .onConflictDoUpdate({
            target: [idempotencyKeys.accountId, idempotencyKeys.key],
            set: key,
          });
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
  private async placed({ id, placedAt }: { id: string; placedAt: Date }): Promise<PlacedOrder> {
    const db = this.database.db;
    const [row] = await db
      .select({
        id: orders.id,
        number: orders.number,
        status: orders.status,
        placedAt: orders.placedAt,
        restaurantId: orders.restaurantId,
        currency: orders.currency,
        itemsValue: orders.itemsValue,
        deliveryFee: orders.deliveryFee,
        discount: orders.discount,
        rounding: orders.rounding,
        total: orders.total,
        deliveryFree: orders.deliveryFree,
        payIn: orders.payIn,
        note: orders.note,
        estimateFromMin: orders.estimateFromMin,
        estimateToMin: orders.estimateToMin,
        latitude: sql<number>`ST_Y(${orders.location})`.mapWith(Number),
        longitude: sql<number>`ST_X(${orders.location})`.mapWith(Number),
        neighbourhood: orders.neighbourhood,
        label: orders.label,
        customLabel: orders.customLabel,
        street: orders.street,
        floor: orders.floor,
        landmark: orders.landmark,
        recipientName: orders.recipientName,
        directions: orders.directions,
      })
      .from(orders)
      .where(and(eq(orders.id, id), eq(orders.placedAt, placedAt)));
    if (!row) throw new Error(`order ${id} not found`);
    const lines = await db
      .select()
      .from(orderLines)
      .where(and(eq(orderLines.orderId, id), eq(orderLines.orderPlacedAt, placedAt)))
      .orderBy(asc(orderLines.position));
    return {
      id: row.id,
      number: row.number,
      status: row.status,
      placedAt: row.placedAt,
      restaurantId: row.restaurantId,
      currency: row.currency,
      money: {
        itemsValue: row.itemsValue,
        deliveryFee: row.deliveryFee,
        discount: row.discount,
        rounding: row.rounding,
        total: row.total,
      },
      deliveryFree: row.deliveryFree,
      lines: lines.map((line) => ({
        itemId: line.itemId,
        name: line.itemName,
        quantity: line.quantity,
        note: line.note,
        options: (line.options as { id: string; name: string; priceDelta: string }[]).map(
          (option) => ({ ...option, priceDelta: BigInt(option.priceDelta) }),
        ),
        unitPrice: line.unitPrice,
        lineTotal: line.lineTotal,
      })),
      payIn: row.payIn,
      note: row.note,
      estimate: { fromMin: row.estimateFromMin, toMin: row.estimateToMin },
      address: {
        location: { latitude: row.latitude, longitude: row.longitude },
        neighbourhood: row.neighbourhood,
        label: row.label,
        customLabel: row.customLabel,
        street: row.street,
        floor: row.floor,
        landmark: row.landmark,
        recipientName: row.recipientName,
        directions: row.directions,
      },
    };
  }

  // The order a key placed in the last 24 hours, or null; the key sent with
  // another command is refused.
  private async replay(
    executor: Executor,
    command: PlaceOrder,
    requestHash: string,
    now: Date,
  ): Promise<{ id: string; placedAt: Date } | null> {
    const [row] = await executor
      .select({
        requestHash: idempotencyKeys.requestHash,
        id: idempotencyKeys.orderId,
        placedAt: idempotencyKeys.orderPlacedAt,
        createdAt: idempotencyKeys.createdAt,
      })
      .from(idempotencyKeys)
      .where(
        and(
          eq(idempotencyKeys.accountId, command.accountId),
          eq(idempotencyKeys.key, command.idempotencyKey),
        ),
      );
    if (!row || now.getTime() - row.createdAt.getTime() >= KEY_LIFETIME_MS) return null;
    if (row.requestHash !== requestHash) {
      throw new OrderRefusedError('idempotency_key_reused', 'the key came with another command');
    }
    return { id: row.id, placedAt: row.placedAt };
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
  return createHash('sha256')
    .update(JSON.stringify(plain({ ...command, idempotencyKey: null })))
    .digest('hex');
}
