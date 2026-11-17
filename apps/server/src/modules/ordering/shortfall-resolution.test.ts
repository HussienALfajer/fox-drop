import 'reflect-metadata';
import { TicketSync } from '../support/index.js';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { DATABASE } from '../../database/database.module.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { CaptainsService } from '../captains/index.js';
import { AlertsService } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { OrderAlerts } from './order-alerts.js';
import { SHORTFALL_REASON } from './shortfall.js';
import {
  app,
  azaz,
  delta,
  home,
  item,
  orderAtDoor,
  owned,
  platform,
  platformNow,
  restaurant,
  sql,
  TRY,
} from './delivery.fixture.js';

// AP §8.6, docs/domain/06 «Payment at the door» (slice 2.20b): operations
// resolve «نقص في التحصيل» by choosing who bears the missing amount.

// An order delivered 30 TRY short of its 280 TRY total.
async function shortOrder() {
  const door = await orderAtDoor();
  const delivered = await door.deliver({
    received: TRY('25000'),
    shortfall: { reason: 'customer_short', note: null },
  });
  expect(delivered.statusCode).toBe(200);
  const [row] = (
    await sql.query('SELECT customer_account_id, placed_at FROM ordering.orders WHERE id = $1', [
      door.order.id,
    ])
  ).rows;
  const resolve = (responsible: string, key: string = randomUUID()) =>
    door.ops.post(
      `/v1/admin/orders/${door.order.id}/resolve-shortfall`,
      { responsible, reason: 'اتفقنا مع الكابتن' },
      key,
    );
  const preview = (responsible: string) =>
    app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${door.order.id}/shortfall-preview`,
      cookies: door.ops.cookies,
      payload: { responsible },
    });
  return {
    ...door,
    customerAccountId: row.customer_account_id as string,
    placedAt: row.placed_at as Date,
    resolve,
    preview,
  };
}

const openShortfall = async (
  orderId: string,
  ops: { get: (url: string) => Promise<{ json: () => { shortfalls: { orderId: string }[] } }> },
) =>
  (await ops.get(`/v1/admin/orders/shortfalls?cityId=${azaz}`))
    .json()
    .shortfalls.some((each: { orderId: string }) => each.orderId === orderId);

function orderAlerts(): OrderAlerts {
  return new OrderAlerts(
    app.get(DATABASE),
    app.get(Jobs),
    app.get(AlertsService),
    app.get(CaptainsService),
    app.get(SettingsService),
    app.get(TicketSync),
  );
}

const shortfallAlert = async (orderId: string) =>
  (
    await sql.query(
      "SELECT resolved_at FROM notifications.alerts WHERE subject_id = $1 AND code = 'collection_shortfall'",
      [orderId],
    )
  ).rows;

describe('«حلّ النقص» (AP §8.6)', () => {
  it('charges the captain the missing amount, closes the alert and leaves the list', async () => {
    const order = await shortOrder();
    const job = { orderId: order.order.id, placedAt: order.placedAt.toISOString() };
    await orderAlerts().sync(job, new Date());
    expect(await shortfallAlert(order.order.id)).toEqual([{ resolved_at: null }]);

    const preview = await order.preview('captain');
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toEqual({
      shortfall: { amount: '3000', currency: 'TRY' },
      dues: null,
      captainCharge: { amount: '3000', currency: 'TRY' },
      entries: [
        {
          type: 'earn.charge',
          reason: SHORTFALL_REASON,
          account: 'captain.earnings',
          party: { kind: 'captain', id: order.captain.captainId, name: 'كابتن الوصول' },
          amount: { amount: '3000', currency: 'TRY' },
        },
        {
          type: 'earn.charge',
          reason: SHORTFALL_REASON,
          account: 'platform.order_clearing',
          party: { kind: 'platform', id: null, name: null },
          amount: { amount: '-3000', currency: 'TRY' },
        },
      ],
    });

    const earningsBefore = await owned(order.captain.captainId, 'captain.earnings');
    const before = await platformNow();
    const key = randomUUID();
    const answer = await order.resolve('captain', key);
    expect(answer.statusCode).toBe(200);
    // The clearing account back to zero for the order; the captain bears it.
    expect(delta(before, await platformNow())['platform.order_clearing']).toBe(-3_000n);
    expect((await owned(order.captain.captainId, 'captain.earnings')) - earningsBefore).toBe(
      -3_000n,
    );

    const detail = (await order.ops.get(`/v1/admin/orders/${order.order.id}`)).json().order;
    expect(detail.delivery.shortfall).toMatchObject({
      amount: { amount: '3000', currency: 'TRY' },
      resolution: {
        responsible: 'captain',
        note: 'اتفقنا مع الكابتن',
        by: order.ops.accountId,
      },
    });
    expect(await openShortfall(order.order.id, order.ops)).toBe(false);
    const events = (
      await sql.query(
        "SELECT reason FROM ordering.order_events WHERE order_id = $1 AND type = 'order.shortfall_resolved'",
        [order.order.id],
      )
    ).rows;
    expect(events).toEqual([{ reason: 'اتفقنا مع الكابتن' }]);
    await orderAlerts().sync(job, new Date());
    expect((await shortfallAlert(order.order.id))[0].resolved_at).not.toBeNull();

    // A repeat of the key answers the first; another resolution is refused.
    expect((await order.resolve('captain', key)).statusCode).toBe(200);
    const again = await order.resolve('platform');
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('order_state_changed');
    expect((await order.preview('platform')).statusCode).toBe(409);
    expect(
      (
        await sql.query(
          'SELECT count(*)::int AS n FROM ordering.shortfall_resolutions WHERE order_id = $1',
          [order.order.id],
        )
      ).rows[0].n,
    ).toBe(1);
  });

  it("puts the missing amount only on the customer's dues, blocking ordering until paid", async () => {
    const order = await shortOrder();
    const preview = (await order.preview('customer')).json();
    expect(preview.dues).toEqual({ amount: '3000', currency: 'TRY' });
    expect(preview.captainCharge).toBeNull();
    expect((await order.resolve('customer')).statusCode).toBe(200);
    expect(await owned(order.customerAccountId, 'customer.dues')).toBe(3_000n);
    // AP §8.8: the dues block, with no strike or trust change.
    const quote = await app.inject({
      method: 'POST',
      url: '/v1/customer/quote',
      headers: order.order.customer,
      payload: {
        restaurantId: restaurant,
        location: home,
        lines: [{ itemId: item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }],
        payIn: null,
        appVersion: '1.0.0',
      },
    });
    expect(quote.json().problems).toContainEqual(expect.objectContaining({ code: 'dues_unpaid' }));
    expect(
      (
        await sql.query(
          'SELECT count(*)::int AS n FROM customers.late_cancel_strikes WHERE customer_account_id = $1',
          [order.customerAccountId],
        )
      ).rows[0].n,
    ).toBe(0);
  });

  it('posts once when two resolutions race, whatever their parties', async () => {
    const order = await shortOrder();
    const before = await platformNow();
    const answers = await Promise.all([order.resolve('captain'), order.resolve('platform')]);
    expect(answers.map((answer) => answer.statusCode).sort()).toEqual([200, 409]);
    expect(answers.find((answer) => answer.statusCode === 409)!.json().error).toBe(
      'order_state_changed',
    );
    expect(delta(before, await platformNow())['platform.order_clearing']).toBe(-3_000n);
    expect(
      (
        await sql.query(
          'SELECT count(*)::int AS n FROM ordering.shortfall_resolutions WHERE order_id = $1',
          [order.order.id],
        )
      ).rows[0].n,
    ).toBe(1);
  });

  it('answers an unknown order with 404 on both routes', async () => {
    const order = await shortOrder();
    const unknown = randomUUID();
    const resolve = await order.ops.post(`/v1/admin/orders/${unknown}/resolve-shortfall`, {
      responsible: 'platform',
      reason: 'ملاحظة',
    });
    expect(resolve.statusCode).toBe(404);
    const preview = await app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${unknown}/shortfall-preview`,
      cookies: order.ops.cookies,
      payload: { responsible: 'platform' },
    });
    expect(preview.statusCode).toBe(404);
  });

  it("books the missing amount as the platform's operating cost", async () => {
    const order = await shortOrder();
    const cost = await platform('platform.operating_cost');
    expect((await order.resolve('platform')).statusCode).toBe(200);
    expect((await platform('platform.operating_cost')) - cost).toBe(3_000n);
  });

  it('refuses an order without a shortfall, the restaurant and a missing note', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const answer = await door.ops.post(`/v1/admin/orders/${door.order.id}/resolve-shortfall`, {
      responsible: 'platform',
      reason: 'لا نقص',
    });
    expect(answer.statusCode).toBe(409);
    expect(answer.json().error).toBe('order_state_changed');
    const order = await shortOrder();
    expect((await order.resolve('restaurant')).statusCode).toBe(400);
    expect(
      (
        await order.ops.post(`/v1/admin/orders/${order.order.id}/resolve-shortfall`, {
          responsible: 'platform',
          reason: ' ',
        })
      ).statusCode,
    ).toBe(400);
  });

  it('keeps the resolution from the application role’s updates', async () => {
    const order = await shortOrder();
    expect((await order.resolve('platform')).statusCode).toBe(200);
    // The fixture's pool connects as the application role.
    await expect(
      sql.query("UPDATE ordering.shortfall_resolutions SET note = 'x' WHERE order_id = $1", [
        order.order.id,
      ]),
    ).rejects.toThrow(/permission denied/);
  });
});
