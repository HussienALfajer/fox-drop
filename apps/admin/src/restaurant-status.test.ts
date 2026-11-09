import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));
vi.mock('./session.js', () => ({ can: () => false }));

const { maxActiveOrders, pauseBody, stateKey } = await import('./restaurant-status.js');

// AP §9.6.5: the panel's pause, maximum and state labels.
describe('pauseBody', () => {
  const form = { until: '', message: '  ', reason: ' عطل ' };

  it('sends a fixed length, until resumed, or a time on the city’s clock', () => {
    expect(pauseBody({ ...form, length: '30' }, 'Asia/Damascus')).toEqual({
      minutes: 30,
      until: null,
      message: null,
      reason: 'عطل',
    });
    expect(pauseBody({ ...form, length: 'resumed' }, 'Asia/Damascus')).toMatchObject({
      minutes: null,
      until: null,
    });
    expect(
      pauseBody({ ...form, length: 'until', until: '2026-11-10T18:30' }, 'Asia/Damascus'),
    ).toMatchObject({ minutes: null, until: '2026-11-10T15:30:00.000Z' });
  });

  it('refuses a time it cannot read', () => {
    expect(pauseBody({ ...form, length: 'until', until: '' }, 'Asia/Damascus')).toBeNull();
  });
});

describe('maxActiveOrders', () => {
  it('is off when empty, 1 to 50 otherwise', () => {
    expect(maxActiveOrders('')).toBeNull();
    expect(maxActiveOrders('5')).toBe(5);
    for (const value of ['0', '51', '2.5', 'x']) expect(maxActiveOrders(value)).toBeUndefined();
  });
});

describe('stateKey', () => {
  it('names a pause by who set it (RA Appendix B)', () => {
    expect(stateKey({ state: 'paused', pauseSource: 'ops' })).toBe('pausedByOperations');
    expect(stateKey({ state: 'paused', pauseSource: 'auto' })).toBe('autoPaused');
    expect(stateKey({ state: 'paused', pauseSource: 'restaurant' })).toBe('paused');
    expect(stateKey({ state: 'holiday', pauseSource: null })).toBe('holiday');
  });
});
