import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { vehicles } from '../settings/index.js';
import { admin, app, azaz, onlineCaptain, sql } from './delivery.fixture.js';

// AP §9.12.5 «أجور الكباتن» (slice 2.37b): the panel's pay table screen,
// publishing a new version 7 days or more ahead with the captains' push
// (CA §14 #22), and the preview calculator, through the routes.
const day = 86_400_000;
const rate = {
  basePay: '3000',
  includedMetres: 3000,
  perExtraKm: '600',
  waitingPerMinute: '100',
  minimumPay: '3000',
};
const rates = vehicles.map((vehicle) => ({ vehicle, ...rate }));

describe('«أجور الكباتن» (AP §9.12.5)', () => {
  it('publishes a table 7 days ahead, announced to the captains once, and previews it', async () => {
    const { captainId } = await onlineCaptain();
    const owner = await admin(['OWN']);
    const before = await owner.get(`/v1/admin/pay-tables?cityId=${azaz}`);
    expect(before.statusCode).toBe(200);
    const screen = before.json();
    expect(screen).toMatchObject({
      baseCurrency: 'TRY',
      waitingThresholdMin: 10,
      noticeDays: 7,
      maxDistanceKm: [
        { vehicle: 'walking', km: 1.5 },
        { vehicle: 'bicycle', km: 4 },
        { vehicle: 'motorbike', km: 10 },
        { vehicle: 'car', km: 15 },
      ],
      versions: [
        {
          state: 'in_force',
          currency: 'TRY',
          editorName: null,
          rates: expect.arrayContaining([
            expect.objectContaining({ vehicle: 'motorbike', basePay: '2500', perExtraKm: '500' }),
          ]),
        },
      ],
    });
    const earliest = new Date(screen.earliestStart).getTime();
    expect(Math.abs(earliest - (Date.now() + 7 * day))).toBeLessThan(60_000);

    const publish = (effectiveFrom: Date, body: object = {}) =>
      app.inject({
        method: 'PUT',
        url: '/v1/admin/pay-tables',
        cookies: owner.cookies,
        payload: {
          cityId: azaz,
          currency: 'TRY',
          effectiveFrom: effectiveFrom.toISOString(),
          rates,
          reason: 'رفع الأجر الأساسي',
          ...body,
        },
      });
    const early = await publish(new Date(Date.now() + day));
    expect(early.statusCode).toBe(400);
    expect(early.json().error).toBe('invalid_pay_table');
    expect((await publish(new Date(earliest + day), { reason: ' ' })).statusCode).toBe(400);

    const start = new Date(earliest + day);
    const published = await publish(start);
    expect(published.statusCode).toBe(200);
    expect(published.json().versions).toHaveLength(2);
    expect(published.json().versions[0]).toMatchObject({
      state: 'announced',
      effectiveFrom: start.toISOString(),
      editorName: expect.stringMatching(/^Operator /),
      reason: 'رفع الأجر الأساسي',
      rates: expect.arrayContaining([expect.objectContaining({ vehicle: 'car', basePay: '3000' })]),
    });
    // A repeat answers the same version and pushes nothing more.
    expect((await publish(start)).json().versions).toHaveLength(2);
    const { rows } = await sql.query(
      `SELECT body, level, data FROM notifications.push_messages
        WHERE captain_id = $1 AND template_key = 'captain.pay_table_change'`,
      [captainId],
    );
    expect(rows).toEqual([
      {
        body: expect.stringMatching(/^جدول أجور جديد يبدأ في .+ \d{2}\/\d{2}\/\d{4} الساعة \d/),
        level: 'silent',
        data: { target: 'pay_table' },
      },
    ]);

    // 5 km, 15 minutes waited (10 free): by the table in force (no waiting
    // pay), the one announced and the rate typed.
    const preview = await owner.get(
      `/v1/admin/pay-tables/preview?cityId=${azaz}&vehicle=motorbike&metres=5000&waitedMinutes=15` +
        '&draftBasePay=2000&draftIncludedMetres=2000&draftPerExtraKm=1000&draftWaitingPerMinute=50&draftMinimumPay=6000',
    );
    expect(preview.statusCode).toBe(200);
    const try_ = (amount: string) => ({ amount, currency: 'TRY' });
    expect(preview.json()).toEqual({
      waitingThresholdMin: 10,
      inForce: {
        effectiveFrom: expect.any(String),
        base: try_('2500'),
        distance: try_('1000'),
        topUp: try_('0'),
        orderPay: try_('3500'),
        waiting: try_('0'),
        total: try_('3500'),
      },
      announced: [
        {
          effectiveFrom: start.toISOString(),
          base: try_('3000'),
          distance: try_('1200'),
          topUp: try_('0'),
          orderPay: try_('4200'),
          waiting: try_('500'),
          total: try_('4700'),
        },
      ],
      draft: {
        base: try_('2000'),
        distance: try_('3000'),
        topUp: try_('1000'),
        orderPay: try_('6000'),
        waiting: try_('250'),
        total: try_('6250'),
      },
    });
    const partial = await owner.get(
      `/v1/admin/pay-tables/preview?cityId=${azaz}&vehicle=car&metres=1000&draftBasePay=2000`,
    );
    expect(partial.statusCode).toBe(400);
    expect(partial.json().error).toBe('invalid_pay_table');
  });

  it('lets operations read and preview, never publish', async () => {
    const ops = await admin(['OPS']);
    expect((await ops.get(`/v1/admin/pay-tables?cityId=${azaz}`)).statusCode).toBe(200);
    const refused = await app.inject({
      method: 'PUT',
      url: '/v1/admin/pay-tables',
      cookies: ops.cookies,
      payload: {
        cityId: azaz,
        currency: 'TRY',
        effectiveFrom: new Date(Date.now() + 8 * day).toISOString(),
        rates,
        reason: 'x',
      },
    });
    expect(refused.statusCode).toBe(403);
    const unknown = await ops.get(
      '/v1/admin/pay-tables?cityId=0190f3a0-0000-7000-8000-000000000000',
    );
    expect(unknown.statusCode).toBe(404);
  });
});
