import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import {
  admin,
  app,
  appSignIn,
  azaz,
  home,
  orderAtDoor,
  phoneNumber,
  pickedUpOrder,
  restaurant,
  sql,
} from './delivery.fixture.js';
import { ratingProblem, ratingUntil, reasonListFor } from './ratings.js';

// CU §12.1, U15, Q16, AP §9.8 (slice 2.26a): the customer's ratings of a
// delivered order, the restaurant and the captain apart.

const DAY = 86_400_000;
const part = (stars: number, reasons: string[] = []) => ({ stars, reasons, comment: null });

describe('the rule of a rating', () => {
  const deliveredAt = new Date('2026-11-10T10:00:00Z');
  const until = ratingUntil({ status: 'delivered', deliveredAt, redelivery: false }, 3)!;

  it('opens for customer.rating_window_days after the delivery, delivered orders only', () => {
    expect(until.getTime()).toBe(deliveredAt.getTime() + 3 * DAY);
    expect(ratingUntil({ status: 'failed', deliveredAt: null, redelivery: false }, 3)).toBeNull();
    expect(
      ratingUntil({ status: 'cancelled', deliveredAt: null, redelivery: false }, 3),
    ).toBeNull();
    // A free re-delivery is never rated (AP §9.9.3).
    expect(ratingUntil({ status: 'delivered', deliveredAt, redelivery: true }, 3)).toBeNull();
  });

  it('refuses outside the window, a part sent before, and the captain without one', () => {
    const base = { until, captainId: randomUUID(), rated: [] as const };
    const now = new Date(deliveredAt.getTime() + DAY);
    expect(ratingProblem({ ...base, now, parts: { restaurant: part(5) } })).toBeNull();
    expect(ratingProblem({ ...base, now, parts: {} })).toBe('invalid_rating');
    expect(
      ratingProblem({ ...base, now: new Date(until.getTime()), parts: { restaurant: part(4) } }),
    ).toBe('rating_closed');
    expect(ratingProblem({ ...base, until: null, now, parts: { restaurant: part(4) } })).toBe(
      'not_ratable',
    );
    expect(ratingProblem({ ...base, captainId: null, now, parts: { captain: part(4) } })).toBe(
      'not_ratable',
    );
    expect(
      ratingProblem({ ...base, rated: ['restaurant'], now, parts: { restaurant: part(2) } }),
    ).toBe('already_rated');
    // The other part can still be sent (CU §12.1: one part, then the other).
    expect(
      ratingProblem({ ...base, rated: ['restaurant'], now, parts: { captain: part(2) } }),
    ).toBe(null);
    expect(ratingProblem({ ...base, now, parts: { restaurant: part(6) } })).toBe('invalid_rating');
    expect(ratingProblem({ ...base, now, parts: { restaurant: part(5, ['kind', 'kind']) } })).toBe(
      'invalid_rating',
    );
  });

  it("takes the reasons from Content's list for the stars", () => {
    expect(reasonListFor('restaurant', 1)).toBe('restaurant_rating_low');
    expect(reasonListFor('restaurant', 2)).toBe('restaurant_rating_low');
    expect(reasonListFor('restaurant', 3)).toBe('restaurant_rating_mid');
    expect(reasonListFor('captain', 4)).toBe('captain_rating_high');
    expect(reasonListFor('captain', 5)).toBe('captain_rating_high');
  });
});

async function deliveredOrder() {
  const door = await orderAtDoor();
  expect((await door.deliver()).statusCode).toBe(200);
  return { id: door.order.id as string, customer: door.order.customer };
}

// A part without a comment sends null, as the app does.
const withComment = (value: object | null | undefined) =>
  value ? { comment: null, ...value } : null;

const rate = (
  orderId: string,
  customer: { authorization: string },
  body: { restaurant?: object; captain?: object },
) =>
  app.inject({
    method: 'POST',
    url: `/v1/customer/orders/${orderId}/rating`,
    headers: customer,
    payload: { restaurant: withComment(body.restaurant), captain: withComment(body.captain) },
  });

const customerOrder = async (orderId: string, customer: { authorization: string }) =>
  (
    await app.inject({ method: 'GET', url: `/v1/customer/orders/${orderId}`, headers: customer })
  ).json().order;

