import { useMutation, useQuery } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { useRef } from 'react';
import { api } from './api.js';
import { formatMoney } from './format.js';
import type { StatementExport } from './restaurant-statements.js';
import { type AdminSession, can } from './session.js';

export type Report = components['schemas']['AdminReportDto_Output'];
export type ReportKind = Report['report'];
export type ReportTable = Report['tables'][number];
export type ReportColumn = ReportTable['columns'][number];
export type ReportRow = ReportTable['rows'][number];

// AP §9.17's reports in the order the page offers them.
export const REPORT_KINDS = [
  'orders',
  'timings',
  'restaurants',
  'captains',
  'customers',
  'lost_demand',
  'codes',
  'finance',
] as const satisfies readonly ReportKind[];

// AP §6.2 «Reports», as the server's `reportPermissions`: OWN every report
// (reports.all), OPS the operations reports, SUP the customers report, FIN
// the codes and finance reports (decided by us).
export const REPORT_PERMISSIONS = {
  orders: ['reports.all', 'reports.operations'],
  timings: ['reports.all', 'reports.operations'],
  restaurants: ['reports.all', 'reports.operations'],
  captains: ['reports.all', 'reports.operations'],
  customers: ['reports.all', 'reports.operations', 'reports.support'],
  lost_demand: ['reports.all', 'reports.operations'],
  codes: ['reports.all', 'reports.financial'],
  finance: ['reports.all', 'reports.financial'],
} as const satisfies Record<ReportKind, readonly string[]>;

// The reports the session may read, in the page's order.
export function reportsOf(session: AdminSession | null | undefined): ReportKind[] {
  return REPORT_KINDS.filter((kind) =>
    REPORT_PERMISSIONS[kind].some((permission) => can(session, permission)),
  );
}

export function canSeeReports(session: AdminSession | null | undefined): boolean {
  return reportsOf(session).length > 0;
}

// The words of a key under `reports`, or the fallback where the panel has
// none (a code it does not know shows as it is: the owner sees every row).
export type Words = (key: string, fallback: string) => string;

// A cell as the page shows it: counts as they are, basis points as a
// percentage to one decimal, minutes and stars to one decimal as the server
// answers them (the column's header names the unit), amounts in
// their currency, a code by its Arabic name, text as it is; «—» for none.
export function cellText(
  column: ReportColumn,
  value: string | null,
  currency: string,
  words: Words,
): string {
  if (value === null) return '—';
  switch (column.kind) {
    case 'count':
    case 'text':
      return value;
    case 'bp':
      return `${(Number(value) / 100).toFixed(1)}%`;
    case 'minutes':
    case 'stars':
      return value;
    case 'money':
      return formatMoney({ amount: value, currency });
    case 'code':
      return words(`reports.code.${column.key}.${value}`, value);
  }
}

// A row's name: its label, else its day, hour or code by the table's list.
export function rowName(table: ReportTable, row: ReportRow, words: Words): string {
  if (row.label !== null) return row.label;
  if (row.code === null) return '';
  if (table.rowKind === 'hour') return `${row.code.padStart(2, '0')}:00`;
  if (table.rowCodes !== null) {
    return words(`reports.code.${table.rowCodes}.${row.code}`, row.code);
  }
  return row.code;
}

export type ReportRefusal = 'invalid_period' | 'no_base_currency' | 'rate_missing';

export type ReportResult =
  { status: 'ready'; report: Report } | { status: 'refused'; refusal: ReportRefusal };

// A report of a period of business days, the last 7 when none is given.
export function useReport(
  kind: ReportKind,
  cityId: string | undefined,
  period: { from: string; to: string } | undefined,
) {
  return useQuery({
    queryKey: ['report', kind, cityId ?? '', period?.from ?? '', period?.to ?? ''],
    enabled: cityId !== undefined,
    queryFn: async (): Promise<ReportResult> => {
      const { data, error, response } = await api.GET('/v1/admin/reports/{report}', {
        params: { path: { report: kind }, query: { cityId: cityId!, ...(period ?? {}) } },
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
      throw new Error(`The report read failed with ${response.status}.`);
    },
  });
}

// «تصدير Excel» of a report and period: one key per choice until an answer.
export function useExportReport() {
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async ({
      report,
      ...body
    }: {
      report: ReportKind;
      cityId: string;
      from: string;
      to: string;
    }): Promise<StatementExport> => {
      const choice = JSON.stringify([report, body]);
      let key = keys.current.get(choice);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(choice, key);
      }
      const { data, response } = await api.POST('/v1/admin/reports/{report}/exports', {
        params: { path: { report }, header: { 'Idempotency-Key': key } },
        body,
      });
      if (!data) throw new Error(`The export failed with ${response.status}.`);
      keys.current.delete(choice);
      return data;
    },
  });
}

// AP §9.17 «ranking by …»: a table's rows sorted by a column, the highest
// first (`descending`) or the lowest; a row without a value last either way,
// ties in the server's order. Text and codes sort by their text.
export function sortRows(
  table: ReportTable,
  column: number,
  descending: boolean,
): ReportTable['rows'] {
  const kind = table.columns[column]?.kind;
  const numeric = kind !== 'code' && kind !== 'text';
  return table.rows
    .map((row, index) => ({ row, index }))
    .sort((a, b) => {
      const x = a.row.cells[column] ?? null;
      const y = b.row.cells[column] ?? null;
      if (x === null || y === null) return x === y ? a.index - b.index : x === null ? 1 : -1;
      const order = numeric ? Number(x) - Number(y) : x.localeCompare(y, 'ar');
      return (descending ? -order : order) || a.index - b.index;
    })
    .map(({ row }) => row);
}
