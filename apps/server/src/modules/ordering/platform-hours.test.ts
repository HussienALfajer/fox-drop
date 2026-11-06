import { describe, expect, it } from 'vitest';
import { platformOpening } from './platform-hours.js';

// CU §4.7, AP D9: platform.hours, the weekdays' open intervals on the city
// clock; close 24:00 is the end of the day. 2026-11-06 is a Friday.
const timeZone = 'Asia/Damascus';
const at = (local: string) => new Date(`${local}+03:00`);
const days = ['saturday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday'];
const every = (intervals: { open: string; close: string }[]) =>
  Object.fromEntries(days.map((day) => [day, intervals]));

describe('platformOpening', () => {
  it('is open all day by default', () => {
    const allDay = every([{ open: '00:00', close: '24:00' }]);
    expect(platformOpening(allDay, at('2026-11-06T03:00:00'), timeZone)).toEqual({ open: true });
  });

  it('says when it opens next while closed', () => {
    const evenings = every([{ open: '10:00', close: '24:00' }]);
    expect(platformOpening(evenings, at('2026-11-06T09:00:00'), timeZone)).toEqual({
      open: false,
      opensAt: at('2026-11-06T10:00:00'),
    });
    expect(platformOpening(evenings, at('2026-11-06T23:59:00'), timeZone)).toEqual({ open: true });
  });

  it('reads each weekday on its own, a day without intervals closed', () => {
    const fridayOff = { ...every([{ open: '08:00', close: '20:00' }]), friday: [] };
    expect(platformOpening(fridayOff, at('2026-11-06T12:00:00'), timeZone)).toEqual({
      open: false,
      opensAt: at('2026-11-07T08:00:00'),
    });
  });
});
