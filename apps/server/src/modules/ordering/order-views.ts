import { and, asc, desc, eq, inArray, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { equivalent, type RateSnapshot } from '../fx/index.js';
import type { Point } from '../geo/index.js';
import type { QuoteMoney } from './quote.js';
import { orderEvents, orderLines, orders, type orderStatuses } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
type Executor = Pick<NodePgDatabase, 'select'>;

// An order with its lines as the server keeps it: what the placing command
// answers and what the reads of the apps start from (CU §11, RA §8). Each
// party's route chooses what it shows.
export interface OrderView {
  id: string;
  cityId: string;
  number: bigint;
  customerAccountId: string;
  restaurantId: string;
  status: OrderStatus;
  // Architecture §5.3, RA §4.3: every transition increments it; the apps
  // ignore an event not newer than the version they show.
  version: number;
  placedAt: Date;
  // RA §8.2–8.3: late to answer from the first, cancelled automatically at
  // the second; null for an order placed before slice 1.9.
  acceptAlertAt: Date | null;
  autoCancelAt: Date | null;
  // RA §8.5, docs/domain/03: from the restaurant's acceptance, the prep time
  // chosen, the promised time and the app installation it was accepted on
  // (RA §18; null when another actor accepted).
  acceptance: { at: Date; prepMin: number; promisedAt: Date; device: string | null } | null;
  // RA §8.8: «الطلب جاهز».
  readyAt: Date | null;
  cancellation: { at: Date; reason: string } | null;
  currency: string;
  money: QuoteMoney;
  deliveryFree: boolean;
  // The total in the city's other accepted currencies, by the order's own
  // rates (AP §8.6), each by its own rounding.
  equivalents: { currency: string; amount: bigint }[];
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

// The orders matching `where` with their lines, oldest first, or newest
// first with `newestFirst`.
export async function readOrders(
  executor: Executor,
  where: SQL | undefined,
  { newestFirst = false } = {},
): Promise<OrderView[]> {
  const rows = await executor
    .select({
      id: orders.id,
      cityId: orders.cityId,
      number: orders.number,
      customerAccountId: orders.customerAccountId,
      restaurantId: orders.restaurantId,
      status: orders.status,
      version: orders.version,
      placedAt: orders.placedAt,
      acceptAlertAt: orders.acceptAlertAt,
      autoCancelAt: orders.autoCancelAt,
      acceptedAt: orders.acceptedAt,
      prepMin: orders.prepMin,
      promisedAt: orders.promisedAt,
      readyAt: orders.readyAt,
      cancelledAt: orders.cancelledAt,
      cancelReason: orders.cancelReason,
      currency: orders.currency,
      itemsValue: orders.itemsValue,
      deliveryFee: orders.deliveryFee,
      discount: orders.discount,
      rounding: orders.rounding,
      total: orders.total,
      deliveryFree: orders.deliveryFree,
      rateSnapshot: orders.rateSnapshot,
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
    .where(where)
    .orderBy(
      ...(newestFirst
        ? [desc(orders.placedAt), desc(orders.id)]
        : [asc(orders.placedAt), asc(orders.id)]),
    );
  if (rows.length === 0) return [];
  const lines = await executor
    .select()
    .from(orderLines)
    .where(
      and(
        inArray(
          orderLines.orderId,
          rows.map((row) => row.id),
        ),
        inArray(
          orderLines.orderPlacedAt,
          rows.map((row) => row.placedAt),
        ),
      ),
    )
    .orderBy(asc(orderLines.orderId), asc(orderLines.position));
  const accepted = rows.filter((row) => row.acceptedAt !== null);
  const acceptances =
    accepted.length === 0
      ? []
      : await executor
          .select({ orderId: orderEvents.orderId, device: orderEvents.actorDevice })
          .from(orderEvents)
          .where(
            and(
              inArray(
                orderEvents.orderId,
                accepted.map((row) => row.id),
              ),
              inArray(
                orderEvents.orderPlacedAt,
                accepted.map((row) => row.placedAt),
              ),
              eq(orderEvents.toStatus, 'accepted'),
            ),
          );
  return rows.map((row) => {
    const snapshot = snapshotOf(row.rateSnapshot);
    return {
      id: row.id,
      cityId: row.cityId,
      number: row.number,
      customerAccountId: row.customerAccountId,
      restaurantId: row.restaurantId,
      status: row.status,
      version: row.version,
      placedAt: row.placedAt,
      acceptAlertAt: row.acceptAlertAt,
      autoCancelAt: row.autoCancelAt,
      acceptance:
        row.acceptedAt && row.prepMin !== null && row.promisedAt
          ? {
              at: row.acceptedAt,
              prepMin: row.prepMin,
              promisedAt: row.promisedAt,
              device: acceptances.find((event) => event.orderId === row.id)?.device ?? null,
            }
          : null,
      readyAt: row.readyAt,
      cancellation:
        row.cancelledAt && row.cancelReason
          ? { at: row.cancelledAt, reason: row.cancelReason }
          : null,
      currency: row.currency,
      money: {
        itemsValue: row.itemsValue,
        deliveryFee: row.deliveryFee,
        discount: row.discount,
        rounding: row.rounding,
        total: row.total,
      },
      deliveryFree: row.deliveryFree,
      equivalents: snapshot.currencies
        .filter((entry) => entry.code !== snapshot.baseCurrency)
        .map((entry) => ({
          currency: entry.code,
          amount: equivalent(snapshot, row.total, entry.code),
        })),
      lines: lines
        .filter((line) => line.orderId === row.id)
        .map((line) => ({
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
  });
}

// The order's id and placing time, the key of its partitioned row.
export function orderKey(id: string, placedAt: Date): SQL | undefined {
  return and(eq(orders.id, id), eq(orders.placedAt, placedAt));
}

// The stored snapshot (its bigints as strings) back as fx's RateSnapshot.
function snapshotOf(stored: unknown): RateSnapshot {
  const plain = stored as {
    cityId: string;
    baseCurrency: string;
    takenAt: string;
    currencies: {
      code: string;
      decimals: number;
      rate: { numerator: string; denominator: string };
      rateVersionId: string | null;
      roundingUnitMinor: string;
      roundingMode: RateSnapshot['currencies'][number]['roundingMode'];
    }[];
  };
  return {
    cityId: plain.cityId,
    baseCurrency: plain.baseCurrency,
    takenAt: new Date(plain.takenAt),
    currencies: plain.currencies.map((entry) => ({
      code: entry.code,
      decimals: entry.decimals,
      rate: {
        numerator: BigInt(entry.rate.numerator),
        denominator: BigInt(entry.rate.denominator),
      },
      rateVersionId: entry.rateVersionId,
      roundingUnitMinor: BigInt(entry.roundingUnitMinor),
      roundingMode: entry.roundingMode,
    })),
  };
}
