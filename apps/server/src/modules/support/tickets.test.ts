import { describe, expect, it } from 'vitest';
import {
  afterFirstHandling,
  canClose,
  canSetStatus,
  isBreached,
  isUrgent,
  resolutionProblem,
  resolutionsOf,
  slaAtOpening,
  slaState,
  slaStop,
  ticketKind,
  TICKET_TYPE_LISTS,
} from './tickets.js';

const at = (time: string) => new Date(`2026-12-10T${time}Z`);
const rules = { firstResponseMinutes: 15, resolutionHours: 24 };

// AP §9.9.2 and the owner decisions of 2026-11-17 (slice 2.23a): the
// priority, the SLA timer and the status moves of a ticket.
describe('the priority', () => {
  it('is urgent for an open ticket while its order is active', () => {
    expect(isUrgent({ status: 'new', orderActive: true, kind: 'general' })).toBe(true);
    expect(isUrgent({ status: 'in_progress', orderActive: true, kind: 'general' })).toBe(true);
    expect(isUrgent({ status: 'waiting', orderActive: true, kind: 'general' })).toBe(true);
  });

  it('is normal once the order ended, without an order, or once the ticket is resolved', () => {
    expect(isUrgent({ status: 'new', orderActive: false, kind: 'general' })).toBe(false);
    expect(isUrgent({ status: 'resolved', orderActive: true, kind: 'general' })).toBe(false);
    expect(isUrgent({ status: 'closed', orderActive: true, kind: 'general' })).toBe(false);
  });

  it('is urgent for every open pickup-dispute ticket, its order active or not (AP §9.9.2)', () => {
    expect(isUrgent({ status: 'new', orderActive: false, kind: 'pickup_dispute' })).toBe(true);
    expect(isUrgent({ status: 'waiting', orderActive: false, kind: 'pickup_dispute' })).toBe(true);
    expect(isUrgent({ status: 'resolved', orderActive: true, kind: 'pickup_dispute' })).toBe(false);
    expect(isUrgent({ status: 'new', orderActive: false, kind: 'price_difference' })).toBe(false);
  });
});

// AP §9.9.3 (slice 2.23b): the resolutions each kind of ticket allows and
// the responsible party.
describe('the resolution', () => {
  it('reads the kind from the type', () => {
    expect(ticketKind('pickup_dispute')).toBe('pickup_dispute');
    expect(ticketKind('price_difference')).toBe('price_difference');
    expect(ticketKind('missing_item')).toBe('general');
  });

  it('offers each kind its own resolutions', () => {
    expect(resolutionsOf('general')).toEqual(['none_explained']);
    expect(resolutionsOf('price_difference')).toEqual(['price_corrected', 'price_correct']);
    expect(resolutionsOf('pickup_dispute')).toEqual([
      'captain_paid',
      'accounts_corrected',
      'payment_correct',
    ]);
  });

  it('requires the responsible party except for a price difference (AP §9.9.3)', () => {
    const lines = null;
    expect(
      resolutionProblem({
        kind: 'general',
        resolution: 'none_explained',
        responsible: null,
        lines,
      }),
    ).toBe('responsible_required');
    for (const responsible of ['restaurant', 'captain', 'customer', 'platform'] as const) {
      expect(
        resolutionProblem({ kind: 'general', resolution: 'none_explained', responsible, lines }),
      ).toBeNull();
    }
    expect(
      resolutionProblem({
        kind: 'price_difference',
        resolution: 'price_correct',
        responsible: null,
        lines,
      }),
    ).toBeNull();
    expect(
      resolutionProblem({
        kind: 'price_difference',
        resolution: 'price_correct',
        responsible: 'restaurant',
        lines,
      }),
    ).toBe('invalid_resolution');
    expect(
      resolutionProblem({
        kind: 'pickup_dispute',
        resolution: 'captain_paid',
        responsible: null,
        lines,
      }),
    ).toBe('responsible_required');
    expect(
      resolutionProblem({
        kind: 'pickup_dispute',
        resolution: 'captain_paid',
        responsible: 'captain',
        lines,
      }),
    ).toBeNull();
  });

  it("refuses another kind's resolution", () => {
    expect(
      resolutionProblem({
        kind: 'general',
        resolution: 'price_correct',
        responsible: 'platform',
        lines: null,
      }),
    ).toBe('invalid_resolution');
    expect(
      resolutionProblem({
        kind: 'price_difference',
        resolution: 'none_explained',
        responsible: null,
        lines: null,
      }),
    ).toBe('invalid_resolution');
    expect(
      resolutionProblem({
        kind: 'pickup_dispute',
        resolution: 'price_corrected',
        responsible: null,
        lines: null,
      }),
    ).toBe('invalid_resolution');
  });

  it('takes the received lines with «تصحيح في الحسابات» only', () => {
    const lines = [{ currency: 'TRY', amount: 19_500n }];
    expect(
      resolutionProblem({
        kind: 'pickup_dispute',
        resolution: 'accounts_corrected',
        responsible: 'captain',
        lines,
      }),
    ).toBeNull();
    expect(
      resolutionProblem({
        kind: 'pickup_dispute',
        resolution: 'accounts_corrected',
        responsible: 'captain',
        lines: null,
      }),
    ).toBe('lines_required');
    expect(
      resolutionProblem({
        kind: 'pickup_dispute',
        resolution: 'payment_correct',
        responsible: 'captain',
        lines,
      }),
    ).toBe('invalid_resolution');
  });

  it('closes an open ticket only (owner decision 2026-11-17)', () => {
    expect(canClose('new')).toBe(true);
    expect(canClose('in_progress')).toBe(true);
    expect(canClose('waiting')).toBe(true);
    expect(canClose('resolved')).toBe(false);
    expect(canClose('closed')).toBe(false);
  });
});

