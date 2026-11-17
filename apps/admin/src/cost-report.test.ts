import { describe, expect, it, vi } from 'vitest';
import ar from './locales/ar.json';
import { compensationName, operatingKeys, partyKeys, totalLines } from './cost-report.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.10.6: every line the screen and the Excel file show has its words
// (the server's export reads the same words).
describe('the cost report words', () => {
  it('names every total, operating cause and party', () => {
    expect([...totalLines].toSorted()).toEqual(Object.keys(ar.costReport.line).toSorted());
    expect(Object.keys(operatingKeys).toSorted()).toEqual(
      Object.keys(ar.costReport.operating).toSorted(),
    );
    expect([...Object.keys(partyKeys), 'none'].toSorted()).toEqual(
      Object.keys(ar.costReport.party).toSorted(),
    );
  });

  it('names a compensation line by its reason’s label, the late codes apart', () => {
    expect(compensationName({ kind: 'reason', label: 'تأخير' })).toEqual({ label: 'تأخير' });
    expect(compensationName({ kind: 'late_delivery', label: null })).toEqual({
      key: 'costReport.lateDelivery',
    });
    expect(compensationName({ kind: 'other', label: null })).toEqual({
      key: 'costReport.operating.other',
    });
  });
});
