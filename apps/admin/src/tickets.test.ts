import { describe, expect, it, vi } from 'vitest';
import {
  affectedOf,
  canResolve,
  chargesPay,
  generalChoices,
  redeliveryParties,
  shortAmountOf,
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
    expect(resolutionChoices('general')).toEqual([
      'compensation_code',
      'free_redelivery',
      'none_explained',
    ]);
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

// AP §8.10, §9.9.3 (slice 2.23c): the money of a general ticket's resolution.
describe('the money of a problem after delivery', () => {
  const lines = [
    { position: 0, name: 'شاورما', quantity: 2, unitPrice: '12000', lineTotal: '24000' },
    { position: 1, name: 'بطاطا', quantity: 1, unitPrice: '3000', lineTotal: '3000' },
  ];

  it('offers «كود تعويض» on a ticket with an order to who may compensate', () => {
    const order = {
      kind: 'general' as const,
      typeCode: 'missing_item',
      order: { lines, deliveredNormally: false } as never,
    };
    expect(generalChoices(order, true)).toEqual(['compensation_code', 'none_explained']);
    expect(generalChoices(order, false)).toEqual(['none_explained']);
    expect(generalChoices({ ...order, order: null }, true)).toEqual(['none_explained']);
  });

  // AP §9.9.3 (slice 2.23d).
  it('offers «إعادة توصيل مجانية» for the items of a normal delivery only', () => {
    const delivered = {
      kind: 'general' as const,
      typeCode: 'missing_item',
      order: { lines, deliveredNormally: true } as never,
    };
    expect(generalChoices(delivered, false)).toEqual(['free_redelivery', 'none_explained']);
    expect(generalChoices({ ...delivered, typeCode: 'amount_or_change' }, false)).toEqual([
      'none_explained',
    ]);
    expect(chargesPay('restaurant')).toBe(true);
    expect(chargesPay('captain')).toBe(true);
    expect(chargesPay('platform')).toBe(false);
    expect(redeliveryParties).not.toContain('customer');
  });

  it('reads the affected quantities within each line', () => {
    expect(affectedOf(lines, { 0: '1', 1: '' })).toEqual([{ position: 0, quantity: 1 }]);
    expect(affectedOf(lines, { 0: '0' })).toEqual([]);
    expect(affectedOf(lines, { 1: '2' })).toBeNull();
    expect(affectedOf(lines, { 0: '1.5' })).toBeNull();
  });

  it('reads M in minor units, above zero', () => {
    expect(shortAmountOf('20', 'TRY')).toBe('2000');
    expect(shortAmountOf('0', 'TRY')).toBeNull();
    expect(shortAmountOf('x', 'TRY')).toBeNull();
  });
});
