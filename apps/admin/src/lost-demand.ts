import type { components } from '@fox-drop/api-schema';
import { queryOptions } from '@tanstack/react-query';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

export type LostDemand = components['schemas']['AdminLostDemandDto_Output'];

// AP §9.17, §6.2 (slice 2.28a): «الطلب الضائع» is an operations report, so
// reports.operations (OPS) or reports.all (OWN) reads it.
export function canSeeLostDemand(session: AdminSession | null | undefined): boolean {
  return can(session, 'reports.operations') || can(session, 'reports.all');
}

export const lostDemandQuery = (cityId: string) =>
  queryOptions({
    queryKey: ['lost-demand', cityId],
    queryFn: async (): Promise<LostDemand> => {
      const { data } = await api.GET('/v1/admin/lost-demand', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error('The lost demand read failed.');
      return data;
    },
  });
