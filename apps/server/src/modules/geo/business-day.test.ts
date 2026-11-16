import { describe, expect, it } from 'vitest';
import { cutoffOn, lastCutoff, nextCutoff } from './business-day.js';

// RA §4.9, §9.3: «حتى الغد» ends at the next business-day cutoff on the city's
// clock (finance.business_day_cutoff, 06:00 by default); AP §8.5.4: the cash
// due from closed days is counted at the last one.
const at = (local: string, offset = '+03:00') => new Date(`${local}${offset}`);

describe('nextCutoff', () => {
  it('is the same morning before the cutoff', () => {
    expect(nextCutoff(at('2026-11-07T02:30:00'), 360, 'Asia/Damascus')).toEqual(
      at('2026-11-07T06:00:00'),
    );
  });

  it('is the next morning from the cutoff on', () => {
    expect(nextCutoff(at('2026-11-07T06:00:00'), 360, 'Asia/Damascus')).toEqual(
      at('2026-11-08T06:00:00'),
    );
    expect(nextCutoff(at('2026-11-07T23:59:00'), 360, 'Asia/Damascus')).toEqual(
      at('2026-11-08T06:00:00'),
    );
  });

  it('follows the city clock, not the server clock', () => {
    // 22:30 UTC on the 6th is 01:30 on the 7th in Damascus.
    expect(nextCutoff(new Date('2026-11-06T22:30:00Z'), 360, 'Asia/Damascus')).toEqual(
      at('2026-11-07T06:00:00'),
    );
  });

  it('keeps the wall-clock cutoff across a daylight saving change', () => {
    // Berlin moves from UTC+2 to UTC+1 on 2026-10-25 at 03:00.
    expect(nextCutoff(at('2026-10-24T12:00:00', '+02:00'), 360, 'Europe/Berlin')).toEqual(
      at('2026-10-25T06:00:00', '+01:00'),
    );
  });

  it('takes a midnight cutoff', () => {
    expect(nextCutoff(at('2026-11-07T15:00:00'), 0, 'Asia/Damascus')).toEqual(
      at('2026-11-08T00:00:00'),
    );
  });
});

describe('lastCutoff', () => {
  it('is the same morning from the cutoff on', () => {
    expect(lastCutoff(at('2026-11-07T06:00:00'), 360, 'Asia/Damascus')).toEqual(
      at('2026-11-07T06:00:00'),
    );
    expect(lastCutoff(at('2026-11-07T23:59:00'), 360, 'Asia/Damascus')).toEqual(
      at('2026-11-07T06:00:00'),
    );
  });

  it('is the previous morning before the cutoff', () => {
    expect(lastCutoff(at('2026-11-07T05:59:00'), 360, 'Asia/Damascus')).toEqual(
      at('2026-11-06T06:00:00'),
    );
  });

  it('keeps the wall-clock cutoff across a daylight saving change', () => {
    expect(lastCutoff(at('2026-10-25T12:00:00', '+01:00'), 360, 'Europe/Berlin')).toEqual(
      at('2026-10-25T06:00:00', '+01:00'),
    );
    expect(lastCutoff(at('2026-10-25T05:00:00', '+01:00'), 360, 'Europe/Berlin')).toEqual(
      at('2026-10-24T06:00:00', '+02:00'),
    );
  });
});

// AP §9.10.5 (slice 2.19g): a period of business days starts at the cutoff
// of its first day and ends at the cutoff of the day after its last.
describe('cutoffOn', () => {
  it('is the cutoff of that day on the city clock', () => {
    expect(cutoffOn('2026-11-07', 360, 'Asia/Damascus')).toEqual(at('2026-11-07T06:00:00'));
    expect(cutoffOn('2026-12-31', 0, 'Asia/Damascus')).toEqual(at('2026-12-31T00:00:00'));
  });

  it('takes the offset in force on that day', () => {
    // Berlin is UTC+2 in summer and UTC+1 in winter.
    expect(cutoffOn('2026-07-01', 360, 'Europe/Berlin')).toEqual(
      at('2026-07-01T06:00:00', '+02:00'),
    );
    expect(cutoffOn('2026-01-01', 360, 'Europe/Berlin')).toEqual(
      at('2026-01-01T06:00:00', '+01:00'),
    );
  });
});
