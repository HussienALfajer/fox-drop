import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { merchantExceptionCauses } from '../cashdesk/index.js';
import { operatingCostCauses } from '../ordering/index.js';
import {
  costReportLabels,
  dailyReportLabels,
  orderHistoryLabels,
  restaurantStatementLabels,
} from './export-labels.js';

// The Excel file names RA §12.5's exceptions as the panel's statement does.
describe('the restaurant statement export', () => {
  it('names every exception with the panel’s words', () => {
    const panel = JSON.parse(
      readFileSync(new URL('../../../../admin/src/locales/ar.json', import.meta.url), 'utf8'),
    ) as { restaurantSettlement: { cause: Record<string, string> } };
    expect(Object.keys(restaurantStatementLabels.causes).toSorted()).toEqual(
      [...merchantExceptionCauses].toSorted(),
    );
    expect(restaurantStatementLabels.causes).toEqual(panel.restaurantSettlement.cause);
  });
});

// The daily report's file names its figures as the panel does (AP §9.10.1).
describe('the daily report export', () => {
  it('names every figure with the panel’s words', () => {
    const panel = JSON.parse(
      readFileSync(new URL('../../../../admin/src/locales/ar.json', import.meta.url), 'utf8'),
    ) as { dailyReport: { line: Record<string, string> } };
    expect(dailyReportLabels.line).toEqual(panel.dailyReport.line);
  });
});

// The cost report's file names its lines as the panel does (AP §9.10.6).
describe('the cost report export', () => {
  it('names every line, cause and party with the panel’s words', () => {
    const panel = JSON.parse(
      readFileSync(new URL('../../../../admin/src/locales/ar.json', import.meta.url), 'utf8'),
    ) as { costReport: Record<string, unknown> };
    // The sheet's name and its two header words are the file's alone.
    const fileOnly = ['sheet', 'period', 'currency'];
    const shared = Object.fromEntries(
      Object.entries(costReportLabels).filter(([key]) => !fileOnly.includes(key)),
    );
    expect(panel.costReport).toMatchObject(shared);
    expect(Object.keys(costReportLabels.operating).toSorted()).toEqual(
      [...operatingCostCauses].toSorted(),
    );
  });
});

// «سجل الطلبات»'s file names its columns and codes as the panel does (AP §9.5).
describe('the order history export', () => {
  it('names every column, status, outcome and party with the panel’s words', () => {
    const panel = JSON.parse(
      readFileSync(new URL('../../../../admin/src/locales/ar.json', import.meta.url), 'utf8'),
    ) as {
      order: { status: object; outcome: object; responsible: object };
      orderHistory: { column: object; title: string; kind: { test: string; real: string } };
    };
    expect(orderHistoryLabels.column).toEqual(panel.orderHistory.column);
    expect(orderHistoryLabels.title).toEqual(panel.orderHistory.title);
    expect(orderHistoryLabels.test).toEqual(panel.orderHistory.kind.test);
    expect(orderHistoryLabels.real).toEqual(panel.orderHistory.kind.real);
    expect(orderHistoryLabels.status).toEqual(panel.order.status);
    expect(orderHistoryLabels.outcome).toEqual(panel.order.outcome);
    expect(orderHistoryLabels.responsible).toEqual(panel.order.responsible);
  });
});
