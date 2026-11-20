import { describe, expect, it, vi } from 'vitest';
import ar from './locales/ar.json';
import {
  cellText,
  REPORT_KINDS,
  reportsOf,
  rowName,
  sortRows,
  type ReportTable,
} from './reports.js';
import type { AdminSession } from './session.js';

vi.mock('./api.js', () => ({ api: {} }));

const session = (permissions: string[]) => ({ permissions }) as unknown as AdminSession;

// The words a key names in ar.json, or the fallback, as the page reads them.
const words = (key: string, fallback: string) => {
  const found = key
    .split('.')
    .reduce<unknown>(
      (node, part) =>
        node !== null && typeof node === 'object' ? (node as Record<string, unknown>)[part] : null,
      ar,
    );
  return typeof found === 'string' ? found : fallback;
};

// AP §9.17, §6.2 (slice 2.41).
describe('the reports', () => {
  it('offers each role its own reports, OWN every one', () => {
    expect(reportsOf(session(['reports.all']))).toEqual([...REPORT_KINDS]);
    expect(reportsOf(session(['reports.operations']))).toEqual([
      'orders',
      'timings',
      'restaurants',
      'captains',
      'customers',
      'lost_demand',
    ]);
    expect(reportsOf(session(['reports.support']))).toEqual(['customers']);
    expect(reportsOf(session(['reports.financial']))).toEqual(['codes', 'finance']);
    expect(reportsOf(session(['operations.read']))).toEqual([]);
  });

  it('names every report and explains it', () => {
    expect(Object.keys(ar.reports.kind).toSorted()).toEqual([...REPORT_KINDS].toSorted());
    expect(Object.keys(ar.reports.explain).toSorted()).toEqual([...REPORT_KINDS].toSorted());
  });

  it('shows each kind of cell as it reads', () => {
    expect(cellText({ key: 'success', kind: 'bp' }, '2500', 'TRY', words)).toBe('25.0%');
    expect(cellText({ key: 'average', kind: 'minutes' }, '12.5', 'TRY', words)).toBe('12.5');
    expect(cellText({ key: 'by', kind: 'code' }, 'admin', 'TRY', words)).toBe('العمليات');
    expect(cellText({ key: 'by', kind: 'code' }, 'robot', 'TRY', words)).toBe('robot');
    expect(cellText({ key: 'orders', kind: 'count' }, null, 'TRY', words)).toBe('—');
    expect(cellText({ key: 'sales', kind: 'money' }, '12345', 'TRY', words)).toContain('123.45');
  });

  it('names a row by its label, hour or code list', () => {
    const table = (rowKind: ReportTable['rowKind'], rowCodes: string | null) =>
      ({ key: 't', rowKind, rowCodes, columns: [], rows: [] }) as ReportTable;
    const row = (code: string | null, label: string | null) => ({
      code,
      label,
      currency: null,
      cells: [],
    });
    expect(rowName(table('hour', null), row('9', null), words)).toBe('09:00');
    expect(rowName(table('code', 'outcome'), row('fake', null), words)).toBe('وهمي');
    expect(rowName(table('code', 'cancelReason'), row('changed', 'غيّرت رأيي'), words)).toBe(
      'غيّرت رأيي',
    );
    expect(rowName(table('day', null), row('2026-11-20', null), words)).toBe('2026-11-20');
  });

  it('sorts a ranking by a column, a row without a value last', () => {
    const row = (label: string, value: string | null) => ({
      code: null,
      label,
      currency: null,
      cells: [value],
    });
    const table = {
      key: 'ranking',
      rowKind: 'label',
      rowCodes: null,
      columns: [{ key: 'acceptance', kind: 'bp' }],
      rows: [row('أ', '5000'), row('ب', null), row('ج', '9000'), row('د', '700')],
    } as ReportTable;
    const labels = (descending: boolean) =>
      sortRows(table, 0, descending).map((each) => each.label);
    expect(labels(true)).toEqual(['ج', 'أ', 'د', 'ب']);
    expect(labels(false)).toEqual(['د', 'أ', 'ج', 'ب']);
  });
});
