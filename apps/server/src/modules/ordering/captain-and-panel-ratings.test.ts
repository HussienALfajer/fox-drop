import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { admin, app, azaz, orderAtDoor, restaurant, sql } from './delivery.fixture.js';

// CA §11.2 (C14), CU §12.1, Q16, AP §9.6.4, §9.7.4 (slice 2.26c): the
// captain reads their average and reasons with counts, never a comment;
// the panel reads a restaurant's and a captain's ratings with the comments
// and the order, never the customer's name. Every rating counts, test
// orders left out (owner decisions 2026-11-17 and 2026-11-18).

async function deliveredOrder() {
  const door = await orderAtDoor();
  expect((await door.deliver()).statusCode).toBe(200);
  return {
    id: door.order.id as string,
    customer: door.order.customer,
    captain: door.captain,
  };
}

// The captain's part of a rating written for another delivered order, as if
// that order had been delivered by `captainId` (each order of the fixture
// has its own captain).
async function captainRatedAt(
  orderId: string,
  captainId: string,
  stars: number,
  reasons: { code: string; label: string }[],
  testOrder = false,
) {
  await sql.query(
    `INSERT INTO ordering.ratings
       (order_id, order_placed_at, city_id, customer_id, party, restaurant_id, captain_id, stars, reasons, comment, test_order, at)
     SELECT id, placed_at, city_id, customer_account_id, 'captain', restaurant_id, $2, $3, $4, 'سري', $5, now()
     FROM ordering.orders WHERE id = $1`,
    [orderId, captainId, stars, JSON.stringify(reasons), testOrder],
  );
}

const late = { code: 'late', label: 'تأخر' };

describe('the captain’s rating', () => {
  it('shows the average, the count and the reasons with counts, never a comment', async () => {
    const order = await deliveredOrder();
    const mine = () =>
      app.inject({ method: 'GET', url: '/v1/captain/ratings', headers: order.captain.headers });
    expect((await mine()).json()).toEqual({ count: 0, average: null, reasons: [] });

    const sent = await app.inject({
      method: 'POST',
      url: `/v1/customer/orders/${order.id}/rating`,
      headers: order.customer,
      payload: {
        restaurant: null,
        captain: { stars: 2, reasons: ['late', 'no_call_on_arrival'], comment: 'تعليق سري' },
      },
    });
    expect(sent.statusCode).toBe(200);
    const captainId = order.captain.captainId;
    await captainRatedAt((await deliveredOrder()).id, captainId, 1, [late]);
    await captainRatedAt((await deliveredOrder()).id, captainId, 5, [
      { code: 'kind', label: 'لطيف' },
    ]);
    // A test order's rating never counts.
    await captainRatedAt((await deliveredOrder()).id, captainId, 5, [late], true);

    const read = await mine();
    expect(read.statusCode).toBe(200);
    expect(read.json()).toEqual({
      count: 3,
      average: 2.7,
      reasons: [
        { code: 'late', label: 'تأخر', count: 2 },
        { code: 'kind', label: 'لطيف', count: 1 },
        { code: 'no_call_on_arrival', label: 'لم يتصل عند الوصول', count: 1 },
      ],
    });
    // Never a comment nor the customer (CA §11.2, Q16).
    const text = read.body;
    expect(text).not.toContain('سري');
    expect(text).not.toContain(order.id);

    // Another captain sees none of these.
    const other = await deliveredOrder();
    const theirs = await app.inject({
      method: 'GET',
      url: '/v1/captain/ratings',
      headers: other.captain.headers,
    });
    expect(theirs.json()).toMatchObject({ count: 0 });
  });
});

describe('the panel’s ratings', () => {
  it('shows a restaurant’s and a captain’s ratings with the comment and the order', async () => {
    const ops = await admin(['OPS']);
    const order = await deliveredOrder();
    const sent = await app.inject({
      method: 'POST',
      url: `/v1/customer/orders/${order.id}/rating`,
      headers: order.customer,
      payload: {
        restaurant: { stars: 2, reasons: ['cold_food'], comment: 'الطعام بارد جداً' },
        captain: { stars: 4, reasons: [], comment: 'لطيف لكن تأخر' },
      },
    });
    expect(sent.statusCode).toBe(200);
    const [{ number, customer_account_id: customerId }] = (
      await sql.query(
        'SELECT number::text, customer_account_id FROM ordering.orders WHERE id = $1',
        [order.id],
      )
    ).rows;

    const ofRestaurant = await ops.get(`/v1/admin/ratings/restaurants/${restaurant}`);
    expect(ofRestaurant.statusCode).toBe(200);
    const restaurantBody = ofRestaurant.json();
    expect(restaurantBody.ratings[0]).toEqual({
      orderId: order.id,
      orderNumber: number,
      stars: 2,
      reasons: [{ code: 'cold_food', label: 'الطعام بارد' }],
      comment: 'الطعام بارد جداً',
      at: expect.any(String),
    });
    expect(restaurantBody.count).toBeGreaterThanOrEqual(1);
    // Never the customer (AP §9.6.4).
    expect(ofRestaurant.body).not.toContain(customerId);

    const captainId = order.captain.captainId;
    const ofCaptain = (await ops.get(`/v1/admin/ratings/captains/${captainId}?stars=4`)).json();
    expect(ofCaptain).toMatchObject({
      count: 1,
      average: 4,
      ratings: [{ orderId: order.id, stars: 4, comment: 'لطيف لكن تأخر' }],
      more: false,
    });
    expect((await ops.get(`/v1/admin/ratings/captains/${captainId}?stars=1`)).json()).toMatchObject(
      { count: 1, ratings: [] },
    );

    const captains = (await ops.get(`/v1/admin/ratings/captains?cityId=${azaz}`)).json().captains;
    expect(captains.find((each: { id: string }) => each.id === captainId)).toMatchObject({
      count: 1,
      average: 4,
    });
    // The rated first, the unrated last.
    const averages = captains.map((each: { average: number | null }) => each.average);
    const firstUnrated = averages.indexOf(null);
    if (firstUnrated !== -1) {
      expect(averages.slice(firstUnrated).every((each: unknown) => each === null)).toBe(true);
    }

    expect((await ops.get(`/v1/admin/ratings/restaurants/${randomUUID()}`)).json().error).toBe(
      'unknown_restaurant',
    );
    expect((await ops.get(`/v1/admin/ratings/captains/${randomUUID()}`)).json().error).toBe(
      'unknown_captain',
    );
    expect((await ops.get(`/v1/admin/ratings/captains/${captainId}?period=week`)).statusCode).toBe(
      400,
    );

    // FIN reads neither restaurants nor captains (AP §6.2).
    const fin = await admin(['FIN']);
    expect((await fin.get(`/v1/admin/ratings/restaurants/${restaurant}`)).statusCode).toBe(403);
    expect((await fin.get(`/v1/admin/ratings/captains/${captainId}`)).statusCode).toBe(403);
  });
});
