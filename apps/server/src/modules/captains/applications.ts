import type { Vehicle } from '../settings/index.js';
import type { applicationDocumentKinds, applicationStages } from './schema.js';

// The pure rules of the application form (CA §5.2–5.3, AP §9.7.1; slice
// 2.34a). Dates are the city's calendar days as YYYY-MM-DD.

export type ApplicationDocumentKind = (typeof applicationDocumentKinds)[number];

// A motor vehicle needs its plate and papers; only licensed vehicles are
// accepted (CA §5.2 step 2).
export function isMotorVehicle(vehicle: Vehicle): boolean {
  return vehicle === 'motorbike' || vehicle === 'car';
}

// The documents «إرسال الطلب» waits for (CA §5.3): the driving licence is
// optional, the vehicle papers only for a motor vehicle.
export function requiredDocuments(vehicle: Vehicle | null): ApplicationDocumentKind[] {
  const always: ApplicationDocumentKind[] = [
    'national_id',
    'personal_photo',
    'civil_registry',
    'criminal_record',
  ];
  return vehicle !== null && isMotorVehicle(vehicle) ? [...always, 'vehicle_papers'] : always;
}

// How many files each document takes: the ID's front and back, one or two
// pages of the others (decided by us).
export function fileCountAllowed(kind: ApplicationDocumentKind, count: number): boolean {
  if (kind === 'national_id') return count === 2;
  // The signed contract's pages, up to CONTRACT_PAGES_MAX (decided by us).
  return count >= 1 && count <= (kind === 'signed_contract' ? CONTRACT_PAGES_MAX : 2);
}

export const CONTRACT_PAGES_MAX = 6;

// What the application still needs before it is sent, in the form's order:
// the vehicle (step 2), each required document in force (step 3), the
// captain terms accepted (step 4). Step 1 is the application itself.
export type Missing = 'vehicle' | `document:${ApplicationDocumentKind}` | 'terms';

export function missing(application: {
  vehicle: Vehicle | null;
  documents: { kind: ApplicationDocumentKind; expiresOn: string | null }[];
  termsPending: boolean;
  today: string;
}): Missing[] {
  const found: Missing[] = application.vehicle === null ? ['vehicle'] : [];
  for (const kind of requiredDocuments(application.vehicle)) {
    const document = application.documents.find((each) => each.kind === kind);
    // An expired criminal record (C18) is as good as none.
    if (!document || (document.expiresOn !== null && document.expiresOn <= application.today)) {
      found.push(`document:${kind}`);
    }
  }
  if (application.termsPending) found.push('terms');
  return found;
}

// A full three-part name (CA §5.2 step 1): three words at least, 80
// characters at most (decided by us).
export function normaliseFullName(name: string): string | null {
  const words = name
    .trim()
    .split(/\s+/u)
    .filter((word) => word.length > 0);
  const joined = words.join(' ');
  return words.length >= 3 && joined.length <= 80 ? joined : null;
}

// A plate as written on it, 1 to 20 characters (decided by us); null when
// empty.
export function normalisePlate(plate: string | null | undefined): string | null {
  const trimmed = plate?.trim().replace(/\s+/gu, ' ') ?? '';
  return trimmed.length >= 1 && trimmed.length <= 20 ? trimmed : null;
}

// The ID's number as its digits, 5 to 20 of them (decided by us), so the
// duplicate check (slice 2.34b) compares like with like.
export function normaliseIdNumber(number: string | null | undefined): string | null {
  const digits = (number ?? '').replace(/[\s-]/gu, '');
  return /^\d{5,20}$/u.test(digits) ? digits : null;
}

// The day `months` after `day`, clamped to the month's last day.
export function addMonths(day: string, months: number): string {
  const [year, month, date] = day.split('-').map(Number) as [number, number, number];
  const target = new Date(Date.UTC(year, month - 1 + months, 1));
  const last = new Date(
    Date.UTC(target.getUTCFullYear(), target.getUTCMonth() + 1, 0),
  ).getUTCDate();
  target.setUTCDate(Math.min(date, last));
  return target.toISOString().slice(0, 10);
}

// Whether someone born on `birthDate` is at least `minAge` on `today`
// (`captain.min_age`, AP Appendix A).
export function oldEnough(birthDate: string, minAge: number, today: string): boolean {
  return addMonths(birthDate, minAge * 12) <= today;
}

// The criminal record's expiry: its issue date plus
// `captain.criminal_record_validity_months` (C18, AP §9.7.1).
export function criminalRecordExpiry(issueDate: string, validityMonths: number): string {
  return addMonths(issueDate, validityMonths);
}

// The day `days` after `day`.
export function addDays(day: string, days: number): string {
  const date = new Date(`${day}T00:00:00Z`);
  date.setUTCDate(date.getUTCDate() + days);
  return date.toISOString().slice(0, 10);
}

// AP §9.7.2, D24: the probation ends `captain.probation_days` after the
// start; the commitment lasts `captain.min_commitment_months` from the
// probation's confirmation, which is the probation's end when confirmed on
// time.
export function contractDates(contract: {
  startsOn: string;
  probationDays: number;
  commitmentMonths: number;
}): { probationEndsOn: string; commitmentEndsOn: string } {
  const probationEndsOn = addDays(contract.startsOn, contract.probationDays);
  return {
    probationEndsOn,
    commitmentEndsOn: addMonths(probationEndsOn, contract.commitmentMonths),
  };
}

