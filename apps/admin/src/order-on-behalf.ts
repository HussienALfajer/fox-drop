import type { components } from '@fox-drop/api-schema';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

export type OnBehalfChoices = NonNullable<OrderDetail['onBehalf']>;
type RejectBody = components['schemas']['AdminRejectDto'];
export type ItemUntil = RejectBody['items'][number]['until'];

// AP §9.3.2 «قبول نيابة عن المطعم» and «رفض نيابة عن المطعم»: OWN and OPS,
// while the order is placed (the detail then carries the choices).
export function canDecide(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'status' | 'onBehalf'>,
): order is Pick<OrderDetail, 'status'> & { onBehalf: OnBehalfChoices } {
  return can(session, OPERATIONS_MANAGE) && order.status === 'placed' && order.onBehalf !== null;
}

// «ضغط طلبات» (RA §8.6): «الرفض فقط», busy mode with one of the offered
// minutes, or «إيقاف 30 د».
export const TOO_BUSY_PAUSE_MIN = 30;
export type TooBusyStep = { kind: 'none' } | { kind: 'busy'; minutes: number } | { kind: 'pause' };

export interface RejectForm {
  rejection: string | null;
  // item_unavailable: the chosen items, each «حتى الغد» or «حتى أعيده».
  items: ReadonlyMap<string, ItemUntil>;
  tooBusy: TooBusyStep;
  // Operations' note, required (AP §9.3.2), never shown to the apps.
  reason: string;
}

// The body of a complete form, or null while a step is missing: a reason,
// the items for «صنف غير متوفر», the note. The server checks the rest.
export function rejectBody(form: RejectForm): RejectBody | null {
  const reason = form.reason.trim();
  if (form.rejection === null || reason === '') return null;
  const itemUnavailable = form.rejection === 'item_unavailable';
  const tooBusy = form.rejection === 'too_busy';
  if (itemUnavailable && form.items.size === 0) return null;
  return {
    rejection: form.rejection,
    items: itemUnavailable ? [...form.items].map(([itemId, until]) => ({ itemId, until })) : [],
    busyExtraMin: tooBusy && form.tooBusy.kind === 'busy' ? form.tooBusy.minutes : null,
    pauseMin: tooBusy && form.tooBusy.kind === 'pause' ? TOO_BUSY_PAUSE_MIN : null,
    reason,
  };
}

// A prep time the server takes: a whole minute within the floor and the
// ceiling (RA §8.5).
export function prepTimeFits(minutes: number, choices: OnBehalfChoices['prepTime']): boolean {
  return Number.isInteger(minutes) && minutes >= choices.floorMin && minutes <= choices.ceilingMin;
}

// order_state_changed: the restaurant or the automatic cancellation decided
// first; the others mean the choices changed (the panel reads the order again).
export type OnBehalfRefusal =
  'order_state_changed' | 'invalid_prep_time' | 'unknown_reason' | 'invalid_rejection';

export type OnBehalfResult = { status: 'done' } | { status: 'refused'; refusal: OnBehalfRefusal };

const refusals: readonly string[] = [
  'order_state_changed',
  'invalid_prep_time',
  'unknown_reason',
  'invalid_rejection',
] satisfies OnBehalfRefusal[];

type Decision =
  | { kind: 'accept'; body: components['schemas']['AdminAcceptDto'] }
  | { kind: 'reject'; body: RejectBody };

// One Idempotency-Key per decision until an answer arrives, so a retry after
// a lost answer replays instead of acting twice (architecture §5.3).
export function useDecideOnBehalf(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (decision: Decision): Promise<OnBehalfResult> => {
      const id = JSON.stringify(decision);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const params = { path: { orderId }, header: { 'Idempotency-Key': key } };
      const { data, error, response } =
        decision.kind === 'accept'
          ? await api.POST('/v1/admin/orders/{orderId}/accept', { params, body: decision.body })
          : await api.POST('/v1/admin/orders/{orderId}/reject', { params, body: decision.body });
      if (data) {
        keys.current.delete(id);
        return { status: 'done' };
      }
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (
        (response.status === 409 || response.status === 400) &&
        typeof refusal === 'string' &&
        refusals.includes(refusal)
      ) {
        keys.current.delete(id);
        return { status: 'refused', refusal: refusal as OnBehalfRefusal };
      }
      throw new Error(`The decision failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
      ]),
  });
}
