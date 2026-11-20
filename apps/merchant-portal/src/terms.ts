import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';

// RA §4.10, S13: the restaurant terms in force and whether this owner has
// accepted them; until then only «الطلبات» opens.
export const termsQuery = queryOptions({
  queryKey: ['terms'],
  queryFn: async () => {
    const { data, response } = await api.GET('/v1/merchant/terms');
    if (!data) throw new Error(`The terms read failed (${response.status}).`);
    return data;
  },
});

export type AcceptResult = 'accepted' | 'outdated';

export function useAcceptTerms() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (version: number): Promise<AcceptResult> => {
      const { data, response } = await api.POST('/v1/merchant/terms/accept', {
        body: { version },
      });
      await queryClient.invalidateQueries({ queryKey: termsQuery.queryKey });
      // A newer version was published while the owner read: read it first.
      if (response.status === 409) return 'outdated';
      if (!data) throw new Error(`The terms acceptance failed (${response.status}).`);
      return 'accepted';
    },
  });
}
