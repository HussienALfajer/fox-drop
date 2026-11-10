import { and, desc, inArray } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { snapshotOf } from './order-views.js';
import { baseTotal, linesOf, type PaymentLine } from './pickup-booking.js';
import { orders, pickupDisputes, pickupRequests } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;
type OrderKey = { id: string; placedAt: Date };

// A pickup request as the apps read it (RA §8.10, CA §9.4).
export interface PickupRequestView {
  id: string;
  status: (typeof pickupRequests.$inferSelect)['status'];
  // restaurant, automatic or operations when confirmed; amount_incorrect or
  // incomplete when rejected; cancelled when voided.
  outcome: (typeof pickupRequests.$inferSelect)['outcome'];
  captainId: string;
  amount: { amount: bigint; currency: string };
  lines: PaymentLine[];
  // The lines booked at confirmation, and those the restaurant says it
  // received on «المبلغ غير صحيح».
  bookedLines: PaymentLine[] | null;
  receivedLines: PaymentLine[] | null;
  // The lines (booked, else paid) in the base currency by the order's rates.
  baseEquivalent: bigint;
  openedAt: Date;
  confirmBy: Date;
  closedAt: Date | null;
  closedBy: { type: string; id: string | null; device: string | null } | null;
}

// RA §8.10 item 8: the restaurant's dispute after the pickup.
export interface PickupDisputeView {
  at: Date;
  // The restaurant user and the app installation.
  accountId: string;
  device: string;
  receivedLines: PaymentLine[];
}

// AP §8.1, slice 2.12a: the requests of the order's current assignment,
// newest first: its captain's, opened since they were assigned. A withdrawn
// captain's requests stay in operations' history only, so the next captain,
// the restaurant's board, the alerts and the cash question never read them.
export function currentRequests<Request extends { captainId: string; openedAt: Date }>(
  requests: Request[] | undefined,
  order: { captainId: string | null; assignedAt: Date | null },
): Request[] {
  return (requests ?? []).filter(
    (request) =>
      request.captainId === order.captainId &&
      order.assignedAt !== null &&
      request.openedAt >= order.assignedAt,
  );
}

// Each order's requests, newest first.
export async function pickupRequestsOf(
  executor: Executor,
  keys: OrderKey[],
): Promise<Map<string, PickupRequestView[]>> {
  const found = new Map<string, PickupRequestView[]>();
  if (keys.length === 0) return found;
  const orderIds = keys.map((key) => key.id);
  const rows = await executor
    .select()
    .from(pickupRequests)
    .where(inArray(pickupRequests.orderId, orderIds))
    .orderBy(desc(pickupRequests.openedAt), desc(pickupRequests.id));
  const snapshots =
    rows.length === 0
      ? new Map()
      : new Map(
          (
            await executor
              .select({ id: orders.id, rateSnapshot: orders.rateSnapshot })
              .from(orders)
              .where(
                and(
                  inArray(orders.id, orderIds),
                  inArray(
                    orders.placedAt,
                    keys.map((key) => key.placedAt),
                  ),
                ),
              )
          ).map((order) => [order.id, snapshotOf(order.rateSnapshot)] as const),
        );
  for (const row of rows) {
    const lines = linesOf(row.lines);
    const bookedLines = row.bookedLines === null ? null : linesOf(row.bookedLines);
    const view: PickupRequestView = {
      id: row.id,
      status: row.status,
      outcome: row.outcome,
      captainId: row.captainId,
      amount: { amount: row.amount, currency: row.currency },
      lines,
      bookedLines,
      receivedLines: row.receivedLines === null ? null : linesOf(row.receivedLines),
      baseEquivalent: baseTotal(snapshots.get(row.orderId)!, bookedLines ?? lines),
      openedAt: row.openedAt,
      confirmBy: row.confirmBy,
      closedAt: row.closedAt,
      closedBy:
        row.closedByType === null
          ? null
          : { type: row.closedByType, id: row.closedById, device: row.closedByDevice },
    };
    found.set(row.orderId, [...(found.get(row.orderId) ?? []), view]);
  }
  return found;
}

export async function pickupDisputesOf(
  executor: Executor,
  keys: OrderKey[],
): Promise<Map<string, PickupDisputeView>> {
  if (keys.length === 0) return new Map();
  const orderIds = keys.map((key) => key.id);
  const rows = await executor
    .select()
    .from(pickupDisputes)
    .where(inArray(pickupDisputes.orderId, orderIds));
  return new Map(
    rows.map((row) => [
      row.orderId,
      {
        at: row.createdAt,
        accountId: row.accountId,
        device: row.device,
        receivedLines: linesOf(row.receivedLines),
      },
    ]),
  );
}