describe('the SLA timer', () => {
  it('is the first response, from the opening, for a ticket opened on an active order', () => {
    expect(slaAtOpening({ orderActive: true, openedAt: at('12:00:00'), ...rules })).toEqual({
      kind: 'first_response',
      dueAt: at('12:15:00'),
    });
  });

  it('is the resolution, from the opening, for every other ticket', () => {
    expect(slaAtOpening({ orderActive: false, openedAt: at('12:00:00'), ...rules })).toEqual({
      kind: 'resolution',
      dueAt: new Date('2026-12-11T12:00:00Z'),
    });
  });

  const timer = { startedAt: at('12:00:00'), dueAt: at('12:15:00'), stoppedAt: null };

  it('turns amber at 80% and is breached at its end', () => {
    expect(slaState(timer, at('12:11:59'))).toBe('running');
    expect(slaState(timer, at('12:12:00'))).toBe('amber');
    expect(slaState(timer, at('12:14:59'))).toBe('amber');
    expect(slaState(timer, at('12:15:00'))).toBe('breached');
    expect(isBreached(timer, at('12:14:59'))).toBe(false);
    expect(isBreached(timer, at('12:15:00'))).toBe(true);
  });

  it('is met when stopped in time, and stays breached when stopped late', () => {
    expect(slaState({ ...timer, stoppedAt: at('12:14:00') }, at('13:00:00'))).toBe('met');
    expect(slaState({ ...timer, stoppedAt: at('12:16:00') }, at('13:00:00'))).toBe('breached');
  });

  it('stops the first response when the ticket leaves «جديدة»', () => {
    const ticket = { slaKind: 'first_response', slaStoppedAt: null, status: 'new' } as const;
    expect(slaStop(ticket, 'in_progress', at('12:05:00'))).toEqual(at('12:05:00'));
    expect(slaStop(ticket, 'waiting', at('12:05:00'))).toEqual(at('12:05:00'));
    expect(slaStop(ticket, 'new', at('12:05:00'))).toBeNull();
    // Stopped once: a later move keeps the first moment.
    expect(
      slaStop(
        { ...ticket, status: 'in_progress', slaStoppedAt: at('12:05:00') },
        'waiting',
        at('12:30:00'),
      ),
    ).toEqual(at('12:05:00'));
  });

  it('keeps the resolution running through «قيد المعالجة» and «بانتظار رد»', () => {
    const ticket = { slaKind: 'resolution', slaStoppedAt: null, status: 'new' } as const;
    expect(slaStop(ticket, 'in_progress', at('12:05:00'))).toBeNull();
    expect(slaStop({ ...ticket, status: 'in_progress' }, 'waiting', at('12:05:00'))).toBeNull();
  });
});

describe('the status', () => {
  it('turns «قيد المعالجة» by itself at the first assignment or note', () => {
    expect(afterFirstHandling('new')).toBe('in_progress');
    expect(afterFirstHandling('in_progress')).toBe('in_progress');
    expect(afterFirstHandling('waiting')).toBe('waiting');
  });

  it('is set by hand between «قيد المعالجة» and «بانتظار رد» only', () => {
    expect(canSetStatus('new', 'waiting')).toBe(true);
    expect(canSetStatus('in_progress', 'waiting')).toBe(true);
    expect(canSetStatus('waiting', 'in_progress')).toBe(true);
    expect(canSetStatus('new', 'in_progress')).toBe(false);
    expect(canSetStatus('waiting', 'waiting')).toBe(false);
    // «محلولة» only by resolving (2.23b), never by hand.
    expect(canSetStatus('in_progress', 'resolved')).toBe(false);
    expect(canSetStatus('in_progress', 'closed')).toBe(false);
    expect(canSetStatus('resolved', 'in_progress')).toBe(false);
    expect(canSetStatus('closed', 'waiting')).toBe(false);
  });
});

describe('the type', () => {
  it("comes from the party's list of AP Appendix B", () => {
    expect(TICKET_TYPE_LISTS).toEqual({
      customer: 'customer_problem',
      restaurant: 'merchant_ticket_type',
      captain: 'captain_ticket_type',
    });
  });
});
