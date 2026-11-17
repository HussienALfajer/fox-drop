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

// «عاجلة» while the ticket is open and its order active; «عادية» otherwise
// (owner decision 2026-11-17: the priority follows the order's state now).
export function isUrgent(ticket: { status: TicketStatus; orderActive: boolean }): boolean {
  return ticket.orderActive && isOpen(ticket.status);
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
