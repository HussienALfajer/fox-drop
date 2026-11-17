import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { merchantExceptionCauses } from '../cashdesk/index.js';
import { operatingCostCauses } from '../ordering/index.js';
import { costReportLabels, dailyReportLabels, restaurantStatementLabels } from './export-labels.js';

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
