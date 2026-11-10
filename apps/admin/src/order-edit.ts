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

// AP §9.3.3 «تعديل الطلب»: OWN and OPS, while the order is placed, accepted
// or ready (the detail then carries the menu).
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
}

export function initialForm(lines: readonly Line[]): EditForm {
  return {
    quantities: Object.fromEntries(lines.map((line) => [line.position, line.quantity])),
    added: [],
    fee: '',
    extraPrepMin: Number.NaN,
    reason: '',
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
// quantity, the fee or the extra prep time does not fit.
export function editRequest(
  form: EditForm,
  lines: readonly Line[],
  status: OrderDetail['status'],
  currency: string,
  extraPrepMaxMin: number,
): PreviewBody | null {
  const quantities = lines.map((line) => form.quantities[line.position] ?? line.quantity);
  if (quantities.some((quantity) => quantity !== 0 && !quantityFits(quantity))) return null;
  if (form.added.some((line) => !quantityFits(line.quantity))) return null;
  const fee = form.fee.trim();
  const deliveryFee = fee === '' ? null : minorOf(fee, currency);
  if (fee !== '' && deliveryFee === null) return null;
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
  return { keep, add: form.added, deliveryFee, extraPrepMin, responsible: null };
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
