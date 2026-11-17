// The pure rules of the captain app's support (CA §13, §9.11, §9.4 item 6;
// slice 2.24c).

// CA §13: «إبلاغ عن مشكلة» takes «a photo».
export const CAPTAIN_REPORT_PHOTOS_MAX = 1;

// CA Appendix C: «مشكلة في مبلغ الاستلام», the quick reason of Content's
// captain_problem list that opens the pickup dispute's ticket (CA §9.4
// item 6) rather than a general one.
export const PICKUP_AMOUNT_REASON = 'pickup_amount';

export type CaptainReportProblem = 'too_many_photos';

export function captainReportProblem(input: { photos: number }): CaptainReportProblem | null {
  return input.photos > CAPTAIN_REPORT_PHOTOS_MAX ? 'too_many_photos' : null;
}

export type CaptainProblemProblem = 'lines_required' | 'lines_not_allowed';

// Owner decision 2026-11-17: «مشكلة في مبلغ الاستلام» names the lines the
// captain actually handed the restaurant; no other quick reason takes any.
export function captainProblemProblem(input: {
  reasonCode: string;
  lines: number | null;
}): CaptainProblemProblem | null {
  if (input.reasonCode === PICKUP_AMOUNT_REASON) {
    return input.lines === null || input.lines === 0 ? 'lines_required' : null;
  }
  return input.lines === null ? null : 'lines_not_allowed';
}

// CA §13 «بلاغاتي»: the captain's tickets, whoever opened them (the app or
// the panel).
export function seesCaptainTicket(
  captainId: string,
  ticket: { party: string; partyId: string },
): boolean {
  return ticket.party === 'captain' && ticket.partyId === captainId;
}
