import type { Vehicle } from '../settings/index.js';
import type { applicationDocumentKinds } from './schema.js';

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
  return kind === 'national_id' ? count === 2 : count >= 1 && count <= 2;
}

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

// The calendar day of a moment on a city's clock.
export function cityDay(at: Date, timeZone: string): string {
  return new Intl.DateTimeFormat('en-CA', { timeZone }).format(at);
}
