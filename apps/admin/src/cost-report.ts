import { useMutation, useQuery } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { useRef } from 'react';
import { api } from './api.js';
import type { StatementExport } from './restaurant-statements.js';

export type CostReport = components['schemas']['AdminCostReportDto_Output'];
export type CompensationReason = CostReport['compensationReasons'][number];
export type OperatingReason = CostReport['operatingReasons'][number]['reason'];
export type CostParty = NonNullable<CostReport['parties'][number]['party']>;

// The totals' words are `costReport.line.<key>`, the export's too (the
// server's export-labels.test.ts keeps every shared word equal).
export const totalLines = ['discounts', 'compensation', 'operating', 'total'] as const;

// What an operating cost was for, keyed by the API's causes.
export const operatingKeys = {
  cancelled_prepared: 'costReport.operating.cancelled_prepared',
  captain_compensation: 'costReport.operating.captain_compensation',
  free: 'costReport.operating.free',
  fake: 'costReport.operating.fake',
  damaged: 'costReport.operating.damaged',
  wrong_refused: 'costReport.operating.wrong_refused',
  failed_other: 'costReport.operating.failed_other',
  edit_after_pickup: 'costReport.operating.edit_after_pickup',
  shortfall: 'costReport.operating.shortfall',
  other: 'costReport.operating.other',
} as const satisfies Record<OperatingReason, string>;

// The responsible party, «غير محدد» where operations named none.
export const partyKeys = {
  restaurant: 'costReport.party.restaurant',
  captain: 'costReport.party.captain',
  customer: 'costReport.party.customer',
  platform: 'costReport.party.platform',
} as const satisfies Record<CostParty, string>;

// A compensation line's name: the reason's label as it was chosen, the late
// codes' own line, or «أخرى» for a cost with no personal code behind it.
export function compensationName(
  row: Pick<CompensationReason, 'reason' | 'label'>,
): { label: string } | { key: 'costReport.lateDelivery' | 'costReport.operating.other' } {
  if (row.label !== null) return { label: row.label };
  return {
    key: row.reason === 'late_delivery' ? 'costReport.lateDelivery' : 'costReport.operating.other',
  };
}

export type CostReportRefusal = 'invalid_period' | 'no_base_currency' | 'rate_missing';

export type CostReportResult =
  { status: 'ready'; report: CostReport } | { status: 'refused'; refusal: CostReportRefusal };

// The report of a period of business days, the last 7 when none is given.
export function useCostReport(
  cityId: string | undefined,
  period: { from: string; to: string } | undefined,
) {
  return useQuery({
    queryKey: ['cost-report', cityId ?? '', period?.from ?? '', period?.to ?? ''],
    enabled: cityId !== undefined,
    queryFn: async (): Promise<CostReportResult> => {
      const { data, error, response } = await api.GET('/v1/admin/cost-report', {
        params: { query: { cityId: cityId!, ...(period ?? {}) } },
      });
      if (data) return { status: 'ready', report: data };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (
        refusal === 'invalid_period' ||
        refusal === 'no_base_currency' ||
        refusal === 'rate_missing'
      ) {
        return { status: 'refused', refusal };
      }
      throw new Error(`The cost report read failed with ${response.status}.`);
    },
  });
}

// «تصدير Excel» of a period: one key per period until an answer, as the
// statement's.
export function useExportCostReport() {
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: {
      cityId: string;
      from: string;
      to: string;
    }): Promise<StatementExport> => {
      const choice = JSON.stringify(body);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, response } = await api.POST('/v1/admin/cost-report/exports', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      });
      if (!data) throw new Error(`The export failed with ${response.status}.`);
      keys.current.delete(choice);
      return data;
    },
  });
}
