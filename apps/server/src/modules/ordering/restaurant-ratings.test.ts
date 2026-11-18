import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { MerchantAccountsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  app,
  appSignIn,
  azaz,
  change,
  orderAtDoor,
  phoneNumber,
  restaurant,
  sql,
} from './delivery.fixture.js';
import { RATINGS_PAGE } from './rating-pages.js';

// RA §13, §6.1 row 7, R16, CU §12.1 (slice 2.26b): the restaurant's owners
// read its ratings without the customer or the order; test orders never show
// (owner decision 2026-11-17).

const DAY = 86_400_000;

async function user(restaurantId: string, role: 'owner' | 'cashier') {
  const phone = phoneNumber();
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name: role, phone }, change);
  return appSignIn('merchant', phone);
}

const read = (headers: Record<string, string>, query = '') =>
  app.inject({ method: 'GET', url: `/v1/merchant/ratings${query}`, headers });

async function deliveredOrder() {
  const door = await orderAtDoor();
  expect((await door.deliver()).statusCode).toBe(200);
  return { id: door.order.id as string, customer: door.order.customer };
}

async function rated(stars: number, reasons: string[], comment: string | null) {
  const order = await deliveredOrder();
  const sent = await app.inject({
    method: 'POST',
    url: `/v1/customer/orders/${order.id}/rating`,
    headers: order.customer,
    payload: { restaurant: { stars, reasons, comment }, captain: null },
  });
  expect(sent.statusCode).toBe(200);
  return order;
}

// A rating written as if sent earlier: the application role cannot update
// one, so it is inserted for a delivered order not rated yet.
async function ratedAt(orderId: string, stars: number, at: Date, testOrder = false) {
  await sql.query(
    `INSERT INTO ordering.ratings
       (order_id, order_placed_at, city_id, customer_id, party, restaurant_id, stars, reasons, comment, test_order, at)
     SELECT id, placed_at, city_id, customer_account_id, 'restaurant', restaurant_id, $2, '[]', NULL, $3, $4
     FROM ordering.orders WHERE id = $1`,
    [orderId, stars, testOrder, at],
  );
}

describe('«التقييمات» of the restaurant', () => {
  it('shows its owners the ratings without the customer or the order', async () => {
    const owner = await user(restaurant, 'owner');
    const first = await rated(2, ['cold_food'], 'بارد');
    const second = await rated(5, [], null);
    const old = await deliveredOrder();
    await ratedAt(old.id, 4, new Date(Date.now() - 3 * DAY));
    // A test order's rating never shows, nor counts.
    const test = await deliveredOrder();
    await sql.query('UPDATE ordering.orders SET test_order = true WHERE id = $1', [test.id]);
    await ratedAt(test.id, 1, new Date(), true);

    const all = await read(owner);
    expect(all.statusCode).toBe(200);
    const body = all.json();
    expect(body).toMatchObject({
      count: 3,
      average: 3.7,
      distribution: [
        { stars: 5, count: 1 },
        { stars: 4, count: 1 },
        { stars: 3, count: 0 },
        { stars: 2, count: 1 },
        { stars: 1, count: 0 },
      ],
      more: false,
    });
    expect(body.ratings.map((each: { stars: number }) => each.stars)).toEqual([5, 2, 4]);
    // The business day only: never the time, nor an id that carries it.
    expect(body.ratings[1]).toEqual({
      stars: 2,
      reasons: [{ code: 'cold_food', label: 'الطعام بارد' }],
      comment: 'بارد',
      day: expect.stringMatching(/^\d{4}-\d{2}-\d{2}$/),
    });
    // Nothing that names the customer or the order (RA §13).
    const text = JSON.stringify(body);
    for (const order of [first, second, old]) expect(text).not.toContain(order.id);
    const [{ number, customer_account_id: customerId }] = (
      await sql.query(
        'SELECT number::text, customer_account_id FROM ordering.orders WHERE id = $1',
        [first.id],
      )
    ).rows;
    expect(text).not.toContain(customerId);
    expect(text).not.toContain(number);

    // The stars filter the list; the summary counts every star.
    const low = (await read(owner, '?stars=2')).json();
    expect(low.count).toBe(3);
    expect(low.ratings.map((each: { stars: number }) => each.stars)).toEqual([2]);

    // Today's business day leaves out the one three days back.
    const today = (await read(owner, '?period=today')).json();
    expect(today).toMatchObject({ count: 2, average: 3.5 });
    const week = (await read(owner, '?period=last_7_days')).json();
    expect(week.count).toBe(3);
    const yesterday = (await read(owner, '?period=yesterday')).json();
    expect(yesterday).toMatchObject({ count: 0, average: null, ratings: [], more: false });

    expect((await read(owner, '?stars=6')).statusCode).toBe(400);
    expect((await read(owner, '?period=week')).statusCode).toBe(400);
    expect((await read(owner, '?page=-1')).statusCode).toBe(400);
    expect((await read(owner, '?asOf=nonsense')).statusCode).toBe(400);
  });

  it('pages the ratings, newest first, as of the first page', async () => {
    const owner = await user(restaurant, 'owner');
    const before = (await read(owner)).json().count as number;
    // Older than every rating before, so the two oldest are these.
    const start = Date.now() - 5 * DAY;
    const added = RATINGS_PAGE + 1 - before;
    for (let each = 0; each < added; each += 1) {
      const order = await deliveredOrder();
      // The two oldest share their moment, on either side of the page's end.
      await ratedAt(order.id, each < 2 ? 1 : 3, new Date(start + Math.max(each, 1) * 1000));
    }
    const first = (await read(owner)).json();
    expect(first.count).toBe(RATINGS_PAGE + 1);
    expect(first.ratings).toHaveLength(RATINGS_PAGE);
    expect(first.more).toBe(true);
    // A rating sent after the first page shows in neither page.
    await rated(5, [], 'جديد');
    const asOf = encodeURIComponent(first.asOf);
    const second = (await read(owner, `?page=1&asOf=${asOf}`)).json();
    expect(second).toMatchObject({ count: RATINGS_PAGE + 1, more: false, asOf: first.asOf });
    expect(second.ratings).toHaveLength(1);
    const pages = [...first.ratings, ...second.ratings];
    expect(pages.filter((each: { stars: number }) => each.stars === 1)).toHaveLength(2);
    expect(pages.some((each: { comment: string | null }) => each.comment === 'جديد')).toBe(false);
    const days = pages.map((each: { day: string }) => each.day);
    expect(days).toEqual([...days].sort().reverse());
    // A page read afresh counts it.
    expect((await read(owner)).json().count).toBe(RATINGS_PAGE + 2);
  });

  it('refuses a cashier, and a terminated restaurant’s owners', async () => {
    const cashier = await read(await user(restaurant, 'cashier'));
    expect(cashier.statusCode).toBe(403);
    expect(cashier.json().error).toBe('owner_only');

    const merchants = app.get(MerchantsService);
    const other = await merchants.createRestaurant(
      azaz,
      {
        nameAr: `مطعم آخر ${randomUUID()}`,
        location: { latitude: 36.587, longitude: 37.046 },
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1000,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(other, 'active', change);
    const owner = await user(other, 'owner');
    // Another restaurant's owner sees none of this one's.
    expect((await read(owner)).json()).toMatchObject({ count: 0, ratings: [] });
    await merchants.setAccountStatus(other, 'terminated', change);
    const terminated = await read(owner);
    expect(terminated.statusCode).toBe(403);
    expect(terminated.json().error).toBe('restaurant_terminated');
  });
});
