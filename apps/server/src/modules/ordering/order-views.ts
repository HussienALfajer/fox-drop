import { and, asc, desc, eq, inArray, ne, or, type SQL, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { equivalent, type RateSnapshot } from '../fx/index.js';
import type { Point } from '../geo/index.js';
import { type ItemReportNote, type ItemReportUntil, openItemReports } from './item-reports.js';
import { type PendingEdit, pendingEdits } from './order-edits.js';
import type { CaptainTrack } from './order-events.js';
import type { QuoteMoney } from './quote.js';
import {
  collections,
  type orderOutcomes,
  orderEvents,
  orderEdits,
  orderLines,
  orders,
  type orderStatuses,
} from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
export type OrderOutcome = (typeof orderOutcomes)[number];

// A reason as the order keeps it (owner decision 2026-11-07): its code in
// Content's list, its label as chosen and the text of «أخرى».
export interface RecordedReason {
  reason: string;
  label: string;
  note: string | null;
}

// Payment lines as stored in jsonb, their amounts as strings (RA §8.10).
interface PaymentLine {
  currency: string;
  amount: bigint;
}

function linesOf(stored: unknown): PaymentLine[] {
  return (stored as { currency: string; amount: string }[]).map((line) => ({
    currency: line.currency,
    amount: BigInt(line.amount),
  }));
}
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
  // (RA §18; null when another actor accepted), and whether operations
  // accepted on the restaurant's behalf (RA §8.15 «قبلته العمليات»).
  acceptance: {
    at: Date;
    prepMin: number;
    promisedAt: Date;
    device: string | null;
    byOperations: boolean;
  } | null;
  // RA §8.8: «الطلب جاهز».
  readyAt: Date | null;
  // AP §8.2: the captain track, and the captain from assignment.
  captainTrack: CaptainTrack | null;
  captainId: string | null;
  // CA §9.2, RA §8.9: «وصل الكابتن», and the waiting alert's moment.
  captainArrival: { at: Date; waitingAlertAt: Date } | null;
  // AP §8.1: the pickup, and whether ready was recorded at it («لم يُضغط
  // جاهز», S8).
  pickup: { at: Date; readyByPickup: boolean } | null;
  // CA §9.6: «وصلت» at the customer, and the reason given away from the pin
  // (K4), which also covers the delivery.
  customerArrival: { at: Date } | null;
  away: RecordedReason | null;
  // AP §8.1, §8.6, CA §9.8: «تم التسليم», its outcome and the door payment
  // recorded (CU §11.8 Q23: «استلم الكابتن» and «أعاد لك»).
  delivery: {
    at: Date;
    outcome: OrderOutcome;
    received: PaymentLine[];
    change: PaymentLine[];
    netReceived: bigint;
    // «نقص في التحصيل» (AP §8.6), with the captain's reason (K16).
    shortfall: ({ amount: bigint } & RecordedReason) | null;
    recordedBy: { type: string; id: string; reason: string | null };
  } | null;
  // The customer's text for it (CU Appendix C), copied at the cancellation;
  // byCustomer for the customer's own while placed (CU §11.4, §11.9).
  cancellation: {
    at: Date;
    reason: string;
    customerText: string | null;
    byCustomer: boolean;
    // Operations' cancellation (slice 2.8b): the ops_cancel reason's label
    // (null on every other path), the cash answer and the captain's
    // compensation, and when a restaurant device and the captain
    // acknowledged it (RA §8.14, CA §9.10).
    label: string | null;
    byOperations: boolean;
    cash: 'returned' | 'not_returned' | 'not_paid' | null;
    // docs/domain/09 (slice 2.8c, the panel's detail): the responsible party,
    // «تم تحضير الطعام؟» and the restaurant's food credit.
    responsible: 'restaurant' | 'captain' | 'customer' | 'platform' | null;
    foodPrepared: boolean;
    merchantCredit: bigint | null;
    captainCompensation: bigint | null;
    acknowledgedAt: Date | null;
    captainSeenAt: Date | null;
  } | null;
  // RA §8.12: the restaurant's open item-unavailable report, with each
  // item's name from the order's lines, or null.
  itemReport: {
    at: Date;
    items: { itemId: string; name: string; until: ItemReportUntil }[];
    note: ItemReportNote | null;
    accountId: string;
    device: string;
  } | null;
  // RA §8.6, CU §11.9: the rejection's reason, its label, the customer's text
  // and the items «اطلب بدون الأصناف غير المتوفرة» leaves out.
  rejection: {
    at: Date;
    reason: string;
    label: string;
    customerText: string;
    itemIds: string[];
    // RA §8.15: rejected by operations on the restaurant's behalf.
    byOperations: boolean;
  } | null;
  currency: string;
  money: QuoteMoney;
  deliveryFree: boolean;
  // The total in the city's other accepted currencies, by the order's own
  // rates (AP §8.6), each by its own rounding.
  equivalents: { currency: string; amount: bigint }[];
  // The current lines, with the position operations' edit names them by
  // (AP §9.3.3), whether an edit added the line («أُضيف») and its quantity
  // before an edit changed it (CU §11.6).
  lines: {
    position: number;
    itemId: string;
    name: string;
    quantity: number;
    note: string | null;
    options: { id: string; name: string; priceDelta: bigint }[];
    unitPrice: bigint;
    lineTotal: bigint;
    added: boolean;
    quantityBefore: number | null;
  }[];
  // CU §11.6: the lines an edit removed, struck through as «حُذف».
  removedLines: { name: string; quantity: number; options: { name: string }[] }[];
  // RA §8.13: the edits the restaurant has not acknowledged, oldest first,
  // while the order is before its pickup; empty otherwise.
  pendingEdits: PendingEdit[];
  // CU §11.6: operations edited the order at least once.
  edited: boolean;
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
// AP §9.3.3: an order operations may edit before its pickup.
export const BEFORE_PICKUP: OrderStatus[] = ['placed', 'accepted', 'ready'];
// AP §9.3.3 (slice 2.10b): after the pickup, edits only remove items or lower
// the fee, with a responsible party.
export const AFTER_PICKUP: OrderStatus[] = ['picked_up', 'arrived'];
export const EDITABLE: OrderStatus[] = [...BEFORE_PICKUP, ...AFTER_PICKUP];

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
      captainTrack: orders.captainTrack,
      captainId: orders.captainId,
      arrivedAtMerchantAt: orders.arrivedAtMerchantAt,
      captainWaitingAlertAt: orders.captainWaitingAlertAt,
      pickedUpAt: orders.pickedUpAt,
      readyByPickup: orders.readyByPickup,
      arrivedAtCustomerAt: orders.arrivedAtCustomerAt,
      awayReason: orders.awayReason,
      awayReasonLabel: orders.awayReasonLabel,
      awayNote: orders.awayNote,
      deliveredAt: orders.deliveredAt,
      outcome: orders.outcome,
      cancelledAt: orders.cancelledAt,
      cancelReason: orders.cancelReason,
      cancelCustomerText: orders.cancelCustomerText,
      cancelReasonLabel: orders.cancelReasonLabel,
      cancelCash: orders.cancelCash,
      cancelResponsible: orders.cancelResponsible,
      foodPrepared: orders.foodPrepared,
      cancelMerchantCredit: orders.cancelMerchantCredit,
      cancelCaptainCompensation: orders.cancelCaptainCompensation,
      cancelAcknowledgedAt: orders.cancelAcknowledgedAt,
      cancelCaptainSeenAt: orders.cancelCaptainSeenAt,
      rejectedAt: orders.rejectedAt,
      rejectReason: orders.rejectReason,
      rejectReasonLabel: orders.rejectReasonLabel,
      rejectCustomerText: orders.rejectCustomerText,
      rejectItemIds: orders.rejectItemIds,
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
  // The acceptance, the rejection or the cancellation: who decided (RA
  // §8.15, CU §11.9).
  const accepted = rows.filter(
    (row) => row.acceptedAt !== null || row.rejectedAt !== null || row.cancelledAt !== null,
  );
  const decisions =
    accepted.length === 0
      ? []
      : await executor
          .select({
            orderId: orderEvents.orderId,
            toStatus: orderEvents.toStatus,
            device: orderEvents.actorDevice,
            actorType: orderEvents.actorType,
          })
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
              or(
                // The acceptance itself, not a return to preparing (AP §9.3.3).
                and(
                  eq(orderEvents.fromStatus, 'placed'),
                  inArray(orderEvents.toStatus, ['accepted', 'rejected']),
                ),
                // The cancellation itself, not its acknowledgement (RA §8.14).
                and(eq(orderEvents.toStatus, 'cancelled'), ne(orderEvents.fromStatus, 'cancelled')),
              ),
            ),
          );
  const acceptances = decisions.filter((event) => event.toStatus === 'accepted');
  const rejections = decisions.filter((event) => event.toStatus === 'rejected');
  const cancellations = decisions.filter((event) => event.toStatus === 'cancelled');
  const reports = await openItemReports(
    executor,
    rows.filter((row) => row.acceptedAt !== null),
  );
  const edits = await pendingEdits(
    executor,
    rows.filter((row) => BEFORE_PICKUP.includes(row.status)),
  );
  const editedIds = new Set(
    (
      await executor
        .select({ orderId: orderEdits.orderId })
        .from(orderEdits)
        .where(
          and(
            inArray(
              orderEdits.orderId,
              rows.map((row) => row.id),
            ),
            inArray(
              orderEdits.orderPlacedAt,
              rows.map((row) => row.placedAt),
            ),
          ),
        )
    ).map((row) => row.orderId),
  );
  const delivered = rows.filter((row) => row.deliveredAt !== null);
  const deliveries =
    delivered.length === 0
      ? []
      : await executor
          .select()
          .from(collections)
          .where(
            and(
              inArray(
                collections.orderId,
                delivered.map((row) => row.id),
              ),
              inArray(
                collections.orderPlacedAt,
                delivered.map((row) => row.placedAt),
              ),
            ),
          );
  return rows.map((row) => {
    const collection = deliveries.find((each) => each.orderId === row.id);
    const report = reports.find((each) => each.orderId === row.id);
    const ownLines = lines.filter((line) => line.orderId === row.id);
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
              byOperations:
                acceptances.find((event) => event.orderId === row.id)?.actorType === 'admin',
            }
          : null,
      readyAt: row.readyAt,
      captainTrack: row.captainTrack,
      captainId: row.captainId,
      captainArrival:
        row.arrivedAtMerchantAt && row.captainWaitingAlertAt
          ? { at: row.arrivedAtMerchantAt, waitingAlertAt: row.captainWaitingAlertAt }
          : null,
      pickup:
        row.pickedUpAt && row.readyByPickup !== null
          ? { at: row.pickedUpAt, readyByPickup: row.readyByPickup }
          : null,
      customerArrival: row.arrivedAtCustomerAt && { at: row.arrivedAtCustomerAt },
      // The label is null only on a row a version before Content wrote.
      away: row.awayReason
        ? {
            reason: row.awayReason,
            label: row.awayReasonLabel ?? row.awayReason,
            note: row.awayNote,
          }
        : null,
      delivery:
        row.deliveredAt && row.outcome && collection
          ? {
              at: row.deliveredAt,
              outcome: row.outcome,
              received: linesOf(collection.receivedLines),
              change: linesOf(collection.changeLines),
              netReceived: collection.netReceived,
              shortfall: collection.shortfallReason
                ? {
                    amount: collection.shortfall,
                    reason: collection.shortfallReason,
                    label: collection.shortfallReasonLabel ?? collection.shortfallReason,
                    note: collection.shortfallNote,
                  }
                : null,
              recordedBy: {
                type: collection.recordedByType,
                id: collection.recordedById,
                reason: collection.reason,
              },
            }
          : null,
      cancellation:
        row.cancelledAt && row.cancelReason
          ? {
              at: row.cancelledAt,
              reason: row.cancelReason,
              customerText: row.cancelCustomerText,
              byCustomer:
                cancellations.find((event) => event.orderId === row.id)?.actorType === 'customer',
              label: row.cancelReasonLabel,
              byOperations:
                cancellations.find((event) => event.orderId === row.id)?.actorType === 'admin',
              cash: row.cancelCash,
              responsible: row.cancelResponsible,
              foodPrepared: row.foodPrepared ?? false,
              merchantCredit: row.cancelMerchantCredit,
              captainCompensation: row.cancelCaptainCompensation,
              acknowledgedAt: row.cancelAcknowledgedAt,
              captainSeenAt: row.cancelCaptainSeenAt,
            }
          : null,
      itemReport: report
        ? {
            at: report.at,
            items: report.items.map((item) => ({
              itemId: item.itemId,
              name: ownLines.find((line) => line.itemId === item.itemId)?.itemName ?? '',
              until: item.until,
            })),
            note: report.note,
            accountId: report.accountId,
            device: report.device,
          }
        : null,
      rejection:
        row.rejectedAt &&
        row.rejectReason &&
        row.rejectReasonLabel &&
        row.rejectCustomerText !== null
          ? {
              at: row.rejectedAt,
              reason: row.rejectReason,
              label: row.rejectReasonLabel,
              customerText: row.rejectCustomerText,
              itemIds: (row.rejectItemIds as string[] | null) ?? [],
              byOperations:
                rejections.find((event) => event.orderId === row.id)?.actorType === 'admin',
            }
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
      lines: ownLines
        .filter((line) => line.removedByEdit === null)
        .map((line) => ({
          position: line.position,
          itemId: line.itemId,
          name: line.itemName,
          quantity: line.quantity,
          note: line.note,
          options: (line.options as { id: string; name: string; priceDelta: string }[]).map(
            (option) => ({ ...option, priceDelta: BigInt(option.priceDelta) }),
          ),
          unitPrice: line.unitPrice,
          lineTotal: line.lineTotal,
          added: line.addedByEdit !== null,
          quantityBefore:
            line.quantityBefore === null || line.quantityBefore === line.quantity
              ? null
              : line.quantityBefore,
        })),
      removedLines: ownLines
        .filter((line) => line.removedByEdit !== null)
        .map((line) => ({
          name: line.itemName,
          quantity: line.quantity,
          options: (line.options as { name: string }[]).map((option) => ({ name: option.name })),
        })),
      pendingEdits: BEFORE_PICKUP.includes(row.status)
        ? edits.filter((edit) => edit.orderId === row.id)
        : [],
      edited: editedIds.has(row.id),
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

// An order is cancelled within hours of its placing: a read of cancelled
// orders bounds placed_at by its window plus this margin, so the order's
// month partitions prune.
export const CANCELLED_AFTER_PLACING_MS = 2 * 24 * 60 * 60 * 1000;

// The order's id and placing time, the key of its partitioned row.
export function orderKey(id: string, placedAt: Date): SQL | undefined {
  return and(eq(orders.id, id), eq(orders.placedAt, placedAt));
}

// The stored snapshot (its bigints as strings) back as fx's RateSnapshot.
export function snapshotOf(stored: unknown): RateSnapshot {
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
