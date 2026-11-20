import { describe, expect, it } from 'vitest';
import { connectedAt, isReceiving, withoutDeviceStep } from './receiving.js';

const now = new Date('2026-11-20T12:00:00Z');
const secondsAgo = (seconds: number) => new Date(now.getTime() - seconds * 1000);

describe('connectedAt (RA §4.3)', () => {
  // Centrifugo drops a silent client 28 s after its last heartbeat at most.
  it('counts a device seen within 32 s, 60 s after its last heartbeat, as connected', () => {
    expect(connectedAt(secondsAgo(31), now)).toBe(true);
    expect(connectedAt(secondsAgo(32), now)).toBe(true);
    expect(connectedAt(secondsAgo(33), now)).toBe(false);
    expect(connectedAt(null, now)).toBe(false);
  });
});

describe('isReceiving (RA §4.6)', () => {
  const owner = {
    role: 'owner' as const,
    ringing: true,
    presentAt: secondsAgo(10),
    appVersion: '1.2.0',
  };

  it('needs the device signed in, connected, ringing and at the minimum version', () => {
    expect(isReceiving(owner, '1.2.0', now)).toBe(true);
    expect(isReceiving(owner, null, now)).toBe(true);
    expect(isReceiving({ ...owner, role: null }, null, now)).toBe(false);
    expect(isReceiving({ ...owner, presentAt: secondsAgo(40) }, null, now)).toBe(false);
    expect(isReceiving({ ...owner, ringing: false }, null, now)).toBe(false);
    expect(isReceiving(owner, '1.10.0', now)).toBe(false);
  });

  it('lets a cashier device ring whatever its setting (fixed)', () => {
    expect(isReceiving({ ...owner, role: 'cashier', ringing: false }, null, now)).toBe(true);
  });
});

describe('withoutDeviceStep (RA §4.6)', () => {
  const step = (open: boolean, receiving: number, since: Date | null) =>
    withoutDeviceStep({ open, receiving, since, alertMinutes: 5, now });

  it('starts counting when an open restaurant has no receiving device', () => {
    expect(step(true, 0, null)).toEqual({ since: now, alert: false });
  });

  it('alerts once the restaurant has had none for the setting’s minutes', () => {
    expect(step(true, 0, secondsAgo(299))).toEqual({ since: secondsAgo(299), alert: false });
    expect(step(true, 0, secondsAgo(300))).toEqual({ since: secondsAgo(300), alert: true });
  });

  it('clears when a device receives or the restaurant stops being open', () => {
    expect(step(true, 1, secondsAgo(600))).toEqual({ since: null, alert: false });
    expect(step(false, 0, secondsAgo(600))).toEqual({ since: null, alert: false });
  });
});
