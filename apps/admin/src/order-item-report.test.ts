import { describe, expect, it, vi } from 'vitest';
import { canCloseItemReport, closeItemReportBody } from './order-item-report.js';

vi.mock('./api.js', () => ({ api: {} }));

const report = {
  at: '2026-11-10T10:00:00.000Z',
  items: [
    { itemId: '01900000-0000-7000-8000-0000000000b1', name: 'شاورما', until: 'tomorrow' as const },
  ],
  note: { code: 'similar_substitute', label: 'يوجد بديل مشابه' },
};

// AP §9.3.2 «إغلاق بلاغ صنف نفد»: OWN and OPS, while a report is open.
describe('canCloseItemReport', () => {
  const session = (permissions: string[]) => ({ permissions }) as never;
  it('needs operations.manage and an open report', () => {
    expect(canCloseItemReport(session(['operations.manage']), { itemReport: report })).toBe(true);
    expect(canCloseItemReport(session(['operations.read']), { itemReport: report })).toBe(false);
    expect(canCloseItemReport(session(['operations.manage']), { itemReport: null })).toBe(false);
  });
});

describe('closeItemReportBody', () => {
  it('needs the reason', () => {
    expect(closeItemReportBody(' وجد المطعم الصنف ')).toEqual({ reason: 'وجد المطعم الصنف' });
    expect(closeItemReportBody('   ')).toBeNull();
  });
});
