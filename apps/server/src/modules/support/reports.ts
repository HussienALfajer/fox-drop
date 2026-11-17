// The pure rules of the customer's reports (CU §12.2, §9.5, AP §9.9.1;
// slice 2.24a).

// CU §12.2: up to 3 photos (fixed); CU §9.5: one with a price report.
export const REPORT_PHOTOS_MAX = 3;
export const PRICE_REPORT_PHOTOS_MAX = 1;

// CU §12.2: the types that name the order's lines: «صنف ناقص», «صنف خطأ»
// and «الطلب تالف» (their codes in Content's customer_problem list).
export const ITEM_TYPES: readonly string[] = ['missing_item', 'wrong_item', 'damaged_order'];

export type ReportProblem =
  'report_closed' | 'already_reported' | 'items_required' | 'invalid_items' | 'too_many_photos';

export interface ReportedItem {
  position: number;
  quantity: number;
}

// CU §12.2: the end of the report's window, `windowHours` after the
// delivery; null for an order that was not delivered (failed, cancelled,
// rejected or still active), whose detail offers «تواصل مع الدعم». A
// delivered free re-delivery has its window too (owner decision 2026-11-17).
export function reportUntil(
  order: { status: string; deliveredAt: Date | null },
  windowHours: number,
): Date | null {
  if (order.status !== 'delivered' || order.deliveredAt === null) return null;
  return new Date(order.deliveredAt.getTime() + windowHours * 3_600_000);
}

// CU §12.2, Q17: a report within the window, once per order; the items for
// the three types that name them (each a line of the order, once, within its
// quantity) and none for the others; up to 3 photos.
export function reportProblem(input: {
  status: string;
  deliveredAt: Date | null;
  windowHours: number;
  now: Date;
  reported: boolean;
  typeCode: string;
  items: readonly ReportedItem[];
  lines: readonly ReportedItem[];
  photos: number;
}): ReportProblem | null {
  const until = reportUntil(input, input.windowHours);
  if (until === null || input.now.getTime() >= until.getTime()) return 'report_closed';
  if (input.reported) return 'already_reported';
  if (input.photos > REPORT_PHOTOS_MAX) return 'too_many_photos';
  if (!ITEM_TYPES.includes(input.typeCode)) {
    return input.items.length === 0 ? null : 'invalid_items';
  }
  if (input.items.length === 0) return 'items_required';
  const seen = new Set<number>();
  for (const item of input.items) {
    const line = input.lines.find((each) => each.position === item.position);
    if (!line || seen.has(item.position) || item.quantity < 1 || item.quantity > line.quantity) {
      return 'invalid_items';
    }
    seen.add(item.position);
  }
  return null;
}

export type PriceReportProblem = 'too_many_photos' | 'invalid_price';

// CU §9.5: every field optional; one photo at most, a shop price above zero.
// The limit of one report per restaurant per business day is checked under
// the customer's lock.
export function priceReportProblem(input: {
  photos: number;
  shopPrice: bigint | null;
}): PriceReportProblem | null {
  if (input.photos > PRICE_REPORT_PHOTOS_MAX) return 'too_many_photos';
  if (input.shopPrice !== null && input.shopPrice <= 0n) return 'invalid_price';
  return null;
}
