import { describe, expect, it } from 'vitest';
import {
  CAPTAIN_REPORT_PHOTOS_MAX,
  captainProblemProblem,
  captainReportProblem,
  PICKUP_AMOUNT_REASON,
  seesCaptainTicket,
} from './captain-reports.js';

const captainId = '0190a000-0000-7000-8000-000000000001';
const otherCaptain = '0190a000-0000-7000-8000-000000000002';

// CA §13 «بلاغاتي»: the captain's own tickets, whoever opened them.
describe("who sees a ticket in the captain's «بلاغاتي»", () => {
  it("shows the captain every ticket whose party they are, the panel's included", () => {
    expect(seesCaptainTicket(captainId, { party: 'captain', partyId: captainId })).toBe(true);
  });

  it("never shows another captain's ticket or another party's", () => {
    expect(seesCaptainTicket(captainId, { party: 'captain', partyId: otherCaptain })).toBe(false);
    expect(seesCaptainTicket(captainId, { party: 'restaurant', partyId: captainId })).toBe(false);
    expect(seesCaptainTicket(captainId, { party: 'customer', partyId: captainId })).toBe(false);
  });
});

// CA §13: «إبلاغ عن مشكلة» takes a type, optionally an order, a note and a
// photo.
describe("the captain's report", () => {
  it('takes one photo at most', () => {
    expect(captainReportProblem({ photos: 0 })).toBeNull();
    expect(captainReportProblem({ photos: CAPTAIN_REPORT_PHOTOS_MAX })).toBeNull();
    expect(captainReportProblem({ photos: CAPTAIN_REPORT_PHOTOS_MAX + 1 })).toBe('too_many_photos');
  });
});

// CA §9.11, §9.4 item 6 (owner decision 2026-11-17): «مشكلة في مبلغ
// الاستلام» names the lines the captain handed the restaurant; no other
// quick reason takes lines.
describe("the captain's problem on an order", () => {
  it('asks the pickup amount for its lines', () => {
    expect(captainProblemProblem({ reasonCode: PICKUP_AMOUNT_REASON, lines: 1 })).toBeNull();
    expect(captainProblemProblem({ reasonCode: PICKUP_AMOUNT_REASON, lines: null })).toBe(
      'lines_required',
    );
    expect(captainProblemProblem({ reasonCode: PICKUP_AMOUNT_REASON, lines: 0 })).toBe(
      'lines_required',
    );
  });

  it('refuses lines with any other reason', () => {
    expect(captainProblemProblem({ reasonCode: 'restaurant_late', lines: null })).toBeNull();
    expect(captainProblemProblem({ reasonCode: 'restaurant_late', lines: 1 })).toBe(
      'lines_not_allowed',
    );
  });
});
