import { describe, expect, it } from 'vitest';
import { type DeviceSighting, deviceLinks } from './devices.js';

const at = (minute: number) => new Date(Date.UTC(2026, 10, 18, 10, minute));

function seen(deviceId: string, accountId: string, minute: number): DeviceSighting {
  return {
    deviceId,
    accountId,
    firstSignedInAt: at(minute),
    lastSignedInAt: at(minute),
    lastSeenAt: at(minute),
    ipAddress: null,
    userAgent: null,
  };
}

describe('deviceLinks (docs/domain/08, the device block)', () => {
  it('links every other account signed in on a device the line used', () => {
    const links = deviceLinks(
      ['a'],
      [
        seen('phone', 'a', 1),
        seen('phone', 'b', 2),
        seen('tablet', 'a', 3),
        seen('tablet', 'c', 4),
      ],
      new Map(),
    );
    expect(links).toEqual(
      new Map([
        ['b', ['phone']],
        ['c', ['tablet']],
      ]),
    );
  });

  it('never links the line to itself, and ignores devices the line never used', () => {
    const links = deviceLinks(
      ['a', 'a-closed'],
      [seen('phone', 'a', 1), seen('phone', 'a-closed', 2), seen('other', 'b', 3)],
      new Map(),
    );
    expect(links).toEqual(new Map());
  });

  it('lists every device two accounts shared', () => {
    const links = deviceLinks(
      ['a'],
      [
        seen('phone', 'a', 1),
        seen('phone', 'b', 2),
        seen('tablet', 'a', 3),
        seen('tablet', 'b', 4),
      ],
      new Map(),
    );
    expect(links).toEqual(new Map([['b', ['phone', 'tablet']]]));
  });

  it('counts only sign-ins after the device was lifted, on both sides (a phone sold on)', () => {
    const lifts = new Map([['phone', at(5)]]);
    // The seller signed in before the lift, the buyer after.
    expect(
      deviceLinks(['buyer'], [seen('phone', 'seller', 1), seen('phone', 'buyer', 6)], lifts),
    ).toEqual(new Map());
    expect(
      deviceLinks(['seller'], [seen('phone', 'seller', 1), seen('phone', 'buyer', 6)], lifts),
    ).toEqual(new Map());
    // The seller signs in on it again after the lift: linked again.
    expect(
      deviceLinks(
        ['buyer'],
        [{ ...seen('phone', 'seller', 1), lastSignedInAt: at(7) }, seen('phone', 'buyer', 6)],
        lifts,
      ),
    ).toEqual(new Map([['seller', ['phone']]]));
  });
});
