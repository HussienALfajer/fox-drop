// The pure rules of the restaurant app's support (RA §15, §8.19, §16 #29;
// slice 2.24b).

// RA §15: «إبلاغ عن مشكلة» takes «a photo».
export const MERCHANT_REPORT_PHOTOS_MAX = 1;

// RA Appendix C: «طلب تعديل بيانات» (its code in Content's
// merchant_ticket_type list) and what it may ask to change (RA §15; owner
// decision 2026-11-17: a subject and a note, the change made by hand).
export const DATA_CHANGE_TYPE = 'data_change';
export const dataChangeSubjects = ['min_order', 'coverage', 'owners', 'owner_phone'] as const;
export type DataChangeSubject = (typeof dataChangeSubjects)[number];

// The tickets the restaurant app opens: «إبلاغ عن مشكلة» (RA §15) and
// «مشكلة في الطلب» (RA §8.19). The pickup dispute (RA §8.10) is opened by a
// restaurant's user too.
export const MERCHANT_OPENED_SOURCES: readonly string[] = [
  'merchant_report',
  'order_problem',
  'pickup_dispute',
];

export type MerchantReportProblem = 'too_many_photos' | 'subject_required' | 'invalid_subject';

// A photo at most; a data change names its subject, and no other type does.
export function merchantReportProblem(input: {
  typeCode: string;
  subject: DataChangeSubject | null;
  photos: number;
}): MerchantReportProblem | null {
  if (input.photos > MERCHANT_REPORT_PHOTOS_MAX) return 'too_many_photos';
  if (input.typeCode === DATA_CHANGE_TYPE) {
    return input.subject === null ? 'subject_required' : null;
  }
  return input.subject === null ? null : 'invalid_subject';
}

// RA §15 «بلاغاتي» (owner decision 2026-11-17): an owner sees every ticket
// whose party is the restaurant, whoever opened it; a cashier only the ones
// they opened.
export function seesTicket(
  viewer: { role: 'owner' | 'cashier'; accountId: string; restaurantId: string },
  ticket: { party: string; partyId: string; openedBy: string },
): boolean {
  if (ticket.party !== 'restaurant' || ticket.partyId !== viewer.restaurantId) return false;
  return viewer.role === 'owner' || ticket.openedBy === viewer.accountId;
}

// RA §16 #29 (owner decision 2026-11-17): besides the owners, «تم حل بلاغك»
// reaches the restaurant's user who opened the ticket from the app; a
// ticket the panel opened reaches the owners only.
export function reporterOf(ticket: {
  party: string;
  source: string;
  openedBy: string;
}): string | null {
  return ticket.party === 'restaurant' && MERCHANT_OPENED_SOURCES.includes(ticket.source)
    ? ticket.openedBy
    : null;
}
