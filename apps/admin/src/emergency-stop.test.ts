import { describe, expect, it, vi } from 'vitest';
import { elapsedMinutes, fillReason, followsOps, zonedToUtc } from './emergency-stop.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.1.6 «الإيقاف الطارئ»: the bar's duration, the delay notice's preview
// and the automatic resume typed on the city's clock.
describe('elapsedMinutes', () => {
  it('counts whole minutes by the server clock, never below zero', () => {
    const start = '2026-11-09T10:00:00.000Z';
    expect(elapsedMinutes(start, Date.parse('2026-11-09T10:12:59.000Z'))).toBe(12);
    expect(elapsedMinutes(start, Date.parse('2026-11-09T09:59:00.000Z'))).toBe(0);
  });
});

describe('fillReason', () => {
  it('fills every {السبب} with the customer-facing reason', () => {
    expect(fillReason('بسبب {السبب}، {السبب}', 'المطر')).toBe('بسبب المطر، المطر');
  });
});

describe('zonedToUtc', () => {
  it("reads a wall time on the city's clock", () => {
    expect(zonedToUtc('2026-11-09T18:30', 'Asia/Damascus')).toBe('2026-11-09T15:30:00.000Z');
    expect(zonedToUtc('2026-07-01T00:00', 'Europe/Berlin')).toBe('2026-06-30T22:00:00.000Z');
    expect(zonedToUtc('2026-01-01T00:00', 'Europe/Berlin')).toBe('2025-12-31T23:00:00.000Z');
  });

  it('refuses what is not a wall time', () => {
    expect(zonedToUtc('', 'Asia/Damascus')).toBeNull();
    expect(zonedToUtc('18:30', 'Asia/Damascus')).toBeNull();
  });
});

describe('followsOps', () => {
  const session = (roles: string[], permissions: string[]) => ({ roles, permissions }) as never;
  it('follows the ops channel when the server lets the session in', () => {
    expect(followsOps(session(['SUP'], ['operations.read']))).toBe(true);
    expect(followsOps(session(['FIN'], []))).toBe(true);
    expect(followsOps(session(['DATA'], []))).toBe(false);
  });
});
