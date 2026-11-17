// The pure rules of a ticket (AP §9.9.2; owner decisions 2026-11-17, slice
// 2.23a): its priority, its SLA timer and its status moves.

// AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
export const ticketStatuses = ['new', 'in_progress', 'waiting', 'resolved', 'closed'] as const;
export type TicketStatus = (typeof ticketStatuses)[number];

// The party a manual ticket names (owner decision 2026-11-17).
export const ticketParties = ['customer', 'restaurant', 'captain'] as const;
export type TicketParty = (typeof ticketParties)[number];

// AP §9.9.2: the first response for a ticket opened on an active order, the
// resolution for every other one.
export const slaKinds = ['first_response', 'resolution'] as const;
export type SlaKind = (typeof slaKinds)[number];

export type SlaState = 'running' | 'amber' | 'breached' | 'met';

// AP Appendix B: the type comes from the party's list.
export const TICKET_TYPE_LISTS = {
  customer: 'customer_problem',
  restaurant: 'merchant_ticket_type',
  captain: 'captain_ticket_type',
} as const satisfies Record<TicketParty, string>;

// AP §9.9.2: the timer turns amber at 80% (fixed).
const AMBER_SHARE = 0.8;

const OPEN: readonly TicketStatus[] = ['new', 'in_progress', 'waiting'];

export function isOpen(status: TicketStatus): boolean {
  return OPEN.includes(status);
}

// The kinds of ticket whose resolutions differ (AP §9.9.3; slice 2.23b): a
// price difference (linked to a restaurant, not an order) and a pickup
// dispute have fixed types outside the Content lists; every other type is
// general.
export const PRICE_DIFFERENCE_TYPE = 'price_difference';
export const PICKUP_DISPUTE_TYPE = 'pickup_dispute';
export const FIXED_TYPE_LABELS = {
  [PRICE_DIFFERENCE_TYPE]: 'سعر مختلف عن المحل',
  [PICKUP_DISPUTE_TYPE]: 'خلاف على دفعة الاستلام',
} as const;

export const ticketKinds = ['general', 'price_difference', 'pickup_dispute'] as const;
export type TicketKind = (typeof ticketKinds)[number];

export function ticketKind(typeCode: string): TicketKind {
  if (typeCode === PRICE_DIFFERENCE_TYPE) return 'price_difference';
  if (typeCode === PICKUP_DISPUTE_TYPE) return 'pickup_dispute';
  return 'general';
}

// AP §9.9.3: «لا شيء مع توضيح»; a price difference's «تم تصحيح السعر» and
// «السعر صحيح»; a pickup dispute's «دفع الكابتن الفرق», «تصحيح في
// الحسابات» and «الدفعة صحيحة». The compensation code (2.23c) and the free
// re-delivery (2.23d) join the general ones with their slices.
export const ticketResolutions = [
  'none_explained',
  'price_corrected',
  'price_correct',
  'captain_paid',
  'accounts_corrected',
  'payment_correct',
] as const;
export type TicketResolution = (typeof ticketResolutions)[number];

const RESOLUTIONS: Record<TicketKind, readonly TicketResolution[]> = {
  general: ['none_explained'],
  price_difference: ['price_corrected', 'price_correct'],
  pickup_dispute: ['captain_paid', 'accounts_corrected', 'payment_correct'],
};

export function resolutionsOf(kind: TicketKind): readonly TicketResolution[] {
  return RESOLUTIONS[kind];
}

// AP §9.9.3 «Responsible party»: restaurant, captain, customer or platform.
export const responsibleParties = ['restaurant', 'captain', 'customer', 'platform'] as const;
export type ResponsibleParty = (typeof responsibleParties)[number];

export type ResolutionProblem = 'invalid_resolution' | 'responsible_required' | 'lines_required';

