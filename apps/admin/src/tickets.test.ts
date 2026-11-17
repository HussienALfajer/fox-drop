import { describe, expect, it, vi } from 'vitest';
import {
  canResolve,
  minutesLeft,
  needsResponsible,
  receivedLinesOf,
  resolutionChoices,
  slaState,
  statusChoices,
  ticketLabel,
  typedLinesOf,
} from './tickets.js';
import type { AdminSession } from './session.js';

vi.mock('./api.js', () => ({ api: {} }));

const at = (time: string) => Date.parse(`2026-12-10T${time}Z`);
const timer = {
  kind: 'first_response' as const,
  startedAt: '2026-12-10T12:00:00Z',
  dueAt: '2026-12-10T12:15:00Z',
  stoppedAt: null,
};

// AP §9.9.2 (slice 2.23a): the SLA timer as the server's rule says it.
describe('the SLA timer', () => {
  it('turns amber at 80% and red once breached', () => {
    expect(slaState(timer, at('12:11:59'))).toBe('running');
    expect(slaState(timer, at('12:12:00'))).toBe('amber');
    expect(slaState(timer, at('12:15:00'))).toBe('breached');
  });

  it('is met when stopped in time, and stays breached when stopped late', () => {
    expect(slaState({ ...timer, stoppedAt: '2026-12-10T12:05:00Z' }, at('13:00:00'))).toBe('met');
    expect(slaState({ ...timer, stoppedAt: '2026-12-10T12:20:00Z' }, at('13:00:00'))).toBe(
      'breached',
    );
  });

  it('counts the whole minutes left', () => {
    expect(minutesLeft(timer, at('12:10:30'))).toBe(5);
    expect(minutesLeft(timer, at('12:20:00'))).toBe(-5);
  });
});

describe('the status by hand', () => {
  it('offers «بانتظار رد» and back, never «محلولة»', () => {
    expect(statusChoices('new')).toEqual(['waiting']);
    expect(statusChoices('in_progress')).toEqual(['waiting']);
    expect(statusChoices('waiting')).toEqual(['in_progress']);
    expect(statusChoices('resolved')).toEqual([]);
    expect(statusChoices('closed')).toEqual([]);
  });
});

it('shows the number as T-5521 (AP §4.8)', () => {
  expect(ticketLabel('5521')).toBe('T-5521');
});

// AP §9.9.3 (slice 2.23b): what the resolution form offers and sends.
describe('the resolution form', () => {
  const session = (permissions: string[]) => ({ permissions }) as unknown as AdminSession;

  it("offers each kind its resolutions and asks a general ticket's party only", () => {
    expect(resolutionChoices('general')).toEqual(['none_explained']);
    expect(resolutionChoices('price_difference')).toEqual(['price_corrected', 'price_correct']);
    expect(resolutionChoices('pickup_dispute')).toEqual([
      'captain_paid',
      'accounts_corrected',
      'payment_correct',
    ]);
    expect(needsResponsible('general')).toBe(true);
    expect(needsResponsible('price_difference')).toBe(false);
    expect(needsResponsible('pickup_dispute')).toBe(true);
  });

  it('lets support.manage resolve a ticket and support.resolve_pickup_dispute a dispute', () => {
    const sup = session(['support.read', 'support.manage']);
    const fin = session(['support.read', 'support.resolve_pickup_dispute']);
    const open = { status: 'in_progress' as const };
    expect(canResolve(sup, { ...open, kind: 'general' })).toBe(true);
    expect(canResolve(sup, { ...open, kind: 'pickup_dispute' })).toBe(false);
    expect(canResolve(fin, { ...open, kind: 'pickup_dispute' })).toBe(true);
    expect(canResolve(fin, { ...open, kind: 'general' })).toBe(false);
    expect(canResolve(sup, { status: 'resolved', kind: 'general' })).toBe(false);
  });

  it('types the lines received in major units, starting from what the restaurant said', () => {
    const typed = typedLinesOf({
      pickupPayment: { amount: '40100', currency: 'TRY' },
      recorded: [],
      received: [{ amount: '19500', currency: 'TRY' }],
      confirmedBy: 'automatic',
      captainName: null,
      disputedAt: '2026-12-10T12:00:00Z',
      currencies: ['TRY', 'USD'],
    });
    expect(typed).toEqual({ TRY: '195.00', USD: '' });
    expect(receivedLinesOf(typed)).toEqual([{ currency: 'TRY', amount: '19500' }]);
    expect(receivedLinesOf({ TRY: '195', USD: '5.5' })).toEqual([
      { currency: 'TRY', amount: '19500' },
      { currency: 'USD', amount: '550' },
    ]);
    expect(receivedLinesOf({ TRY: '0', USD: '' })).toEqual([]);
    expect(receivedLinesOf({ TRY: 'abc' })).toBeNull();
  });
});
