import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import type { CompensationValue } from './order-compensation.js';

export type CompensationRequest =
  components['schemas']['AdminCompensationRequestsDto_Output']['requests'][number];

export function compensationRequestsQuery(cityId: string) {
  return {
    queryKey: ['compensation-requests', cityId],
    queryFn: async (): Promise<CompensationRequest[]> => {
      const { data, error } = await api.GET('/v1/admin/compensations', {
        params: { query: { cityId } },
      });
      if (error || !data) throw new Error('The approval requests could not be read.');
      return data.requests;
    },
  };
}

// AP §6.4 «طلبات الموافقة», and its count in the home page's «المهام» (AP
// §9.1.4).
export function useCompensationRequests(cityId: string | undefined, enabled = true) {
  return useQuery({
    ...compensationRequestsQuery(cityId ?? ''),
    enabled: enabled && cityId !== undefined,
  });
}

export type DecideRefusal =
  | 'compensation_decided'
  | 'unknown_compensation'
  | 'invalid_value'
  | 'no_base_currency'
  | 'currency_changed';

export type DecideResult =
  { status: 'done'; decided: CompensationRequest } | { status: 'refused'; refusal: DecideRefusal };

const refusals: readonly string[] = [
  'compensation_decided',
  'unknown_compensation',
  'invalid_value',
  'no_base_currency',
  'currency_changed',
] satisfies DecideRefusal[];

export type Decision = { kind: 'approve'; value: CompensationValue | null } | { kind: 'reject' };

// OWN's decision on one request: approve as asked, approve with another
// value, or reject. A repeat is refused as decided, so it needs no key.
export function useDecideCompensation(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({
      id,
      decision,
    }: {
      id: string;
      decision: Decision;
    }): Promise<DecideResult> => {
      const path = { params: { path: { compensationId: id } } };
      const { data, error, response } =
        decision.kind === 'approve'
          ? await api.POST('/v1/admin/compensations/{compensationId}/approve', {
              ...path,
              body: { cityId, value: decision.value },
            })
          : await api.POST('/v1/admin/compensations/{compensationId}/reject', {
              ...path,
              body: { cityId },
            });
      if (data) return { status: 'done', decided: data };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (typeof refusal === 'string' && refusals.includes(refusal)) {
        return { status: 'refused', refusal: refusal as DecideRefusal };
      }
      throw new Error(`The decision failed with ${response.status}.`);
    },
    onSettled: (result) =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['compensation-requests'] }),
        queryClient.invalidateQueries({ queryKey: ['alerts'] }),
        result?.status === 'done'
          ? queryClient.invalidateQueries({
              queryKey: ['order', result.decided.orderId, 'compensations'],
            })
          : Promise.resolve(),
      ]),
  });
}