// The responsible party is required for a general ticket (AP §9.9.3). A
// price difference needs none, and a pickup dispute's resolution names who
// bears what (decided by us), so neither takes one. The lines the
// restaurant received go with «تصحيح في الحسابات» only.
export function resolutionProblem(input: {
  kind: TicketKind;
  resolution: TicketResolution;
  responsible: ResponsibleParty | null;
  lines: readonly unknown[] | null;
}): ResolutionProblem | null {
  if (!RESOLUTIONS[input.kind].includes(input.resolution)) return 'invalid_resolution';
  if (input.kind === 'general') {
    if (input.responsible === null) return 'responsible_required';
  } else if (input.responsible !== null) {
    return 'invalid_resolution';
  }
  if (input.resolution === 'accounts_corrected') {
    return input.lines === null || input.lines.length === 0 ? 'lines_required' : null;
  }
  return input.lines === null ? null : 'invalid_resolution';
}

// «إغلاق» (owner decision 2026-11-17): an open ticket ends without a
// resolution, message or entries.
export function canClose(status: TicketStatus): boolean {
  return isOpen(status);
}

// «عاجلة» while the ticket is open and its order active; «عادية» otherwise
// (owner decision 2026-11-17: the priority follows the order's state now). A
// pickup-dispute ticket is urgent while open, whatever its order (AP §9.9.2).
export function isUrgent(ticket: {
  status: TicketStatus;
  orderActive: boolean;
  kind: TicketKind;
}): boolean {
  if (!isOpen(ticket.status)) return false;
  return ticket.orderActive || ticket.kind === 'pickup_dispute';
}

// The timer is chosen once, at the opening, and keeps its kind (owner
// decision 2026-11-17).
export function slaAtOpening(input: {
  orderActive: boolean;
  openedAt: Date;
  firstResponseMinutes: number;
  resolutionHours: number;
}): { kind: SlaKind; dueAt: Date } {
  const start = input.openedAt.getTime();
  return input.orderActive
    ? { kind: 'first_response', dueAt: new Date(start + input.firstResponseMinutes * 60_000) }
    : { kind: 'resolution', dueAt: new Date(start + input.resolutionHours * 3_600_000) };
}

export interface SlaTimer {
  startedAt: Date;
  dueAt: Date;
  // When the timer stopped: the first response once the ticket left «جديدة».
  stoppedAt: Date | null;
}

export function slaState(timer: SlaTimer, now: Date): SlaState {
  const end = timer.stoppedAt ?? now;
  if (end.getTime() >= timer.dueAt.getTime()) return 'breached';
  if (timer.stoppedAt !== null) return 'met';
  const start = timer.startedAt.getTime();
  const amberAt = start + (timer.dueAt.getTime() - start) * AMBER_SHARE;
  return now.getTime() >= amberAt ? 'amber' : 'running';
}

export function isBreached(timer: SlaTimer, now: Date): boolean {
  return slaState(timer, now) === 'breached';
}

// When a move to `next` stops the timer: the first response stops when the
// ticket leaves «جديدة»; the resolution runs through «بانتظار رد» (owner
// decision 2026-11-17) and stops only when resolved (2.23b).
export function slaStop(
  ticket: { slaKind: SlaKind; slaStoppedAt: Date | null; status: TicketStatus },
  next: TicketStatus,
  now: Date,
): Date | null {
  if (ticket.slaStoppedAt !== null) return ticket.slaStoppedAt;
  if (ticket.slaKind === 'first_response' && next !== 'new') return now;
  if (next === 'resolved' || next === 'closed') return now;
  return null;
}

// «جديدة» turns «قيد المعالجة» by itself at the first assignment or note.
export function afterFirstHandling(status: TicketStatus): TicketStatus {
  return status === 'new' ? 'in_progress' : status;
}

// By hand only «بانتظار رد» and back to «قيد المعالجة»; «محلولة» only by
// resolving (owner decision 2026-11-17).
export function canSetStatus(from: TicketStatus, to: TicketStatus): boolean {
  if (!isOpen(from) || from === to) return false;
  if (to === 'waiting') return true;
  return to === 'in_progress' && from === 'waiting';
}

// AP §4.8: `T-5521`.
export function ticketLabel(number: bigint): string {
  return `T-${number}`;
}
