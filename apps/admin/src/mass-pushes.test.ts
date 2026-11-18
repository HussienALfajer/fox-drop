import { describe, expect, it, vi } from 'vitest';

vi.mock('./api.js', () => ({ api: {} }));

const { emptyForm, massPushFieldsOf } = await import('./mass-pushes.js');

const now = Date.parse('2026-11-18T10:00:00Z');
const form = (over: object = {}) => ({
  ...emptyForm(),
  title: ' عرض الشتاء ',
  body: 'توصيل مجاني اليوم',
  ...over,
});

describe('massPushFieldsOf', () => {
  it('sends now to everyone, the text trimmed, opening the home', () => {
    expect(massPushFieldsOf(form(), 'Asia/Damascus', now)).toEqual({
      fields: {
        title: 'عرض الشتاء',
        body: 'توصيل مجاني اليوم',
        audience: 'all',
        zoneId: null,
        inactiveDays: null,
        target: 'home',
        restaurantId: null,
        codeId: null,
        sendAt: null,
      },
    });
  });

  it('takes the audience and the target the server takes', () => {
    const zone = massPushFieldsOf(
      form({ audience: 'zone', zoneId: 'z1', target: 'code', codeId: 'c1' }),
      'Asia/Damascus',
      now,
    );
    expect(zone).toMatchObject({ fields: { audience: 'zone', zoneId: 'z1', codeId: 'c1' } });
    const inactive = massPushFieldsOf(
      form({ audience: 'inactive', inactiveDays: '45', target: 'restaurant', restaurantId: 'r1' }),
      'Asia/Damascus',
      now,
    );
    expect(inactive).toMatchObject({
      fields: { audience: 'inactive', inactiveDays: 45, zoneId: null, restaurantId: 'r1' },
    });
  });

  it('schedules on the city clock, ahead and within 30 days', () => {
    // 15:00 in Damascus (UTC+3) is 12:00 UTC.
    expect(
      massPushFieldsOf(form({ scheduled: true, sendAt: '2026-11-18T15:00' }), 'Asia/Damascus', now),
    ).toMatchObject({ fields: { sendAt: '2026-11-18T12:00:00.000Z' } });
    const late = (sendAt: string) =>
      massPushFieldsOf(form({ scheduled: true, sendAt }), 'Asia/Damascus', now);
    expect(late('2026-11-18T12:00')).toEqual({ problem: 'time' });
    expect(late('2026-12-19T12:00')).toEqual({ problem: 'time' });
    expect(late('')).toEqual({ problem: 'time' });
  });

  it('names the first problem', () => {
    const problem = (over: object) => massPushFieldsOf(form(over), 'Asia/Damascus', now);
    expect(problem({ title: '  ' })).toEqual({ problem: 'title' });
    expect(problem({ title: 'ع'.repeat(51) })).toEqual({ problem: 'title' });
    expect(problem({ body: 'ن'.repeat(201) })).toEqual({ problem: 'body' });
    expect(problem({ audience: 'zone' })).toEqual({ problem: 'zone' });
    expect(problem({ audience: 'inactive', inactiveDays: '0' })).toEqual({ problem: 'days' });
    expect(problem({ audience: 'inactive', inactiveDays: '2.5' })).toEqual({ problem: 'days' });
    expect(problem({ audience: 'inactive', inactiveDays: '366' })).toEqual({ problem: 'days' });
    expect(problem({ target: 'restaurant' })).toEqual({ problem: 'target' });
    expect(problem({ target: 'code' })).toEqual({ problem: 'target' });
  });
});
