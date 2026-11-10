import { and, eq, inArray, isNull } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { itemReports } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;

// RA §8.12: «حتى الغد» (default) or «حتى أعيده», per item.
export type ItemReportUntil = 'tomorrow' | 'turned_back_on';
// «يوجد بديل مشابه», «الكمية غير كافية».
export const ITEM_REPORT_NOTES = ['similar_substitute', 'not_enough'] as const;
export type ItemReportNote = (typeof ITEM_REPORT_NOTES)[number];

export interface ReportedItem {
  itemId: string;
  until: ItemReportUntil;
}

// An open report as the reads give it.
export interface OpenItemReport {
  id: string;
  orderId: string;
  at: Date;
  items: ReportedItem[];
  note: ItemReportNote | null;
  accountId: string;
  device: string;
}

// RA §8.12: why the report's items do not fit the order, or null: one or
// more of the order's items, each once.
export function itemReportProblem(items: ReportedItem[], orderItemIds: string[]): string | null {
  const ids = items.map((item) => item.itemId);
  if (ids.length === 0) return 'pick the unavailable items';
  if (new Set(ids).size !== ids.length) return 'each item once';
  if (ids.some((id) => !orderItemIds.includes(id))) return "the items are the order's";
  return null;
}

// The open reports of these orders (at most one each).
export async function openItemReports(
  executor: Executor,
  keys: { id: string; placedAt: Date }[],
): Promise<OpenItemReport[]> {
  if (keys.length === 0) return [];
  const rows = await executor
    .select()
    .from(itemReports)
    .where(
      and(
        inArray(
          itemReports.orderId,
          keys.map((key) => key.id),
        ),
        inArray(
          itemReports.orderPlacedAt,
          keys.map((key) => key.placedAt),
        ),
        isNull(itemReports.closedAt),
      ),
    );
  return rows.map((row) => ({
    id: row.id,
    orderId: row.orderId,
    at: row.reportedAt,
    items: row.items as ReportedItem[],
    note: row.note as ItemReportNote | null,
    accountId: row.accountId,
    device: row.device,
  }));
}

export async function openItemReport(
  executor: Executor,
  orderId: string,
  placedAt: Date,
): Promise<OpenItemReport | null> {
  const [report] = await openItemReports(executor, [{ id: orderId, placedAt }]);
  return report ?? null;
}

// The report's closing columns, for the open report of an order.
export function openReportOf(orderId: string, placedAt: Date) {
  return and(
    eq(itemReports.orderId, orderId),
    eq(itemReports.orderPlacedAt, placedAt),
    isNull(itemReports.closedAt),
  );
}
