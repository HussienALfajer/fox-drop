import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { bannerFieldsOf, bannerImageRefusal, bannerState, cropBox, emptyForm } =
  await import('./banners.js');

describe('cropBox', () => {
  it('cuts the widest 12:5 frame, centred, at zoom 1', () => {
    // A 4000×3000 photo: the frame takes its whole width.
    expect(cropBox({ width: 4000, height: 3000 }, { zoom: 1, x: 0.5, y: 0.5 })).toEqual({
      sx: 0,
      sy: (3000 - 4000 / 2.4) / 2,
      sw: 4000,
      sh: 4000 / 2.4,
    });
    // A very wide image: the frame takes its whole height; across 0 is the
    // image's start, its right edge (right to left).
    expect(cropBox({ width: 3000, height: 500 }, { zoom: 1, x: 0, y: 0 })).toEqual({
      sx: 1800,
      sy: 0,
      sw: 1200,
      sh: 500,
    });
  });

  it('zooms in and moves the frame within the image, never past it', () => {
    const box = cropBox({ width: 2400, height: 1000 }, { zoom: 2, x: 1, y: 1 });
    expect(box).toEqual({ sx: 0, sy: 500, sw: 1200, sh: 500 });
    // Out of range values stay inside.
    expect(cropBox({ width: 2400, height: 1000 }, { zoom: 9, x: 2, y: -1 })).toEqual({
      sx: 0,
      sy: 0,
      sw: 800,
      sh: 800 / 2.4,
    });
  });
});

describe('bannerImageRefusal', () => {
  const jpeg = { type: 'image/jpeg', size: 1000 };
  it('refuses another type, an unreadable file and an image smaller than the frame', () => {
    expect(bannerImageRefusal({ type: 'image/gif', size: 10 }, null)).toBe('type');
    expect(bannerImageRefusal(jpeg, null)).toBe('not_image');
    expect(bannerImageRefusal(jpeg, { width: 1199, height: 2000 })).toBe('too_small');
    expect(bannerImageRefusal(jpeg, { width: 1200, height: 500 })).toBeNull();
  });
});

describe('bannerFieldsOf', () => {
  const now = Date.parse('2026-11-18T10:00:00Z');
  const zone = 'Asia/Damascus';
  const form = {
    ...emptyForm(),
    title: '  عروض الشتاء ',
    target: 'restaurant' as const,
    restaurantIds: ['r1'],
    startsAt: '2026-11-18T12:00',
    endsAt: '2026-11-25T12:00',
  };

  it('builds the body with the period on the city clock and the target alone', () => {
    expect(bannerFieldsOf({ ...form, categoryId: 'c1' }, zone, now)).toEqual({
      fields: {
        title: 'عروض الشتاء',
        target: 'restaurant',
        restaurantIds: ['r1'],
        categoryId: null,
        codeId: null,
        zoneIds: [],
        startsAt: '2026-11-18T09:00:00.000Z',
        endsAt: '2026-11-25T09:00:00.000Z',
      },
    });
    expect(
      bannerFieldsOf({ ...form, target: 'code', restaurantIds: [], codeId: 'k1' }, zone, now),
    ).toMatchObject({ fields: { target: 'code', codeId: 'k1', restaurantIds: [] } });
  });

  it('names the first problem', () => {
    expect(bannerFieldsOf({ ...form, title: ' ' }, zone, now)).toEqual({ problem: 'title' });
    expect(bannerFieldsOf({ ...form, restaurantIds: ['r1', 'r2'] }, zone, now)).toEqual({
      problem: 'target',
    });
    expect(bannerFieldsOf({ ...form, target: 'category' }, zone, now)).toEqual({
      problem: 'target',
    });
    expect(bannerFieldsOf({ ...form, endsAt: form.startsAt }, zone, now)).toEqual({
      problem: 'period',
    });
    expect(
      bannerFieldsOf(
        { ...form, startsAt: '2026-11-01T12:00', endsAt: '2026-11-02T12:00' },
        zone,
        now,
      ),
    ).toEqual({ problem: 'ended' });
  });
});

describe('bannerState', () => {
  const banner = { startsAt: '2026-11-18T09:00:00Z', endsAt: '2026-11-25T09:00:00Z' };
  it('says whether it runs, has not started or has ended', () => {
    const at = (iso: string) => bannerState(banner as never, Date.parse(iso));
    expect(at('2026-11-18T08:00:00Z')).toBe('scheduled');
    expect(at('2026-11-20T08:00:00Z')).toBe('running');
    expect(at('2026-11-25T09:00:00Z')).toBe('ended');
  });
});
