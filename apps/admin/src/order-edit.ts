import type { components } from '@fox-drop/api-schema';
import { keepPreviousData, queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import { minorOf } from './format.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

type EditBody = components['schemas']['AdminEditDto'];
type PreviewBody = components['schemas']['AdminEditPreviewDto'];
export type EditPreview = components['schemas']['AdminEditPreviewAnswerDto_Output'];
export type EditChoices = NonNullable<OrderDetail['editChoices']>;
export type MenuItem = EditChoices['items'][number];
export type EditChange = EditPreview['changes'][number];
type Line = OrderDetail['lines'][number];
type Money = { amount: string; currency: string };

// AP §9.3.3, docs/domain/09: who bears an edit after the pickup (never the
// customer).
export type AfterPickupParty = NonNullable<PreviewBody['responsible']>;
export const AFTER_PICKUP_PARTIES = [
  'restaurant',
  'captain',
  'platform',
] as const satisfies readonly AfterPickupParty[];

// AP §9.3.3 «تعديل الطلب»: OWN and OPS, while the order is placed, accepted,
// ready (the detail then carries the menu), picked up or arrived.
export function canEdit(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'editChoices'>,
): order is { editChoices: EditChoices } {
  return can(session, OPERATIONS_MANAGE) && order.editChoices !== null;
}

export const MAX_QUANTITY = 20;

// A line added from the menu, with its chosen options.
export interface AddedLine {
  itemId: string;
  optionIds: string[];
  quantity: number;
}

export interface EditForm {
  // Each current line's new quantity by its position; 0 removes it. A line
  // whose options change is removed and added again (owner decision
  // 2026-11-10).
  quantities: Record<number, number>;
  added: AddedLine[];
  // A new delivery fee in major units, or empty to keep it.
  fee: string;
  // Minutes from now, for items added to a ready order.
  extraPrepMin: number;
  // Operations' note, required (AP §9.3.2), never shown to the apps.
  reason: string;
  // After the pickup: who bears the edit, required to confirm.
  responsible: AfterPickupParty | null;
}

export function initialForm(lines: readonly Line[]): EditForm {
  return {
    quantities: Object.fromEntries(lines.map((line) => [line.position, line.quantity])),
    added: [],
    fee: '',
    extraPrepMin: Number.NaN,
    reason: '',
    responsible: null,
  };
}

function quantityFits(quantity: number): boolean {
  return Number.isInteger(quantity) && quantity >= 1 && quantity <= MAX_QUANTITY;
}

// Items added or a quantity raised: on a ready order it goes back to
// preparing, so the extra prep time is asked (AP §9.3.3).
export function addsItems(form: EditForm, lines: readonly Line[]): boolean {
  return (
    form.added.length > 0 ||
    lines.some((line) => (form.quantities[line.position] ?? line.quantity) > line.quantity)
  );
}

export function needsExtraPrep(
  status: OrderDetail['status'],
  form: EditForm,
  lines: readonly Line[],
): boolean {
  return status === 'ready' && addsItems(form, lines);
}

// Whether the chosen options fit every group's minimum and maximum.
export function optionsFit(item: MenuItem, optionIds: readonly string[]): boolean {
  return item.optionGroups.every((group) => {
    const count = group.options.filter((option) => optionIds.includes(option.id)).length;
    return count >= group.minChoices && count <= group.maxChoices;
  });
}

// The edit as the server takes it, or null while it changes nothing, a
// quantity, the fee or the extra prep time does not fit. After the pickup
// (`after`, the order's current fee) only removals and a lower fee fit.
export function editRequest(
  form: EditForm,
  lines: readonly Line[],
  status: OrderDetail['status'],
  currency: string,
  extraPrepMaxMin: number,
  after: { deliveryFee: string } | null = null,
): PreviewBody | null {
  const quantities = lines.map((line) => form.quantities[line.position] ?? line.quantity);
  if (quantities.some((quantity) => quantity !== 0 && !quantityFits(quantity))) return null;
  if (form.added.some((line) => !quantityFits(line.quantity))) return null;
  const fee = form.fee.trim();
  const deliveryFee = fee === '' ? null : minorOf(fee, currency);
  if (fee !== '' && deliveryFee === null) return null;
  if (after) {
    if (form.added.length > 0 || addsItems(form, lines)) return null;
    if (deliveryFee !== null && BigInt(deliveryFee) > BigInt(after.deliveryFee)) return null;
  }
  const keep = lines
    .map((line, index) => ({ position: line.position, quantity: quantities[index]! }))
    .filter((line) => line.quantity > 0);
  if (keep.length + form.added.length === 0) return null;
  const changed =
    form.added.length > 0 ||
    deliveryFee !== null ||
    lines.some((line, index) => quantities[index] !== line.quantity);
  if (!changed) return null;
  let extraPrepMin: number | null = null;
  if (needsExtraPrep(status, form, lines)) {
    const extra = form.extraPrepMin;
    if (!Number.isInteger(extra) || extra < 1 || extra > extraPrepMaxMin) return null;
    extraPrepMin = extra;
  }
  return {
    keep,
    add: form.added,
    deliveryFee,
    extraPrepMin,
    responsible: after ? form.responsible : null,
  };
}

// The command's body, or null without a complete request and the note. It
// carries the order's version the dialog previewed, so an order that moved
// since is refused rather than edited from a stale view (AP §9.3.3).
export function editBody(
  request: PreviewBody | null,
  reason: string,
  version: number,
): EditBody | null {
  const note = reason.trim();
  if (request === null || note === '') return null;
  return { ...request, version, reason: note };
}

// AP §9.3.3, docs/domain/09 (owner decision 2026-11-10: in the style of
// «إلغاء الطلب»): the entries an edit after the pickup posts, one sentence
// per journal, the order clearing account left out. As for the cancellation,
// an entry whose sign is not the sentence's or a type the panel cannot name
// is `unknown` and blocks the confirm.
// Each sentence names its journal's reason (RA §12.5).
export type AfterPickupLine =
  | { key: 'merchantDebit'; name: string | null; amount: Money; reason: string }
  | { key: 'commissionReversed'; amount: Money }
  | { key: 'captainCharge'; name: string | null; amount: Money; reason: string }
  | { key: 'platformCost'; amount: Money; reason: string }
  | { key: 'unknown' };

type Entry = EditPreview['entries'][number];

export function afterPickupLines(preview: EditPreview): AfterPickupLine[] {
  // One journal per type and reason: the items and the fee cut apart.
  const journals = new Map<string, Entry[]>();
  for (const entry of preview.entries) {
    const key = JSON.stringify([entry.type, entry.reason]);
    journals.set(key, [...(journals.get(key) ?? []), entry]);
  }
  return [...journals.values()].map(
    (entries) =>
      entryLine(entries[0]!.type, entries[0]!.reason ?? '', entries) ?? { key: 'unknown' },
  );
}

const isCredit = (entry: Entry) => entry.amount.amount.startsWith('-');
const size = (entry: Entry): Money => ({
  ...entry.amount,
  amount: entry.amount.amount.replace(/^-/, ''),
});

function entryLine(type: string, reason: string, entries: Entry[]): AfterPickupLine | null {
  // The one entry of an account, with the expected direction.
  const one = (account: string, credit: boolean) => {
    const found = entries.filter((entry) => entry.account === account);
    return found.length === 1 && isCredit(found[0]!) === credit ? found[0]! : null;
  };
  switch (type) {
    case 'merchant.debit': {
      const merchant = one('merchant.account', false);
      return (
        merchant && {
          key: 'merchantDebit',
          name: merchant.party.name,
          amount: size(merchant),
          reason,
        }
      );
    }
    case 'merchant.commission': {
      const merchant = one('merchant.account', true);
      return merchant && one('platform.revenue_commission', false)
        ? { key: 'commissionReversed', amount: size(merchant) }
        : null;
    }
    case 'earn.charge': {
      const earnings = one('captain.earnings', false);
      return (
        earnings && {
          key: 'captainCharge',
          name: earnings.party.name,
          amount: size(earnings),
          reason,
        }
      );
    }
    case 'platform.operating_cost': {
      const cost = one('platform.operating_cost', false);
      return cost && { key: 'platformCost', amount: size(cost), reason };
    }
    default:
      return null;
  }
}

// order_state_changed: the order left the statuses an edit allows or moved
// under the dialog; pickup_request_open: the captain's pickup request is
// open (RA §8.10); invalid_edit: an item became unavailable, or the menu or
// the ceiling changed under the dialog.
export type EditRefusal = 'order_state_changed' | 'pickup_request_open' | 'invalid_edit';

const refusals: readonly string[] = [
  'order_state_changed',
  'pickup_request_open',
  'invalid_edit',
] satisfies EditRefusal[];

function refusalOf(status: number, error: unknown): EditRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return (status === 409 || status === 400) &&
    typeof refusal === 'string' &&
    refusals.includes(refusal)
    ? (refusal as EditRefusal)
    : null;
}

