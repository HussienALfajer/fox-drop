import { describe, expect, it } from 'vitest';
import { priceReportProblem, REPORT_PHOTOS_MAX, reportProblem, reportUntil } from './reports.js';

const at = (time: string) => new Date(`2026-12-10T${time}Z`);
const delivered = { status: 'delivered' as const, deliveredAt: at('12:00:00') };
const lines = [
  { position: 1, quantity: 2 },
  { position: 2, quantity: 1 },
];
const report = {
  ...delivered,
  windowHours: 24,
  now: at('13:00:00'),
  reported: false,
  typeCode: 'missing_item',
  items: [{ position: 1, quantity: 1 }],
  lines,
  photos: 0,
};

// CU §12.2, AP §9.9.1 (slice 2.24a): the customer's «الإبلاغ عن مشكلة».
describe('the window', () => {
  it('is open for customer.report_problem_window_hours after the delivery', () => {
    expect(reportUntil(delivered, 24)).toEqual(new Date('2026-12-11T12:00:00Z'));
    expect(reportProblem({ ...report, now: new Date('2026-12-11T11:59:59Z') })).toBeNull();
  });

  it('closes at its end', () => {
    expect(reportProblem({ ...report, now: new Date('2026-12-11T12:00:00Z') })).toBe(
      'report_closed',
    );
  });

  it('never opens for an order that was not delivered', () => {
    for (const status of ['placed', 'picked_up', 'arrived', 'failed', 'cancelled', 'rejected']) {
      expect(reportUntil({ status, deliveredAt: null }, 24)).toBeNull();
      expect(reportProblem({ ...report, status, deliveredAt: null })).toBe('report_closed');
    }
  });
});

describe('one report per order (Q17)', () => {
  it('refuses a second report', () => {
    expect(reportProblem({ ...report, reported: true })).toBe('already_reported');
  });
});

describe('the items', () => {
  it('are required for «صنف ناقص», «صنف خطأ» and «الطلب تالف»', () => {
    for (const typeCode of ['missing_item', 'wrong_item', 'damaged_order']) {
      expect(reportProblem({ ...report, typeCode, items: [] })).toBe('items_required');
      expect(reportProblem({ ...report, typeCode })).toBeNull();
    }
  });

  it('are not taken by the other types', () => {
    expect(reportProblem({ ...report, typeCode: 'cold_food', items: [] })).toBeNull();
    expect(reportProblem({ ...report, typeCode: 'cold_food' })).toBe('invalid_items');
  });

  it("are the order's lines, each once, within its quantity", () => {
    const problem = (items: { position: number; quantity: number }[]) =>
      reportProblem({ ...report, items });
    expect(problem([{ position: 1, quantity: 2 }])).toBeNull();
    expect(
      problem([
        { position: 1, quantity: 1 },
        { position: 2, quantity: 1 },
      ]),
    ).toBeNull();
    expect(problem([{ position: 3, quantity: 1 }])).toBe('invalid_items');
    expect(problem([{ position: 1, quantity: 3 }])).toBe('invalid_items');
    expect(problem([{ position: 1, quantity: 0 }])).toBe('invalid_items');
    expect(
      problem([
        { position: 1, quantity: 1 },
        { position: 1, quantity: 1 },
      ]),
    ).toBe('invalid_items');
  });
});

describe('the photos', () => {
  it('are at most 3 (fixed)', () => {
    expect(REPORT_PHOTOS_MAX).toBe(3);
    expect(reportProblem({ ...report, photos: 3 })).toBeNull();
    expect(reportProblem({ ...report, photos: 4 })).toBe('too_many_photos');
  });
});

// CU §9.5: «أبلغ عن سعر مختلف».
describe('the price report', () => {
  it('takes at most one photo', () => {
    expect(priceReportProblem({ photos: 1, shopPrice: null })).toBeNull();
    expect(priceReportProblem({ photos: 2, shopPrice: null })).toBe('too_many_photos');
  });

  it('takes a shop price above zero', () => {
    expect(priceReportProblem({ photos: 0, shopPrice: 1500n })).toBeNull();
    expect(priceReportProblem({ photos: 0, shopPrice: 0n })).toBe('invalid_price');
  });
});
