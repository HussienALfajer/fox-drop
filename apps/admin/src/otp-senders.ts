import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';

// AP §9.14 «أرقام إرسال الرموز» (OWN; architecture §8.3.3 items 13–14;
// slice 2.38a): the WhatsApp numbers that send the sign-in codes. A number
// is paired with the server command (owner decision 2026-11-19: the panel's
// QR pairing comes later).
export type SenderPool = components['schemas']['SenderPoolDto_Output'];
export type SenderNumber = SenderPool['numbers'][number];

export const senderPoolQuery = queryOptions({
  queryKey: ['otp-sender-numbers'],
  queryFn: async (): Promise<SenderPool> => {
    const { data } = await api.GET('/v1/admin/otp-sender-numbers');
    if (!data) throw new Error('The sending numbers read failed.');
    return data;
  },
});

// The change a number takes from where it is: a warming, throttled or
// standby number can be made active, an active, warming or throttled one
// standby; a disconnected or banned one only after pairing it again.
export function statusChoices(number: SenderNumber): ('active' | 'standby')[] {
  if (number.status === 'disconnected' || number.status === 'banned') return [];
  return (['active', 'standby'] as const).filter((status) => status !== number.status);
}

export type SenderCommandResult =
  { status: 'done' } | { status: 'refused'; refusal: 'needs_pairing' | 'not_found' };

// Sets a number active or standby, or disables it. Each sets a state and
// answers the pool, which replaces the read; no key.
export function useSenderCommand() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (
      command:
        | { kind: 'status'; numberId: string; status: 'active' | 'standby' }
        | {
            kind: 'disable';
            numberId: string;
          },
    ): Promise<SenderCommandResult> => {
      const params = { path: { numberId: command.numberId } };
      const { data, error, response } =
        command.kind === 'status'
          ? await api.PUT('/v1/admin/otp-sender-numbers/{numberId}/status', {
              params,
              body: { status: command.status },
            })
          : await api.POST('/v1/admin/otp-sender-numbers/{numberId}/disable', { params });
      const status: number = response.status;
      if (status === 409) return { status: 'refused', refusal: 'needs_pairing' };
      if (status === 404) {
        await queryClient.invalidateQueries({ queryKey: senderPoolQuery.queryKey });
        return { status: 'refused', refusal: 'not_found' };
      }
      if (error !== undefined || !data) throw new Error(`sending number failed with ${status}`);
      queryClient.setQueryData(senderPoolQuery.queryKey, data);
      return { status: 'done' };
    },
  });
}
