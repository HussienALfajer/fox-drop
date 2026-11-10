import { and, asc, inArray, isNull } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { PricedLine } from './quote.js';
import { orderEdits } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;

// AP §9.3.3 (slice 2.10a): what operations' «تعديل الطلب» asks for before the
// pickup. The order's current lines it keeps, each by its position with its
// new quantity (a line left out is removed), the lines it adds from the
// current menu, a new delivery fee or null to keep it, and for items added
// to a ready order the extra prep time (owner decision 2026-11-10).
export interface EditRequest {
  keep: { position: number; quantity: number }[];
  add: { itemId: string; optionIds: string[]; quantity: number }[];
  deliveryFee: bigint | null;
  extraPrepMin: number | null;
}

// One change as the restaurant's prompt, the captain, the customer and the
// panel show it (RA §8.13). A line whose options change is removed and added
// again (owner decision 2026-11-10).
export type EditChange =
  | { kind: 'added'; name: string; options: string[]; quantity: number }
  | { kind: 'removed'; name: string; options: string[]; quantity: number }
  | {
      kind: 'quantity';
      name: string;
      options: string[];
      quantity: number;
      quantityBefore: number;
    };

// A current line of the order (not removed by an earlier edit).
export interface CurrentLine {
  position: number;
  itemId: string;
  name: string;
  quantity: number;
  options: { id: string; name: string; priceDelta: bigint }[];
  note: string | null;
  unitPrice: bigint;
  lineTotal: bigint;
  quantityBefore: number | null;
}

export interface EditPlan {
  // A kept line whose quantity changes keeps its unit price (owner decision
  // 2026-11-10); quantityBefore is the line's first quantity.
  updates: { position: number; quantity: number; lineTotal: bigint; quantityBefore: number }[];
  removals: number[];
  additions: (PricedLine & { unitPrice: bigint; lineTotal: bigint; name: string })[];
  changes: EditChange[];
  // Items added or a quantity raised: the restaurant's prompt rings and the
  // pickup waits for «اطلعت على التعديل» (RA §8.13).
  addsItems: boolean;
  itemsValue: bigint;
}

export const EDIT_MAX_QUANTITY = 20;

// The plan of an edit, or why it cannot be made (400 invalid_edit). `priced`
// are the request's additions priced at the menu's current prices, in order.
export function planEdit(
  current: CurrentLine[],
  request: Pick<EditRequest, 'keep' | 'add'>,
  priced: PricedLine[],
): EditPlan | string {
  const byPosition = new Map(current.map((line) => [line.position, line]));
  const kept = new Set<number>();
  for (const { position, quantity } of request.keep) {
    if (!byPosition.has(position)) return `no current line at position ${position}`;
    if (kept.has(position)) return 'each line once';
    if (!validQuantity(quantity))
      return `quantities are whole numbers from 1 to ${EDIT_MAX_QUANTITY}`;
    kept.add(position);
  }
  if (request.add.some((line) => !validQuantity(line.quantity))) {
    return `quantities are whole numbers from 1 to ${EDIT_MAX_QUANTITY}`;
  }
  const additions: EditPlan['additions'] = [];
  for (const line of priced) {
    // AP §9.3.3: from the current menu at current prices, and available.
    const problems = line.problems.filter((problem) => problem !== 'price_changed');
    if (problems.length > 0 || line.unitPrice === null || line.lineTotal === null) {
      return `an added item cannot be ordered: ${problems.join(', ') || 'not priced'}`;
    }
    additions.push({
      ...line,
      unitPrice: line.unitPrice,
      lineTotal: line.lineTotal,
      name: line.name ?? '',
    });
  }
  if (kept.size + additions.length === 0) return 'an edit leaves at least one line';

  const changes: EditChange[] = [];
  const updates: EditPlan['updates'] = [];
  const removals: number[] = [];
  let addsItems = additions.length > 0;
  let itemsValue = 0n;
  for (const line of current) {
    const options = line.options.map((option) => option.name);
    const keep = request.keep.find((entry) => entry.position === line.position);
    if (keep === undefined) {
      removals.push(line.position);
      changes.push({ kind: 'removed', name: line.name, options, quantity: line.quantity });
      continue;
    }
    const lineTotal = line.unitPrice * BigInt(keep.quantity);
    itemsValue += lineTotal;
    if (keep.quantity === line.quantity) continue;
    if (keep.quantity > line.quantity) addsItems = true;
    updates.push({
      position: line.position,
      quantity: keep.quantity,
      lineTotal,
      quantityBefore: line.quantityBefore ?? line.quantity,
    });
    changes.push({
      kind: 'quantity',
      name: line.name,
      options,
      quantity: keep.quantity,
      quantityBefore: line.quantity,
    });
  }
  for (const line of additions) {
    itemsValue += line.lineTotal;
    changes.push({
      kind: 'added',
      name: line.name,
      options: line.options.map((option) => option.name),
      quantity: line.quantity,
    });
  }
  return { updates, removals, additions, changes, addsItems, itemsValue };
}

function validQuantity(quantity: number): boolean {
  return Number.isInteger(quantity) && quantity >= 1 && quantity <= EDIT_MAX_QUANTITY;
}

// An edit the restaurant has not acknowledged yet, as the reads give it.
export interface PendingEdit {
  id: string;
  orderId: string;
  at: Date;
  changes: EditChange[];
  addsItems: boolean;
  currency: string;
  itemsValueBefore: bigint;
  itemsValueAfter: bigint;
  extraPrepMin: number | null;
}

// The unacknowledged edits of these orders, oldest first.
export async function pendingEdits(
  executor: Executor,
  keys: { id: string; placedAt: Date }[],
): Promise<PendingEdit[]> {
  if (keys.length === 0) return [];
  const rows = await executor
    .select()
    .from(orderEdits)
    .where(
      and(
        inArray(
          orderEdits.orderId,
          keys.map((key) => key.id),
        ),
        inArray(
          orderEdits.orderPlacedAt,
          keys.map((key) => key.placedAt),
        ),
        isNull(orderEdits.acknowledgedAt),
      ),
    )
    .orderBy(asc(orderEdits.at));
  return rows.map((row) => ({
    id: row.id,
    orderId: row.orderId,
    at: row.at,
    changes: row.changes as EditChange[],
    addsItems: row.addsItems,
    currency: row.currency,
    itemsValueBefore: row.itemsValueBefore,
    itemsValueAfter: row.itemsValueAfter,
    extraPrepMin: row.extraPrepMin,
  }));
}

// RA §8.10, §8.13: an unacknowledged edit that added items blocks the pickup
// request and raises «المطعم لم يؤكد التعديل»; the moment it was made.
export async function unacknowledgedAdditionAt(
  executor: Executor,
  orderId: string,
  placedAt: Date,
): Promise<Date | null> {
  const edits = await pendingEdits(executor, [{ id: orderId, placedAt }]);
  return edits.find((edit) => edit.addsItems)?.at ?? null;
}
