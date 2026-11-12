import { describe, expect, it, vi } from 'vitest';
import { officeFormOf, officeRequestOf } from './office.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.12.1, CA C13 «المكتب»: the form and the body it saves.
const office = {
  location: { latitude: 36.5862, longitude: 37.0471 },
  hours: [
    { weekday: 6, opensAt: 540, closesAt: 1380 },
    { weekday: 4, opensAt: 1200, closesAt: 1440 },
  ],
  open: false,
  closesAt: null,
  opensAt: null,
};

describe('officeFormOf', () => {
  it('is empty with every day closed before the first save', () => {
    const form = officeFormOf(null);
    expect(form.latitude).toBe('');
    expect(Object.values(form.days).every((day) => !day.open)).toBe(true);
  });

  it('fills each weekday from the office in force, 24:00 as 00:00', () => {
    const form = officeFormOf(office);
    expect(form.latitude).toBe('36.5862');
    expect(form.days[6]).toEqual({ open: true, from: '09:00', to: '23:00' });
    expect(form.days[4]).toEqual({ open: true, from: '20:00', to: '00:00' });
    expect(form.days[5].open).toBe(false);
  });
});

describe('officeRequestOf', () => {
  it('sends the point and the open days, 00:00 as the end of the day', () => {
    expect(officeRequestOf(officeFormOf(office))).toEqual({
      body: {
        location: { latitude: 36.5862, longitude: 37.0471 },
        hours: [
          { weekday: 6, opensAt: 540, closesAt: 1380 },
          { weekday: 4, opensAt: 1200, closesAt: 1440 },
        ],
      },
    });
  });

  it('names a point off the map and the first day without its hours', () => {
    const form = officeFormOf(office);
    expect(officeRequestOf({ ...form, latitude: '91' })).toEqual({ problem: 'location' });
    expect(officeRequestOf({ ...form, longitude: 'abc' })).toEqual({ problem: 'location' });
    expect(
      officeRequestOf({
        ...form,
        days: { ...form.days, 1: { open: true, from: '09:00', to: '' } },
      }),
    ).toEqual({ problem: 'hours', day: 1 });
  });
});
