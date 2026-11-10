import type { components } from '@fox-drop/api-schema';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

type ChangeTimeBody = components['schemas']['AdminChangeTimeDto'];
export type TimeChange = NonNullable<OrderDetail['timeChange']>;

// AP §9.3.2 «تعديل الوقت»: OWN and OPS, while the order is accepted, ready
// or picked up (the detail then carries the ceiling).
export function canChangeTime(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'timeChange'>,
): order is { timeChange: TimeChange } {
  return can(session, OPERATIONS_MANAGE) && order.timeChange !== null;
}

// Owner decision 2026-11-10: the chips, or any whole minute up to the ceiling.
const CHIPS_MIN = [5, 10, 15, 20] as const;

export function timeChips(maxMin: number): number[] {
  return CHIPS_MIN.filter((minutes) => minutes <= maxMin);
}

// The minutes the server takes: a whole number from 1 to order.eta_change_max_min.
export function addMinFits(minutes: number, maxMin: number): boolean {
  return Number.isInteger(minutes) && minutes >= 1 && minutes <= maxMin;
}

// docs/domain/03: the server rounds the new promised time up to the next 5
// minutes, so the dialog shows the time the customer will hear.
const PROMISE_STEP_MS = 5 * 60_000;

export function newPromisedAt(promisedAt: string, addMin: number): string {
  const moved = Date.parse(promisedAt) + addMin * 60_000;
  return new Date(Math.ceil(moved / PROMISE_STEP_MS) * PROMISE_STEP_MS).toISOString();
}

// Before the food is ready the prep time moves with the promised time; after
// it, only the promised time.
export function prepMoves(status: OrderDetail['status']): boolean {
  return status === 'accepted';
}

// The body of a complete choice, or null while the minutes do not fit; the
// note is optional and an empty one is sent as null.
export function changeTimeBody(
  addMin: number,
  maxMin: number,
  note: string,
): ChangeTimeBody | null {
  if (!addMinFits(addMin, maxMin)) return null;
  const reason = note.trim();
  return { addMin, reason: reason === '' ? null : reason };
}

// order_state_changed: the order left the statuses the change allows;
// invalid_time_change: the ceiling changed under the dialog.
export type ChangeTimeRefusal = 'order_state_changed' | 'invalid_time_change';

export type ChangeTimeResult =
  { status: 'done' } | { status: 'refused'; refusal: ChangeTimeRefusal };

const refusals: readonly string[] = [
  'order_state_changed',
  'invalid_time_change',
] satisfies ChangeTimeRefusal[];

// One Idempotency-Key per choice until an answer arrives, so a retry after a
// lost answer replays instead of moving the time twice (architecture §5.3).
export function useChangeTime(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: ChangeTimeBody): Promise<ChangeTimeResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/orders/{orderId}/change-time', {
        params: { path: { orderId }, header: { 'Idempotency-Key': key } },
        body,
      });
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
        return { status: 'refused', refusal: refusal as ChangeTimeRefusal };
      }
      throw new Error(`The time change failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
      ]),
  });
}
