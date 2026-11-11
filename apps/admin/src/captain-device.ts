import { useMutation } from '@tanstack/react-query';
import { api } from './api.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

// AP §9.7.5 «تحرير الجهاز»: OWN and OPS (captains.manage).
export const CAPTAINS_MANAGE = 'captains.manage';

// Owner decision 2026-11-11: on the order detail's captain line while the
// order is active with a captain (until AP §9.7's captain page), since a
// captain with no active order signs in on a new phone by themselves.
export function canReleaseDevice(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'status' | 'captain'>,
): order is Pick<OrderDetail, 'status'> & { captain: NonNullable<OrderDetail['captain']> } {
  return (
    can(session, CAPTAINS_MANAGE) &&
    order.captain !== null &&
    ['accepted', 'ready', 'picked_up', 'arrived'].includes(order.status)
  );
}

// The reason the server takes: required, trimmed; null while empty.
export function releaseReason(text: string): string | null {
  const reason = text.trim();
  return reason === '' ? null : reason;
}

// no_device: no device of the captain is signed in (already released, or
// signed out); unknown_captain: the captain has no sign-in account.
export type ReleaseDeviceRefusal = 'no_device' | 'unknown_captain';

export type ReleaseDeviceResult =
  { status: 'released' } | { status: 'refused'; refusal: ReleaseDeviceRefusal };

const refusals: readonly string[] = [
  'no_device',
  'unknown_captain',
] satisfies ReleaseDeviceRefusal[];

// No Idempotency-Key: a repeat finds no device and answers no_device.
export function useReleaseDevice(captainId: string) {
  return useMutation({
    mutationFn: async (reason: string): Promise<ReleaseDeviceResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/captains/{captainId}/release-device',
        { params: { path: { captainId } }, body: { reason } },
      );
      if (data) return { status: 'released' };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (
        (response.status === 409 || response.status === 404) &&
        typeof refusal === 'string' &&
        refusals.includes(refusal)
      ) {
        return { status: 'refused', refusal: refusal as ReleaseDeviceRefusal };
      }
      throw new Error(`The device release failed with ${response.status}.`);
    },
  });
}
