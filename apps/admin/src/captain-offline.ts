import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';

export type CaptainAvailability = components['schemas']['AdminCaptainAvailabilityDto_Output'];

// The captain's state beside «فصل من الاتصال» (CA §7.1); null for an
// unknown captain (404 unknown_captain).
export function captainAvailabilityQuery(captainId: string) {
  return queryOptions({
    queryKey: ['captain-availability', captainId],
    queryFn: async (): Promise<CaptainAvailability | null> => {
      const { data, response } = await api.GET('/v1/admin/captains/{captainId}/availability', {
        params: { path: { captainId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error('The captain state read failed.');
      return data;
    },
  });
}

// AP §9.7.5: a force offline is shown while the captain is online in any
// way, and not once operations already forced it (last-order mode by
// operations, K18).
export function canForceOffline(state: CaptainAvailability | null | undefined): boolean {
  if (!state) return false;
  if (state.state === 'offline' || state.state === 'suspended') return false;
  return !(state.state === 'last_order' && state.lastOrderBy === 'forced');
}

// No Idempotency-Key: a repeat changes nothing more than the first (the
// captain is already offline or in last-order mode). The state is read again
// after every answer.
export function useForceOffline(captainId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (reason: string): Promise<CaptainAvailability> => {
      const { data } = await api.POST('/v1/admin/captains/{captainId}/force-offline', {
        params: { path: { captainId } },
        body: { reason },
      });
      if (!data) throw new Error('The force offline failed.');
      return data;
    },
    onSettled: () =>
      queryClient.invalidateQueries({ queryKey: ['captain-availability', captainId] }),
  });
}
