// RA §4.3–4.6 (slice 2.42): the pure rules of a restaurant's receiving
// devices.
import { versionBelow } from '../settings/index.js';

// RA §4.5: the device check's items, as the app reports the failed ones.
// `sleep` is Windows' power plan (a warning, never failing the check).
export const deviceCheckCodes = [
  'notifications',
  'battery',
  'autostart',
  'full_screen',
  'alarm_volume',
  'sleep',
  'test_ring',
  'connection',
] as const;
export type DeviceCheckCode = (typeof deviceCheckCodes)[number];

export interface DeviceCheck {
  at: Date;
  // No failed item.
  passed: boolean;
  failed: DeviceCheckCode[];
  // Check 8: the server connection's delay, when it could be measured.
  delayMs: number | null;
}

// RA §4.3: the server marks a device disconnected after 60 seconds without a
// heartbeat (fixed). The heartbeat is Centrifugo's ping every 20 seconds;
// the worker records the devices it sees on the channel.
export const DISCONNECTED_AFTER_MS = 60_000;

export function connectedAt(presentAt: Date | null, now: Date): boolean {
  return presentAt !== null && now.getTime() - presentAt.getTime() <= DISCONNECTED_AFTER_MS;
}

// RA §4.6: a device receives when it is signed in (`role`: its user's, or
// null), connected, rings (a cashier's always, RA §4.4) and runs a version
// at or above the minimum (RA §4.2).
export function isReceiving(
  device: {
    role: 'owner' | 'cashier' | null;
    ringing: boolean;
    presentAt: Date | null;
    appVersion: string;
  },
  minVersion: string | null,
  now: Date,
): boolean {
  return (
    device.role !== null &&
    connectedAt(device.presentAt, now) &&
    (device.role === 'cashier' || device.ringing) &&
    (minVersion === null || !versionBelow(device.appVersion, minVersion))
  );
}

// RA §4.6: while open or busy, the moment the restaurant has had no
// receiving device since, and whether that lasted merchant.no_device_alert_min.
// A receiving device, or the restaurant no longer open, clears it.
export function withoutDeviceStep(input: {
  open: boolean;
  receiving: number;
  since: Date | null;
  alertMinutes: number;
  now: Date;
}): { since: Date | null; alert: boolean } {
  if (!input.open || input.receiving > 0) return { since: null, alert: false };
  const since = input.since ?? input.now;
  return {
    since,
    alert: input.now.getTime() - since.getTime() >= input.alertMinutes * 60_000,
  };
}
