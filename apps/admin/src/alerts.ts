import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import { pollUnlessLive } from './live.js';
import type { AdminSession } from './session.js';

export type AdminAlert = components['schemas']['AdminAlertsDto_Output']['alerts'][number];
export type AlertCode = AdminAlert['code'];

// AP §9.1.3: the roles some alert rule names as its recipients. Only they
// hear alerts (AP §7.3), so only they get the sound banner; the server still
// answers each one the alerts its roles receive.
const RECIPIENT_ROLES = ['OWN', 'OPS', 'FIN'];

export function receivesAlerts(session: AdminSession | null | undefined): boolean {
  return session?.roles.some((role) => RECIPIENT_ROLES.includes(role)) ?? false;
}

// The alerts follow ops:city.{city_id} (live.ts); while its socket is down
// they are read again every 10 seconds, like the board.
export const ALERTS_POLL_MS = 10_000;

// AP §7.3: a critical alert's sound repeats until someone acknowledges it,
// every 3 seconds (owner decision 2026-11-07).
export const CRITICAL_REPEAT_MS = 3_000;

export function alertsQuery(cityId: string) {
  return queryOptions({
    queryKey: ['alerts', cityId, 'open'],
    queryFn: async (): Promise<AdminAlert[]> => {
      const { data } = await api.GET('/v1/admin/alerts', {
        params: { query: { cityId, state: 'open' } },
      });
      if (!data) throw new Error('The alerts read failed.');
      return data.alerts;
    },
    refetchInterval: pollUnlessLive(cityId, ALERTS_POLL_MS),
    // The alarm must sound while the panel is behind another tab.
    refetchIntervalInBackground: true,
  });
}

export function alertHistoryQuery(cityId: string) {
  return queryOptions({
    queryKey: ['alerts', cityId, 'closed'],
    queryFn: async (): Promise<AdminAlert[]> => {
      const { data } = await api.GET('/v1/admin/alerts', {
        params: { query: { cityId, state: 'closed' } },
      });
      if (!data) throw new Error('The alerts history read failed.');
      return data.alerts;
    },
  });
}

// «استلام»: the alert is assigned to whoever takes it first; taking one
// already taken answers it with who took it, so a retry is harmless.
export function useAcknowledgeAlert(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (alertId: string): Promise<AdminAlert | null> => {
      const { data, response } = await api.POST('/v1/admin/alerts/{alertId}/acknowledge', {
        params: { path: { alertId } },
      });
      // Resolved or no longer ours: the next read drops it.
      if (response.status === 404) return null;
      if (!data) throw new Error('The acknowledgment failed.');
      return data;
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: ['alerts', cityId] }),
  });
}

// What the sound should do after a read (AP §7.3): repeat while any critical
// alert waits for its acknowledgment, chime once for each warning not heard
// before, and notify the desktop of each critical one not seen before.
// Information alerts are silent.
export interface SoundPlan {
  repeat: boolean;
  chime: boolean;
  notify: AdminAlert[];
}

export function needsRepeat(alerts: AdminAlert[]): boolean {
  return alerts.some((alert) => alert.severity === 'critical' && alert.acknowledged === null);
}

export function soundPlan(alerts: AdminAlert[], heard: ReadonlySet<string>): SoundPlan {
  const isNew = (alert: AdminAlert) => !heard.has(alert.id);
  return {
    repeat: needsRepeat(alerts),
    chime: alerts.some((alert) => alert.severity === 'warning' && isNew(alert)),
    notify: alerts.filter((alert) => alert.severity === 'critical' && isNew(alert)),
  };
}

// The direct action the panel has so far: open the order (AP §9.1.3); the
// others come with their screens.
export function orderOf(alert: AdminAlert): string | null {
  return alert.subjectType === 'order' ? alert.subjectId : null;
}