export type PreviewResult =
  { status: 'preview'; preview: EditPreview } | { status: 'refused'; refusal: EditRefusal };

// The before-and-after money of the edit as chosen; its key holds the
// detail's version, so the confirm never follows a preview of another state.
export function editPreviewQuery(orderId: string, version: number, body: PreviewBody | null) {
  return queryOptions({
    queryKey: ['edit-preview', orderId, version, body],
    enabled: body !== null,
    placeholderData: keepPreviousData,
    queryFn: async (): Promise<PreviewResult> => {
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/edit-preview', {
        params: { path: { orderId } },
        body: body!,
      });
      if (data) return { status: 'preview', preview: data };
      const refusal = refusalOf(response.status, error);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The preview failed with ${response.status}.`);
    },
  });
}

export type EditResult = { status: 'done' } | { status: 'refused'; refusal: EditRefusal };

// One Idempotency-Key per choice until an answer arrives, so a retry after a
// lost answer replays instead of editing twice (architecture §5.3).
export function useEditOrder(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: EditBody): Promise<EditResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/edit', {
        params: { path: { orderId }, header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(id);
        return { status: 'done' };
      }
      const refusal = refusalOf(response.status, error);
      if (refusal) {
        keys.current.delete(id);
        return { status: 'refused', refusal };
      }
      throw new Error(`The edit failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
      ]),
  });
}