describe('«قيّم المطعم» and «قيّم الكابتن»', () => {
  it('sends each part once, with the reasons as chosen, and never edits it', async () => {
    const order = await deliveredOrder();
    const before = await customerOrder(order.id, order.customer);
    expect(before.rating).toMatchObject({ captainRatable: true, restaurant: null, captain: null });
    const until = new Date(before.rating.until).getTime();
    expect(until).toBeGreaterThan(Date.now() + 3 * DAY - 60_000);
    expect(until).toBeLessThanOrEqual(Date.now() + 3 * DAY);

    const sent = await rate(order.id, order.customer, {
      restaurant: { stars: 2, reasons: ['cold_food', 'bad_packaging'], comment: '  بارد جداً ' },
    });
    expect(sent.statusCode).toBe(200);
    const { rating } = sent.json().order;
    expect(rating.restaurant).toMatchObject({
      stars: 2,
      reasons: [
        { code: 'cold_food', label: 'الطعام بارد' },
        { code: 'bad_packaging', label: 'التغليف سيئ' },
      ],
      comment: 'بارد جداً',
    });
    expect(rating.captain).toBeNull();
    // The captain's part is still left.
    expect(rating.until).not.toBeNull();

    const again = await rate(order.id, order.customer, { restaurant: { stars: 5, reasons: [] } });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('already_rated');

    // A reason of another band, or another party's, is refused.
    const wrong = await rate(order.id, order.customer, {
      captain: { stars: 5, reasons: ['cold_food'], comment: null },
    });
    expect(wrong.statusCode).toBe(400);
    expect(wrong.json().error).toBe('unknown_reason');

    const captain = await rate(order.id, order.customer, {
      captain: { stars: 5, reasons: ['kind', 'fast'], comment: null },
    });
    expect(captain.statusCode).toBe(200);
    const after = captain.json().order.rating;
    expect(after.captain).toMatchObject({ stars: 5, comment: null });
    expect(after.restaurant.stars).toBe(2);
    expect(after.until).toBeNull();

    // Never edited: the application role cannot update a rating.
    await expect(
      sql.query('UPDATE ordering.ratings SET stars = 5 WHERE order_id = $1', [order.id]),
    ).rejects.toThrow(/permission denied/);
  });

  it("refuses another customer's order, an order not delivered, and one past the window", async () => {
    const order = await deliveredOrder();
    const stranger = await appSignIn('customer', phoneNumber());
    const theirs = await rate(order.id, stranger, { restaurant: { stars: 4, reasons: [] } });
    expect(theirs.statusCode).toBe(404);

    const picked = await pickedUpOrder();
    const early = await rate(picked.order.id, picked.order.customer, {
      restaurant: { stars: 4, reasons: [] },
    });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('not_ratable');
    expect((await customerOrder(picked.order.id, picked.order.customer)).rating.until).toBeNull();

    await sql.query(
      "UPDATE ordering.orders SET delivered_at = delivered_at - interval '3 days' WHERE id = $1",
      [order.id],
    );
    const late = await rate(order.id, order.customer, { restaurant: { stars: 4, reasons: [] } });
    expect(late.statusCode).toBe(409);
    expect(late.json().error).toBe('rating_closed');
    expect((await customerOrder(order.id, order.customer)).rating.until).toBeNull();

    const empty = await rate(order.id, order.customer, {});
    expect(empty.statusCode).toBe(400);
    const long = await rate(order.id, order.customer, {
      restaurant: { stars: 4, reasons: [], comment: 'أ'.repeat(301) },
    });
    expect(long.statusCode).toBe(400);
  });

  it('shows the restaurant «جديد» below 5 ratings, then its average and count', async () => {
    const page = async () =>
      (
        await app.inject({
          method: 'GET',
          url: `/v1/customer/restaurants/${restaurant}?latitude=${home.latitude}&longitude=${home.longitude}`,
        })
      ).json();
    // Earlier tests may have rated the same restaurant: count from the table.
    const counted = async () =>
      (
        await sql.query(
          "SELECT count(*)::int AS n, avg(stars)::float8 AS average FROM ordering.ratings WHERE restaurant_id = $1 AND party = 'restaurant'",
          [restaurant],
        )
      ).rows[0] as { n: number; average: number };
    const { n: before } = await counted();
    expect(before).toBeLessThan(4);
    for (const each of [5, 4, 4, 5, 3]) {
      const order = await deliveredOrder();
      expect(
        (await rate(order.id, order.customer, { restaurant: { stars: each, reasons: [] } }))
          .statusCode,
      ).toBe(200);
      const { n, average } = await counted();
      const shown = await page();
      if (n < 5) {
        expect(shown).toMatchObject({ rating: null, ratingCount: null });
      } else {
        expect(shown).toMatchObject({ rating: Math.round(average * 10) / 10, ratingCount: n });
      }
    }
    const shown = await page();
    expect(shown.ratingCount).toBeGreaterThanOrEqual(5);
    // A test order's rating never counts (AP §9.6.3).
    const test = await deliveredOrder();
    await sql.query('UPDATE ordering.orders SET test_order = true WHERE id = $1', [test.id]);
    expect(
      (await rate(test.id, test.customer, { restaurant: { stars: 1, reasons: [] } })).statusCode,
    ).toBe(200);
    expect(await page()).toMatchObject({ rating: shown.rating, ratingCount: shown.ratingCount });
    const list = (
      await app.inject({
        method: 'GET',
        url: `/v1/customer/restaurants?latitude=${home.latitude}&longitude=${home.longitude}`,
      })
    ).json().restaurants;
    expect(list.find((card: { id: string }) => card.id === restaurant)).toMatchObject({
      rating: shown.rating,
      ratingCount: shown.ratingCount,
    });
  });

  it("lists the customer's ratings on the panel's profile with the names", async () => {
    const order = await deliveredOrder();
    await rate(order.id, order.customer, {
      restaurant: { stars: 3, reasons: ['could_be_better'], comment: 'عادي' },
      captain: { stars: 1, reasons: ['late'], comment: 'تأخر كثيراً' },
    });
    const [{ customer_account_id: customerId }] = (
      await sql.query('SELECT customer_account_id FROM ordering.orders WHERE id = $1', [order.id])
    ).rows;
    const sup = await admin(['SUP']);
    const profile = (await sup.get(`/v1/admin/customers/${customerId}?cityId=${azaz}`)).json();
    expect(profile.ratings).toHaveLength(2);
    const byParty = Object.fromEntries(
      profile.ratings.map((each: { party: string }) => [each.party, each]),
    );
    expect(byParty.restaurant).toMatchObject({
      orderId: order.id,
      stars: 3,
      comment: 'عادي',
      captainName: null,
      reasons: [{ code: 'could_be_better', label: 'جيد لكن يمكن أفضل' }],
    });
    expect(byParty.restaurant.restaurantName).toEqual(expect.any(String));
    expect(byParty.captain).toMatchObject({ stars: 1, comment: 'تأخر كثيراً' });
    expect(byParty.captain.captainName).toEqual(expect.any(String));
  });
});
