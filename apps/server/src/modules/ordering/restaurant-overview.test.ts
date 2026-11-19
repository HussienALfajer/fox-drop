import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { acceptedOrder, admin, app, restaurant, sql } from './delivery.fixture.js';

// AP §9.6.4 «نظرة عامة» (slice 2.30d): a restaurant's figures over a
// period, through the panel's route.
describe('GET /v1/admin/restaurants/{id}/overview (AP §9.6.4)', () => {
  it('counts the orders, the acceptance and the prep times, late ones apart', async () => {
    const onTime = await acceptedOrder();
    const ready = await app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${onTime.id}/ready`,
      headers: { ...onTime.cashier, 'idempotency-key': crypto.randomUUID() },
    });
    expect(ready.statusCode).toBe(200);
    // Ready 30 minutes after acceptance with a prep time of 20: late.
    const late = await acceptedOrder();
    await sql.query(
      `UPDATE ordering.orders SET status = 'ready', ready_at = accepted_at + interval '30 minutes',
         no_captain_alert_at = accepted_at + interval '40 minutes' WHERE id = $1`,
      [late.id],
    );
    const ops = await admin(['OPS']);
    const today = await ops.get(`/v1/admin/restaurants/${restaurant}/overview?period=today`);
    expect(today.statusCode).toBe(200);
    expect(today.json()).toMatchObject({
      orders: 2,
      sales: [],
      acceptanceBp: 10_000,
      rejectionBp: 0,
      rejectionReasons: [],
      unanswered: 0,
      prepChosenMin: 20,
      lateBp: 5000,
      ratingCount: 0,
      ratingAverage: null,
    });
    expect(today.json().prepActualMin).toBeGreaterThanOrEqual(15);
    expect(today.json().prepActualMin).toBeLessThan(15.2);
    const month = await ops.get(`/v1/admin/restaurants/${restaurant}/overview?period=last_30_days`);
    expect(month.json().orders).toBe(2);
    expect(new Date(month.json().from).getTime()).toBeLessThan(
      new Date(today.json().from).getTime(),
    );
    // «الطلبات»: the latest first.
    const listed = await ops.get(`/v1/admin/restaurants/${restaurant}/orders`);
    expect(listed.statusCode).toBe(200);
    expect(listed.json().orders.map((order: { id: string }) => order.id)).toEqual([
      late.id,
      onTime.id,
    ]);
    expect(listed.json().orders[0]).toMatchObject({
      status: 'ready',
      currency: 'TRY',
      testOrder: false,
      redelivery: false,
    });
  });

  it('answers 404 for an unknown restaurant and refuses a reader without restaurants.read', async () => {
    const ops = await admin(['OPS']);
    const unknown = await ops.get(
      '/v1/admin/restaurants/0190f3a0-0000-7000-8000-000000000999/overview',
    );
    expect(unknown.statusCode).toBe(404);
    const data = await admin(['DATA']);
    expect((await data.get(`/v1/admin/restaurants/${restaurant}/overview`)).statusCode).toBe(403);
  });
});
