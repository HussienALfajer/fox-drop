import { describe, expect, it } from 'vitest';
import {
  afterFirstHandling,
  canClose,
  canSetStatus,
  isBreached,
  isUrgent,
  moneyProblem,
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
    expect(resolutionsOf('general')).toEqual([
      'compensation_code',
      'free_redelivery',
      'none_explained',
    ]);
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

// AP §8.10, §9.9.3, §6.4 (slice 2.23c): the money a general ticket's
// resolution may carry.
describe('the money of a resolution', () => {
  const missing = {
    kind: 'general' as const,
    party: 'customer' as const,
    typeCode: 'missing_item',
    resolution: 'compensation_code' as const,
    responsible: 'restaurant' as const,
    hasOrder: true,
    deliveredNormally: true,
    affectedLines: 1,
    shortAmount: null,
    codeValue: true,
  };
  const wrong = {
    ...missing,
    typeCode: 'amount_or_change',
    responsible: 'captain' as const,
    affectedLines: 0,
    shortAmount: 2_000n,
    codeValue: false,
  };

  it('takes the affected items and a code with its value on a delivered order', () => {
    expect(moneyProblem(missing)).toBeNull();
    expect(moneyProblem({ ...missing, resolution: 'none_explained', codeValue: false })).toBeNull();
    expect(moneyProblem({ ...missing, affectedLines: 0 })).toBeNull();
  });

  it('asks nothing of a resolution without money', () => {
    expect(
      moneyProblem({
        ...missing,
        resolution: 'none_explained',
        affectedLines: 0,
        codeValue: false,
        hasOrder: false,
        party: 'restaurant',
      }),
    ).toBeNull();
  });

  it('needs an order, a customer ticket and a value for the code', () => {
    expect(moneyProblem({ ...missing, hasOrder: false })).toBe('order_required');
    expect(moneyProblem({ ...missing, party: 'captain' })).toBe('invalid_resolution');
    expect(moneyProblem({ ...missing, codeValue: false })).toBe('value_required');
    expect(moneyProblem({ ...missing, resolution: 'none_explained' })).toBe('invalid_resolution');
  });

  it('gives no code when the customer is responsible', () => {
    expect(moneyProblem({ ...missing, responsible: 'customer' })).toBe('invalid_resolution');
  });

  it('takes the affected items only after a normal delivery', () => {
    expect(
      moneyProblem({
        ...missing,
        deliveredNormally: false,
        resolution: 'none_explained',
        codeValue: false,
      }),
    ).toBe('not_delivered');
    // A code alone can go with an order in any state.
    expect(moneyProblem({ ...missing, deliveredNormally: false, affectedLines: 0 })).toBeNull();
  });

  it('takes M for the wrong change, its code without a value, and no items', () => {
    expect(moneyProblem(wrong)).toBeNull();
    expect(moneyProblem({ ...wrong, resolution: 'none_explained' })).toBeNull();
    expect(moneyProblem({ ...wrong, shortAmount: null })).toBe('amount_required');
    expect(moneyProblem({ ...wrong, codeValue: true })).toBe('invalid_resolution');
    expect(moneyProblem({ ...wrong, affectedLines: 1 })).toBe('invalid_resolution');
    expect(moneyProblem({ ...wrong, responsible: 'restaurant' })).toBe('invalid_resolution');
    expect(moneyProblem({ ...missing, shortAmount: 2_000n })).toBe('invalid_resolution');
    expect(moneyProblem({ ...wrong, responsible: 'customer', resolution: 'none_explained' })).toBe(
      'invalid_resolution',
    );
    expect(
      moneyProblem({
        ...wrong,
        responsible: 'customer',
        resolution: 'none_explained',
        shortAmount: null,
      }),
    ).toBeNull();
    expect(moneyProblem({ ...wrong, deliveredNormally: false })).toBe('not_delivered');
  });

  // AP §9.9.3, docs/domain/10 (slice 2.23d).
  it('re-delivers the affected items of a normal delivery, never with the customer responsible', () => {
    const redelivery = {
      ...missing,
      resolution: 'free_redelivery' as const,
      codeValue: false,
      chargePay: false,
    };
    expect(moneyProblem(redelivery)).toBeNull();
    expect(moneyProblem({ ...redelivery, responsible: 'captain', chargePay: true })).toBeNull();
    expect(moneyProblem({ ...redelivery, responsible: 'platform' })).toBeNull();
    expect(moneyProblem({ ...redelivery, affectedLines: 0 })).toBe('affected_required');
    expect(moneyProblem({ ...redelivery, responsible: 'customer' })).toBe('invalid_resolution');
    expect(moneyProblem({ ...redelivery, codeValue: true })).toBe('invalid_resolution');
    expect(moneyProblem({ ...redelivery, deliveredNormally: false })).toBe('not_delivered');
    expect(moneyProblem({ ...redelivery, hasOrder: false })).toBe('order_required');
    expect(moneyProblem({ ...redelivery, party: 'restaurant' })).toBe('invalid_resolution');
    expect(moneyProblem({ ...redelivery, typeCode: 'amount_or_change', affectedLines: 0 })).toBe(
      'invalid_resolution',
    );
    // The pay is charged to a responsible restaurant or captain only.
    expect(moneyProblem({ ...redelivery, responsible: 'platform', chargePay: true })).toBe(
      'invalid_resolution',
    );
    expect(moneyProblem({ ...missing, chargePay: true })).toBe('invalid_resolution');
  });
});
