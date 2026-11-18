import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { MerchantsService } from '../merchants/index.js';
import {
  admin,
  allWeek,
  app,
  appSignIn,
  azaz,
  cashier,
  centre,
  change,
  home,
  phoneNumber,
  sql,
} from './order-edits.fixture.js';

// AP §9.8 «حساب تجريبي للإدارة», AP §9.6.3, CU §8.2 (slice 2.25b; owner
// decision 2026-11-17: the order is a test order because its restaurant is
// in test mode).

async function testRestaurant() {
  const merchants = app.get(MerchantsService);
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم تجريبي',
      address: 'شارع التجربة',
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'test', change);
  await merchants.setWeeklySchedule(id, allWeek, change);
  const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
  const item = await merchants.addItem(
    id,
    { categoryId: category, name: 'فلافل', price: { amount: 12_000n, currency: 'TRY' } },
    change,
  );
  return { id, item };
}

async function customer() {
  const headers = await appSignIn('customer', phoneNumber());
  const id = JSON.parse(Buffer.from(headers.authorization.split('.')[1]!, 'base64url').toString())
    .sub as string;
  return { id, headers };
}

const at = `latitude=${home.latitude}&longitude=${home.longitude}`;

const listed = async (headers: Record<string, string>) =>
  (await app.inject({ method: 'GET', url: `/v1/customer/restaurants?${at}`, headers })).json()
    .restaurants as { id: string; testMode: boolean }[];

async function flag(roles: string[], customerId: string, flagged: boolean) {
  const { cookies } = await admin(roles);
  return app.inject({
    method: 'POST',
    url: `/v1/admin/customers/${customerId}/test-account`,
    cookies,
    payload: { cityId: azaz, flagged },
  });
}

function order(headers: Record<string, string>, restaurantId: string, item: string) {
  const lines = [{ itemId: item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }];
  const body = { restaurantId, location: home, lines, payIn: null, appVersion: '1.0.0' };
  return {
    quote: () => app.inject({ method: 'POST', url: '/v1/customer/quote', headers, payload: body }),
    place: (version: string) =>
      app.inject({
        method: 'POST',
        url: '/v1/customer/orders',
        headers: { ...headers, 'idempotency-key': randomUUID() },
        payload: {
          restaurantId,
          lines,
          payIn: null,
          appVersion: '1.0.0',
          quoteVersion: version,
          addressId: null,
          unsavedAddress: {
            location: home,
            street: 'شارع السوق',
            floor: null,
            landmark: 'قرب الجامع',
            contactPhone: null,
            recipientName: null,
            directions: null,
          },
          note: null,
        },
      }),
  };
}

describe('«حساب تجريبي للإدارة» (AP §9.8, §9.6.3)', () => {
  it('shows the restaurants in test mode to a flagged account only, which orders a test order', async () => {
    const restaurant = await testRestaurant();
    const tester = await customer();
    const other = await customer();
    const guest = await app.inject({ method: 'GET', url: `/v1/customer/restaurants?${at}` });
    expect(guest.statusCode).toBe(200);
    expect(guest.json().restaurants.map((card: { id: string }) => card.id)).not.toContain(
      restaurant.id,
    );
    expect((await listed(tester.headers)).map((card) => card.id)).not.toContain(restaurant.id);
    expect((await order(tester.headers, restaurant.id, restaurant.item).quote()).statusCode).toBe(
      404,
    );

    expect((await flag(['OPS'], tester.id, true)).statusCode).toBe(403);
    const flagged = await flag(['OWN'], tester.id, true);
    expect(flagged.statusCode).toBe(200);
    expect(flagged.json().testAccount).toBe(true);

    expect(await listed(tester.headers)).toContainEqual(
      expect.objectContaining({ id: restaurant.id, testMode: true }),
    );
    expect((await listed(other.headers)).map((card) => card.id)).not.toContain(restaurant.id);
    const page = await app.inject({
      method: 'GET',
      url: `/v1/customer/restaurants/${restaurant.id}?${at}`,
      headers: tester.headers,
    });
    expect(page.statusCode).toBe(200);
    expect(page.json().testMode).toBe(true);
    expect(
      (
        await app.inject({
          method: 'GET',
          url: `/v1/customer/restaurants/${restaurant.id}?${at}`,
          headers: other.headers,
        })
      ).statusCode,
    ).toBe(404);

    const cart = order(tester.headers, restaurant.id, restaurant.item);
    const quote = await cart.quote();
    expect(quote.statusCode).toBe(200);
    const placed = await cart.place(quote.json().version);
    expect(placed.statusCode).toBe(201);
    const { rows } = await sql.query('SELECT test_order FROM ordering.orders WHERE id = $1', [
      placed.json().order.id,
    ]);
    expect(rows[0].test_order).toBe(true);
    // RA §8.16 (slice 2.30b): the cashier's card shows «طلب تجريبي».
    const board = await app.inject({
      method: 'GET',
      url: '/v1/merchant/orders',
      headers: await cashier(restaurant.id),
    });
    expect(board.json().orders).toEqual([
      expect.objectContaining({ id: placed.json().order.id, testOrder: true, owner: null }),
    ]);

    expect((await flag(['OWN'], tester.id, false)).json().testAccount).toBe(false);
    expect((await listed(tester.headers)).map((card) => card.id)).not.toContain(restaurant.id);
  });
});
