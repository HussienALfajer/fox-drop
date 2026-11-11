import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import type { OrderDetail } from './order-detail.js';
import { type AdminSession, can } from './session.js';

// AP §9.7.5 «تحرير الجهاز»: OWN and OPS (captains.manage).
export const CAPTAINS_MANAGE = 'captains.manage';

export type CaptainDevice = NonNullable<
  components['schemas']['AdminCaptainDeviceDto_Output']['device']
>;

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

// The device signed in now, or null (K5: one at a time); null too for a
// captain with no sign-in account (404 unknown_captain).
export function captainDeviceQuery(captainId: string) {
  return queryOptions({
    queryKey: ['captain-device', captainId],
    queryFn: async (): Promise<CaptainDevice | null> => {
      const { data, response } = await api.GET('/v1/admin/captains/{captainId}/device', {
        params: { path: { captainId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error('The device read failed.');
      return data.device;
    },
  });
}

// The reason the server takes: required, trimmed; null while empty.
export function releaseReason(text: string): string | null {
  const reason = text.trim();
  return reason === '' ? null : reason;
}

// no_device: the device shown is no longer signed in (released already,
// signed out, or a new phone signed in since); unknown_captain: the captain
// has no sign-in account.
export type ReleaseDeviceRefusal = 'no_device' | 'unknown_captain';

export type ReleaseDeviceResult =
  { status: 'released' } | { status: 'refused'; refusal: ReleaseDeviceRefusal };

const refusals: readonly string[] = [
  'no_device',
  'unknown_captain',
] satisfies ReleaseDeviceRefusal[];

// Maps the release's answer; anything but a known refusal throws.
export function releaseResult(
  status: number,
  released: boolean,
  error: unknown,
): ReleaseDeviceResult {
  if (released) return { status: 'released' };
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (
    (status === 409 || status === 404) &&
    typeof refusal === 'string' &&
    refusals.includes(refusal)
  ) {
    return { status: 'refused', refusal: refusal as ReleaseDeviceRefusal };
  }
  throw new Error(`The device release failed with ${status}.`);
}

// No Idempotency-Key: the release names the device shown, so a repeat
// answers no_device and never signs out a newer phone. The device is read
// again after every answer.
export function useReleaseDevice(captainId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (body: { sessionId: string; reason: string }) => {
      const { data, error, response } = await api.POST(
        '/v1/admin/captains/{captainId}/release-device',
        { params: { path: { captainId } }, body },
      );
      return releaseResult(response.status, data !== undefined, error);
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['captain-device', captainId] }),
  });
}
