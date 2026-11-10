import { and, asc, eq, inArray, isNotNull, isNull } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { AccountPurpose, JournalType } from '../ledger/index.js';
import type { PricedLine } from './quote.js';
import { orderEdits } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;

// AP §9.3.3 (slices 2.10a, 2.10b): what operations' «تعديل الطلب» asks for. The order's current lines it keeps, each by its position with its
// new quantity (a line left out is removed), the lines it adds from the
// current menu, a new delivery fee or null to keep it, and for items added
// to a ready order the extra prep time (owner decision 2026-11-10).
export interface EditRequest {
  keep: { position: number; quantity: number }[];
  add: { itemId: string; optionIds: string[]; quantity: number }[];
  deliveryFee: bigint | null;
  extraPrepMin: number | null;
  // After the pickup only (slice 2.10b): who bears the edit.
  responsible: AfterPickupParty | null;
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
// The route takes at most this many kept lines, so an edit never leaves more.
export const EDIT_MAX_LINES = 50;

// The plan of an edit, or why it cannot be made (400 invalid_edit). `priced`
// are the request's additions priced at the menu's current prices, in order.
// After the pickup (AP §9.3.3) an edit only removes items or lowers a
// quantity: `afterPickup` refuses additions and raised quantities.
export function planEdit(
  current: CurrentLine[],
  request: Pick<EditRequest, 'keep' | 'add'>,
  priced: PricedLine[],
  { afterPickup = false }: { afterPickup?: boolean } = {},
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
  if (kept.size + additions.length > EDIT_MAX_LINES) {
    return `an order keeps at most ${EDIT_MAX_LINES} lines`;
  }

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
  if (afterPickup && addsItems) return 'after the pickup an edit only removes items';
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
        // An edit after the pickup asks no acknowledgement.
        isNull(orderEdits.responsible),
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

// AP §9.3.3, §8.9: who bears an edit after the pickup (never the customer).
export const AFTER_PICKUP_PARTIES = ['restaurant', 'captain', 'platform'] as const;
export type AfterPickupParty = (typeof AFTER_PICKUP_PARTIES)[number];

// RA §12.5: the restaurant's account line; the same text goes with the
// captain's charge (CA §10.6). A fee cut alone has no line in the spec (to
// confirm with the owner).
export const REMOVED_AFTER_PICKUP_REASON = 'أصناف حُذفت بعد الاستلام';
export const FEE_LOWERED_AFTER_PICKUP_REASON = 'خُفّضت أجرة التوصيل بعد الاستلام';
// RA §12.5: the reversing merchant.commission's line.
export const COMMISSION_REVERSED_REASON = 'إلغاء عمولة';

export interface AfterPickupEntry {
  account: AccountPurpose;
  party: { kind: 'merchant' | 'captain' | 'platform'; id: string | null };
  // From the platform's side, as LedgerService.post takes it.
  amount: bigint;
  currency: string;
}

export interface AfterPickupJournal {
  type: JournalType;
  reason: string | null;
  entries: AfterPickupEntry[];
}

export interface AfterPickupBooking {
  journals: AfterPickupJournal[];
  // What the responsible party bears: the removed items' value (the
  // restaurant) or their merchant net (the captain, the platform), plus the
  // fee's cut.
  charge: bigint;
  // The commission on the removed items: reversed for the restaurant; for
  // the others it stays on the restaurant, which was paid in full, and
  // recovers the pickup payment at the delivery (docs/domain/09 rule 3).
  commissionCut: bigint;
}

// AP §9.3.3, docs/domain/09 (owner decision 2026-11-10: as the spec): the
// entries an edit after the pickup posts at once, shared by the preview and
// the edit. The captain paid the restaurant the full items value at the
// pickup and the customer pays the new total, so each entry goes against the
// order clearing account, which the delivery then settles: it books the
// commission on the items value of the pickup and the fee of the pickup
// (`frozenAtPickup`).
export function afterPickupEntries(facts: {
  responsible: AfterPickupParty;
  restaurantId: string;
  captainId: string | null;
  currency: string;
  itemsValueBefore: bigint;
  itemsValueAfter: bigint;
  deliveryFeeBefore: bigint;
  deliveryFeeAfter: bigint;
  // AP §8.4; zero on a test order (AP §9.6.3).
  commissionOf: (itemsValue: bigint) => bigint;
}): AfterPickupBooking {
  const { currency } = facts;
  const removed = facts.itemsValueBefore - facts.itemsValueAfter;
  const feeCut = facts.deliveryFeeBefore - facts.deliveryFeeAfter;
  if (removed < 0n || feeCut < 0n) throw new Error('an edit after the pickup only lowers');
  // The difference of the commissions, so the restaurant ends paying the
  // commission of what it kept, rounded once.
  const commissionCut =
    facts.commissionOf(facts.itemsValueBefore) - facts.commissionOf(facts.itemsValueAfter);
  const itemsCharge = facts.responsible === 'restaurant' ? removed : removed - commissionCut;
  const platform = { kind: 'platform' as const, id: null };
  const merchant = { kind: 'merchant' as const, id: facts.restaurantId };
  // The party's side of one journal, against the order clearing account.
  const borne = (amount: bigint, reason: string): AfterPickupJournal => {
    const clearing: AfterPickupEntry = {
      account: 'platform.order_clearing',
      party: platform,
      amount: -amount,
      currency,
    };
    if (facts.responsible === 'restaurant') {
      return {
        type: 'merchant.debit',
        reason,
        entries: [{ account: 'merchant.account', party: merchant, amount, currency }, clearing],
      };
    }
    if (facts.responsible === 'captain') {
      if (facts.captainId === null) throw new Error('an order after the pickup has a captain');
      return {
        type: 'earn.charge',
        reason,
        entries: [
          {
            account: 'captain.earnings',
            party: { kind: 'captain', id: facts.captainId },
            amount,
            currency,
          },
          clearing,
        ],
      };
    }
    return {
      type: 'platform.operating_cost',
      reason,
      entries: [
        { account: 'platform.operating_cost', party: platform, amount, currency },
        clearing,
      ],
    };
  };
  // One journal per reason (RA §12.5), so the account line says which.
  const journals: AfterPickupJournal[] = [];
  if (itemsCharge > 0n) journals.push(borne(itemsCharge, REMOVED_AFTER_PICKUP_REASON));
  if (facts.responsible === 'restaurant' && commissionCut > 0n) {
    journals.push({
      type: 'merchant.commission',
      reason: COMMISSION_REVERSED_REASON,
      entries: [
        { account: 'merchant.account', party: merchant, amount: -commissionCut, currency },
        {
          account: 'platform.revenue_commission',
          party: platform,
          amount: commissionCut,
          currency,
        },
      ],
    });
  }
  if (feeCut > 0n) journals.push(borne(feeCut, FEE_LOWERED_AFTER_PICKUP_REASON));
  return { journals, charge: itemsCharge + feeCut, commissionCut };
}

// AP §9.3.3, §8.1: what the delivery books from the order as it was at the
// pickup, which the edits after it leave frozen: the items value (the pickup
// payment and the commission's base), the delivery fee (the platform's
// revenue; its cut was borne by the responsible party), and the commission
// on the items the captain or the platform bore, which goes against the
// order clearing account instead of the revenue. Also what the restaurant's
// own edits took from it (the preview's commission and merchant net).
// Without such an edit, the order's own values. Read it in the transaction
// that books from it, under the order's lock, so an edit committed since is
// counted.
export async function frozenAtPickup(
  executor: Executor,
  order: { id: string; placedAt: Date; itemsValue: bigint; deliveryFee: bigint },
): Promise<{
  itemsValue: bigint;
  deliveryFee: bigint;
  commissionToClearing: bigint;
  restaurantCommissionCut: bigint;
  restaurantCharge: bigint;
}> {
  const edits = await executor
    .select({
      itemsValueBefore: orderEdits.itemsValueBefore,
      deliveryFeeBefore: orderEdits.deliveryFeeBefore,
      responsible: orderEdits.responsible,
      charge: orderEdits.charge,
      commissionCut: orderEdits.commissionCut,
    })
    .from(orderEdits)
    .where(
      and(
        eq(orderEdits.orderId, order.id),
        eq(orderEdits.orderPlacedAt, order.placedAt),
        isNotNull(orderEdits.responsible),
      ),
    )
    .orderBy(asc(orderEdits.at));
  const sum = (party: (responsible: string | null) => boolean, of: 'charge' | 'commissionCut') =>
    edits
      .filter((edit) => party(edit.responsible))
      .reduce((total, edit) => total + (edit[of] ?? 0n), 0n);
  const first = edits[0];
  return {
    itemsValue: first?.itemsValueBefore ?? order.itemsValue,
    deliveryFee: first?.deliveryFeeBefore ?? order.deliveryFee,
    commissionToClearing: sum((party) => party !== 'restaurant', 'commissionCut'),
    restaurantCommissionCut: sum((party) => party === 'restaurant', 'commissionCut'),
    restaurantCharge: sum((party) => party === 'restaurant', 'charge'),
  };
}
