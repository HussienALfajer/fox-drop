import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { MerchantsService } from '../merchants/index.js';
import { acceptedOrder, admin, app, azaz, centre, change, restaurant } from './delivery.fixture.js';

// AP §9.6.2 «المطاعم» (slice 2.30c): the list's columns, filters and search,
// read through the panel's route (reporting) over the orders and ratings
// this module counts.
const list = async (filter: Record<string, string | null> = {}) => {
  const ops = await admin(['OPS']);
  const answer = await ops.post('/v1/admin/restaurant-list', {
    cityId: azaz,
    status: null,
    categoryId: null,
    zoneId: null,
    q: null,
    ...filter,
  });
  expect(answer.statusCode).toBe(200);
  return answer.json();
};

describe('POST /v1/admin/restaurant-list (AP §9.6.2)', () => {
  it('shows today’s orders, the acceptance rate, the commission and the state', async () => {
    const before = Date.now();
    await acceptedOrder();
    const answer = await list();
    expect(answer.currency).toBe('TRY');
    const row = answer.restaurants.find((each: { id: string }) => each.id === restaurant);
    expect(row).toMatchObject({
      accountStatus: 'active',
      state: 'open',
      visible: true,
      zoneName: 'المركز',
      acceptanceBp7d: 10_000,
      commissionBp: 1500,
      balance: '0',
      ratingAverage: null,
      ratingCount: 0,
    });
    expect(row.ordersToday).toBeGreaterThanOrEqual(1);
    expect(new Date(row.lastOrderAt).getTime()).toBeGreaterThanOrEqual(before - 1000);
  });

  it('filters by status and searches by a part of the name or the number', async () => {
    const merchants = app.get(MerchantsService);
    const other = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مطبخ الحارة',
        nameEn: 'Hara Kitchen',
        phone: '+963944000111',
        location: centre,
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1000,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(other, 'active', change);
    await merchants.setAccountStatus(other, 'suspended', { ...change, reason: 'x' });
    const ids = (answer: { restaurants: { id: string }[] }) =>
      answer.restaurants.map((each) => each.id);
    expect(ids(await list({ status: 'suspended' }))).toEqual([other]);
    expect(ids(await list({ status: 'active' }))).not.toContain(other);
    // «مطبخ الحاره» finds «مطبخ الحارة»; the English name too.
    expect(ids(await list({ q: 'الحاره' }))).toEqual([other]);
    expect(ids(await list({ q: 'hara' }))).toEqual([other]);
    expect(ids(await list({ q: '0944 000 111' }))).toEqual([other]);
    const suspended = (await list({ q: 'الحارة' })).restaurants[0];
    expect(suspended).toMatchObject({
      state: null,
      acceptanceBp7d: null,
      ordersToday: 0,
      lastOrderAt: null,
      commissionBp: 1000,
    });
  });

  it('answers 404 for an unknown city', async () => {
    const ops = await admin(['OPS']);
    const answer = await ops.post('/v1/admin/restaurant-list', {
      cityId: '0190f3a0-0000-7000-8000-000000000999',
      status: null,
      categoryId: null,
      zoneId: null,
      q: null,
    });
    expect(answer.statusCode).toBe(404);
  });
});