// AP §9.7.1 «تفعيل»: what the activation still waits for, in the order of
// its conditions. The training passed is the stage «بانتظار العدة» itself;
// the vehicle is the application's (step 2). Each required document and the
// signed contract must be accepted and not expired.
export type ActivationMissing =
  `document:${ApplicationDocumentKind}` | 'kit' | 'deposit' | 'contract' | 'cash_limit';

export function activationMissing(application: {
  vehicle: Vehicle;
  documents: {
    kind: ApplicationDocumentKind;
    status: 'pending' | 'accepted' | 'rejected';
    expiresOn: string | null;
  }[];
  kitIssued: boolean;
  depositRecorded: boolean;
  contractRecorded: boolean;
  cashLimitSet: boolean;
  today: string;
}): ActivationMissing[] {
  const found: ActivationMissing[] = [];
  for (const kind of [...requiredDocuments(application.vehicle), 'signed_contract' as const]) {
    const document = application.documents.find((each) => each.kind === kind);
    if (
      !document ||
      document.status !== 'accepted' ||
      (document.expiresOn !== null && document.expiresOn <= application.today)
    ) {
      found.push(`document:${kind}`);
    }
  }
  if (!application.kitIssued) found.push('kit');
  if (!application.depositRecorded) found.push('deposit');
  if (!application.contractRecorded) found.push('contract');
  if (!application.cashLimitSet) found.push('cash_limit');
  return found;
}

// AP §8.5.5 step 2: the instalment a Thursday settlement posts, never more
// than what is left of the deposit (owner decision 2026-11-19).
export function depositInstalmentDue(deposit: {
  amount: bigint;
  paid: bigint;
  instalment: bigint | null;
}): bigint {
  const left = deposit.amount - deposit.paid;
  if (deposit.instalment === null || left <= 0n) return 0n;
  return left < deposit.instalment ? left : deposit.instalment;
}

// The calendar day of a moment on a city's clock.
export function cityDay(at: Date, timeZone: string): string {
  return new Intl.DateTimeFormat('en-CA', { timeZone }).format(at);
}

// AP §9.7.1, CA §5.4 (slice 2.34b): the panel's pipeline.

export type ApplicationStage = (typeof applicationStages)[number];

// K11: a rejected applicant applies again 30 days after the rejection
// (fixed).
export const REAPPLY_DAYS = 30;

export function reapplyFrom(rejectedAt: Date): Date {
  return new Date(rejectedAt.getTime() + REAPPLY_DAYS * 24 * 60 * 60 * 1000);
}

// The panel's actions on a sent application.
export type PipelineAction =
  | 'review_document'
  | 'upload_document'
  | 'request_document'
  | 'note'
  | 'schedule_interview'
  | 'training_passed'
  | 'reject'
  | 'waitlist'
  | 'back_from_waitlist'
  // At «بانتظار العدة» (slice 2.35a): the activation's records, then
  // «تفعيل».
  | 'issue_kit'
  | 'set_cash_limit'
  | 'record_contract'
  | 'record_deposit'
  | 'activate';

// The stages each action takes an application in, and where it leaves it
// (null: where it was). «مفعّل» is the activation's (2.35).
const OPEN: readonly ApplicationStage[] = [
  'new',
  'under_review',
  'interview',
  'awaiting_kit',
  'waitlist',
];
const PIPELINE: Record<
  PipelineAction,
  { from: readonly ApplicationStage[]; to: ApplicationStage | null }
> = {
  review_document: { from: OPEN, to: null },
  upload_document: { from: OPEN, to: null },
  request_document: { from: OPEN, to: null },
  note: { from: OPEN, to: null },
  schedule_interview: { from: ['new', 'under_review', 'interview'], to: 'interview' },
  training_passed: { from: ['interview'], to: 'awaiting_kit' },
  reject: { from: OPEN, to: 'rejected' },
  waitlist: { from: ['new', 'under_review', 'interview', 'awaiting_kit'], to: 'waitlist' },
  // Owner decision 2026-11-19: back to «قيد المراجعة».
  back_from_waitlist: { from: ['waitlist'], to: 'under_review' },
  issue_kit: { from: ['awaiting_kit'], to: null },
  set_cash_limit: { from: ['awaiting_kit'], to: null },
  record_contract: { from: ['awaiting_kit'], to: null },
  record_deposit: { from: ['awaiting_kit'], to: null },
  activate: { from: ['awaiting_kit'], to: 'active' },
};

// The stages an action passes through from `stage`, in order, or null when
// it may not be taken there. The first staff action on a «جديد»
// application moves it to «قيد المراجعة» first (owner decision 2026-11-19).
export function pipelineSteps(
  action: PipelineAction,
  stage: ApplicationStage,
): ApplicationStage[] | null {
  const rule = PIPELINE[action];
  if (!rule.from.includes(stage)) return null;
  const steps: ApplicationStage[] = stage === 'new' ? ['under_review'] : [];
  if (rule.to !== null && rule.to !== steps.at(-1)) steps.push(rule.to);
  return steps;
}

// CA §5.3 (slice 2.34b): after «إرسال الطلب» the applicant uploads again only
// a document the panel asked for or rejected, while the application is
// open.
export function mayUploadAgain(
  stage: ApplicationStage,
  document: { requested: boolean; rejected: boolean },
): boolean {
  return OPEN.includes(stage) && (document.requested || document.rejected);
}

// The duplicate check compares plates without spaces, in lower case.
export function plateKey(plate: string): string {
  return plate.replace(/\s+/gu, '').toLowerCase();
}
