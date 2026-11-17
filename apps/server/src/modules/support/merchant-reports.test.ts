import { describe, expect, it } from 'vitest';
import {
  DATA_CHANGE_TYPE,
  MERCHANT_REPORT_PHOTOS_MAX,
  merchantReportProblem,
  reporterOf,
  seesTicket,
} from './merchant-reports.js';

const restaurantId = '0190a000-0000-7000-8000-000000000001';
const otherRestaurant = '0190a000-0000-7000-8000-000000000002';
const owner = { role: 'owner' as const, accountId: 'owner-1', restaurantId };
const cashier = { role: 'cashier' as const, accountId: 'cashier-1', restaurantId };

const ticket = (openedBy: string, partyId = restaurantId, party = 'restaurant' as const) => ({
  party,
  partyId,
  openedBy,
});

// RA §15 «بلاغاتي» (owner decision 2026-11-17): owners see every ticket of
// the restaurant; cashiers the ones they opened.
describe('who sees a ticket in «بلاغاتي»', () => {
  it('shows an owner every ticket of the restaurant, whoever opened it', () => {
    expect(seesTicket(owner, ticket('cashier-1'))).toBe(true);
    expect(seesTicket(owner, ticket('owner-2'))).toBe(true);
    expect(seesTicket(owner, ticket('admin-1'))).toBe(true);
  });

  it('shows a cashier only the tickets they opened', () => {
    expect(seesTicket(cashier, ticket('cashier-1'))).toBe(true);
    expect(seesTicket(cashier, ticket('cashier-2'))).toBe(false);
    expect(seesTicket(cashier, ticket('owner-1'))).toBe(false);
    expect(seesTicket(cashier, ticket('admin-1'))).toBe(false);
  });

  it("never shows another restaurant's ticket or another party's", () => {
    expect(seesTicket(owner, ticket('cashier-1', otherRestaurant))).toBe(false);
    expect(seesTicket(cashier, ticket('cashier-1', otherRestaurant))).toBe(false);
    expect(
      seesTicket(owner, { party: 'customer', partyId: restaurantId, openedBy: 'cashier-1' }),
    ).toBe(false);
  });
});

// RA §15, Appendix C: «إبلاغ عن مشكلة» with a type, an optional order, a
// note and a photo; «طلب تعديل بيانات» names its subject (owner decision
// 2026-11-17).
describe("the restaurant's report", () => {
  const report = { typeCode: 'finance_inquiry', subject: null, photos: 0 };

  it('takes a type with a photo at most', () => {
    expect(MERCHANT_REPORT_PHOTOS_MAX).toBe(1);
    expect(merchantReportProblem(report)).toBeNull();
    expect(merchantReportProblem({ ...report, photos: 1 })).toBeNull();
    expect(merchantReportProblem({ ...report, photos: 2 })).toBe('too_many_photos');
  });

  it('asks a data change for its subject', () => {
    expect(merchantReportProblem({ ...report, typeCode: DATA_CHANGE_TYPE })).toBe(
      'subject_required',
    );
    for (const subject of ['min_order', 'coverage', 'owners', 'owner_phone'] as const) {
      expect(merchantReportProblem({ ...report, typeCode: DATA_CHANGE_TYPE, subject })).toBeNull();
    }
  });

  it('takes a subject with a data change only', () => {
    expect(merchantReportProblem({ ...report, subject: 'coverage' })).toBe('invalid_subject');
  });
});

// RA §16 #29 (owner decision 2026-11-17): «تم حل بلاغك» goes to the owners
// and to the restaurant's user who reported.
describe('the reporter told of the resolution', () => {
  it("is the restaurant's user who opened it from the app", () => {
    for (const source of ['merchant_report', 'order_problem', 'pickup_dispute'] as const) {
      expect(reporterOf({ party: 'restaurant', source, openedBy: 'cashier-1' })).toBe('cashier-1');
    }
  });

  it('is nobody beyond the owners for a ticket the panel opened', () => {
    expect(reporterOf({ party: 'restaurant', source: 'manual', openedBy: 'admin-1' })).toBeNull();
  });

  it("is nobody for another party's ticket", () => {
    expect(
      reporterOf({ party: 'customer', source: 'customer_report', openedBy: 'customer-1' }),
    ).toBeNull();
  });
});
