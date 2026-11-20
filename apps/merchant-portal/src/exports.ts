import type { components } from '@fox-drop/api-schema';
import { useMutation, useQuery } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';

export type PortalExport = components['schemas']['MerchantExportDto_Output'];
export type ReportExportBody = components['schemas']['MerchantReportExportDto'];
export type HistoryExportBody = components['schemas']['MerchantHistoryExportDto'];

// RA §17 (slice 2.45d): what the portal exports to Excel, each built on the
// server by the worker (owner decision 2026-11-20).
export type ExportAsk =
  | { kind: 'report'; body: ReportExportBody }
  | { kind: 'order-history'; body: HistoryExportBody }
  | { kind: 'statement'; body: { statementId: string } };

// How often a pending export is read again, and how long the page waits for
// it (the worker retries a failure for about an hour; no failed state yet),
// as the panel's.
export const EXPORT_POLL_MS = 2_000;
export const EXPORT_WAIT_MS = 10 * 60_000;

export function exportGaveUp(startedAt: number, now: number): boolean {
  return now - startedAt > EXPORT_WAIT_MS;
}

export type ExportRefusal = 'period' | 'tooMany' | 'gone' | 'terminated' | 'other';

export function exportRefusalOf(error: unknown): ExportRefusal {
  switch ((error as { error?: unknown } | undefined)?.error) {
    case 'invalid_period':
      return 'period';
    case 'too_many_rows':
      return 'tooMany';
    case 'unknown_statement':
    case 'unknown_export':
      return 'gone';
    case 'restaurant_terminated':
      return 'terminated';
    default:
      return 'other';
  }
}

// «تصدير Excel»: one Idempotency-Key per ask until it is answered, so a
// retry after a lost answer reads the same export.
export function useRequestExport() {
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (
      ask: ExportAsk,
    ): Promise<
      { status: 'asked'; export: PortalExport } | { status: 'refused'; refusal: ExportRefusal }
    > => {
      const id = JSON.stringify(ask);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const header = { 'Idempotency-Key': key };
      const result =
        ask.kind === 'report'
          ? await api.POST('/v1/merchant/exports/report', { params: { header }, body: ask.body })
          : ask.kind === 'order-history'
            ? await api.POST('/v1/merchant/exports/order-history', {
                params: { header },
                body: ask.body,
              })
            : await api.POST('/v1/merchant/exports/statement', {
                params: { header },
                body: ask.body,
              });
      if (result.data) {
        keys.current.delete(id);
        return { status: 'asked', export: result.data };
      }
      if (result.response.status >= 400 && result.response.status < 500) {
        keys.current.delete(id);
        return { status: 'refused', refusal: exportRefusalOf(result.error) };
      }
      throw new Error(`The export failed (${result.response.status}).`);
    },
  });
}

// The export's state, read again while the worker writes it, until the page
// gives up.
export function useExportState(exportId: string | undefined, startedAt: number) {
  return useQuery({
    queryKey: ['exports', exportId ?? ''],
    enabled: exportId !== undefined,
    refetchInterval: (query) =>
      query.state.data?.status === 'pending' && !exportGaveUp(startedAt, Date.now())
        ? EXPORT_POLL_MS
        : false,
    queryFn: async (): Promise<PortalExport> => {
      const { data, response } = await api.GET('/v1/merchant/exports/{exportId}', {
        params: { path: { exportId: exportId! } },
      });
      if (!data) throw new Error(`The export read failed (${response.status}).`);
      return data;
    },
  });
}

// «تنزيل»: a URL signed for the portal's own origin, valid 5 minutes, asked
// at the click (each download is audited).
export async function downloadUrl(exportId: string): Promise<string | null> {
  const { data, response } = await api.GET('/v1/merchant/exports/{exportId}', {
    params: { path: { exportId }, query: { download: 'true' } },
  });
  if (!data) throw new Error(`The download failed (${response.status}).`);
  return data.url;
}
