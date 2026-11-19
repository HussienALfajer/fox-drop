import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { admin, app, azaz, home, restaurant } from './delivery.fixture.js';

// AP §9.12.3 «رسوم التوصيل» (slice 2.37a): the panel's fee screen, a
// restaurant's own rule and the preview calculator, through the routes.
const put = (cookies: Record<string, string>, url: string, payload: object) =>
  app.inject({ method: 'PUT', url, cookies, payload });

const bands = {
  kind: 'distance_bands',
  currency: 'TRY',
  bands: [
    { upToMetres: 2000, fee: '3000' },
    { upToMetres: null, fee: '5000' },
  ],
  minimumFee: null,
  freeDeliveryFrom: '50000',
};

describe('«رسوم التوصيل» (AP §9.12.3)', () => {
  it("lets the owner change the city's rule and preview it, each version listed", async () => {
    const owner = await admin(['OWN']);
    const before = await owner.get(`/v1/admin/delivery-fees?cityId=${azaz}`);
    expect(before.statusCode).toBe(200);
    expect(before.json()).toMatchObject({
      baseCurrency: 'TRY',
      distanceMethod: 'road',
      versions: [{ rule: { kind: 'flat', flatFee: '4000' }, editorName: null }],
      restaurants: [{ id: restaurant, ownRule: null }],
    });

    const saved = await put(owner.cookies, '/v1/admin/delivery-fees', {
      cityId: azaz,
      rule: bands,
      reason: 'شرائح الإطلاق',
    });
    expect(saved.statusCode).toBe(200);
    expect(saved.json().versions).toHaveLength(2);
    expect(saved.json().versions[0]).toMatchObject({
      rule: { kind: 'distance_bands', bands: bands.bands, freeDeliveryFrom: '50000' },
      editorName: expect.stringMatching(/^Operator /),
      reason: 'شرائح الإطلاق',
    });

    // About 330 m from the restaurant by the straight line × 1.3 (no OSRM
    // in the tests): the first band.
    const preview = await owner.get(
      `/v1/admin/delivery-fees/preview?cityId=${azaz}&restaurantId=${restaurant}&latitude=${home.latitude}&longitude=${home.longitude}`,
    );
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({
      fee: '3000',
      currency: 'TRY',
      free: false,
      scope: 'city',
      freeDeliveryFrom: '50000',
      distance: { method: 'straight_x1.3' },
      covers: true,
      zoneName: 'المركز',
    });
    const free = await owner.get(
      `/v1/admin/delivery-fees/preview?cityId=${azaz}&restaurantId=${restaurant}&latitude=${home.latitude}&longitude=${home.longitude}&itemsValue=50000`,
    );
    expect(free.json()).toMatchObject({ fee: '0', free: true });

    // Back to the flat rule the orders of the other tests price with.
    await put(owner.cookies, '/v1/admin/delivery-fees', {
      cityId: azaz,
      rule: {
        kind: 'flat',
        currency: 'TRY',
        flatFee: '4000',
        minimumFee: null,
        freeDeliveryFrom: null,
      },
      reason: null,
    });
  });

  it("sets a restaurant's own rule, which the preview names, and returns it to the city's", async () => {
    const owner = await admin(['OWN']);
    const url = `/v1/admin/delivery-fees/restaurants/${restaurant}`;
    const own = await put(owner.cookies, url, {
      cityId: azaz,
      rule: {
        kind: 'flat',
        currency: 'TRY',
        flatFee: '2500',
        minimumFee: null,
        freeDeliveryFrom: null,
      },
      reason: 'عرض المطعم',
    });
    expect(own.statusCode).toBe(200);
    expect(own.json().restaurants).toEqual([
      expect.objectContaining({
        id: restaurant,
        ownRule: expect.objectContaining({
          rule: expect.objectContaining({ kind: 'flat', flatFee: '2500' }),
          reason: 'عرض المطعم',
        }),
      }),
    ]);
    const preview = await owner.get(
      `/v1/admin/delivery-fees/preview?cityId=${azaz}&restaurantId=${restaurant}&latitude=${home.latitude}&longitude=${home.longitude}`,
    );
    expect(preview.json()).toMatchObject({
      fee: '2500',
      scope: 'restaurant',
      distance: { metres: expect.any(Number) },
    });

    const back = await put(owner.cookies, url, { cityId: azaz, rule: null, reason: null });
    expect(back.json().restaurants[0].ownRule).toBeNull();
    const city = await owner.get(
      `/v1/admin/delivery-fees/preview?cityId=${azaz}&restaurantId=${restaurant}&latitude=${home.latitude}&longitude=${home.longitude}`,
    );
    expect(city.json()).toMatchObject({ fee: '4000', scope: 'city' });
  });

  it('refuses a malformed rule, another currency, an unknown restaurant or city', async () => {
    const owner = await admin(['OWN']);
    const malformed = await put(owner.cookies, '/v1/admin/delivery-fees', {
      cityId: azaz,
      rule: { ...bands, bands: [{ upToMetres: 2000, fee: '3000' }] },
      reason: null,
    });
    expect(malformed.statusCode).toBe(400);
    expect(malformed.json()).toMatchObject({ error: 'invalid_fee_rule' });
    const usd = await put(owner.cookies, '/v1/admin/delivery-fees', {
      cityId: azaz,
      rule: { ...bands, currency: 'EUR' },
      reason: null,
    });
    expect(usd.statusCode).toBe(409);
    expect(usd.json()).toMatchObject({ error: 'fee_not_in_base_currency' });
    const unknown = '0190f3a0-0000-7000-8000-000000000999';
    const noRestaurant = await put(
      owner.cookies,
      `/v1/admin/delivery-fees/restaurants/${unknown}`,
      {
        cityId: azaz,
        rule: null,
        reason: null,
      },
    );
    expect(noRestaurant.statusCode).toBe(404);
    expect(noRestaurant.json()).toMatchObject({ error: 'unknown_restaurant' });
    expect((await owner.get(`/v1/admin/delivery-fees?cityId=${unknown}`)).json()).toMatchObject({
      error: 'unknown_city',
    });
  });

  it('lets OPS and FIN read and preview, and only the owner change', async () => {
    for (const role of ['OPS', 'FIN']) {
      const reader = await admin([role]);
      expect((await reader.get(`/v1/admin/delivery-fees?cityId=${azaz}`)).statusCode).toBe(200);
      const refused = await put(reader.cookies, '/v1/admin/delivery-fees', {
        cityId: azaz,
        rule: bands,
        reason: null,
      });
      expect(refused.statusCode).toBe(403);
    }
    const support = await admin(['SUP']);
    expect((await support.get(`/v1/admin/delivery-fees?cityId=${azaz}`)).statusCode).toBe(403);
  });
});
