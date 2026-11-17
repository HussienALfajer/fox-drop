import { describe, expect, it, vi } from 'vitest';
import { minutesLeft, slaState, statusChoices, ticketLabel } from './tickets.js';

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
