import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { CODE_SENDER, type DevelopmentCodeSender } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';

// The customer app's details, zone check, votes and saved addresses (CU §5.3,
// §7), served by the API app as in production, on a fresh database.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

// A square around a centre; half = 0.01° is about 2 km across.
function square({ latitude, longitude }: Point, half = 0.01): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

// The centre zone has a restaurant covering 1 km around its pin; the east
// zone has none; far is outside both.
const centre = { latitude: 36.587, longitude: 37.046 };
const east = { latitude: 36.587, longitude: 37.086 };
const far = { latitude: 36.587, longitude: 37.2 };

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.createZone(azaz, { name: 'الشرق', area: square(east), active: true }, change);
  const merchants = app.get(MerchantsService);
  const restaurant = await merchants.createRestaurant(
    azaz,
    {
      nameAr: 'مطعم الاختبار',
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(restaurant, 'active', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

// A new customer, signed in: the headers of its calls.
async function signedIn() {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/customer/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

type Headers = Record<string, string>;
const call = (
  headers: Headers,
  method: 'GET' | 'POST' | 'PUT' | 'DELETE',
  url: string,
  payload?: object,
) => app.inject({ method, url, headers, ...(payload ? { payload } : {}) });

const at = ({ latitude, longitude }: Point) =>
  app.inject({
    method: 'GET',
    url: `/v1/customer/location?latitude=${latitude}&longitude=${longitude}`,
  });

describe('the zone check (CU §7.1)', () => {
  it('tells the three cases apart', async () => {
    expect((await at(centre)).json()).toEqual({
      state: 'served',
      zone: { id: expect.any(String), name: 'المركز' },
    });
    expect((await at(east)).json()).toMatchObject({
      state: 'no_restaurants',
      zone: { name: 'الشرق' },
    });
    expect((await at(far)).json()).toEqual({ state: 'outside_zones', zone: null });
  });

  it('refuses a point that is not one', async () => {
    expect((await at({ latitude: 91, longitude: 37 })).statusCode).toBe(400);
  });
});

describe('the votes (CU §7.2)', () => {
  const vote = (deviceId: string, location: Point) =>
    app.inject({
      method: 'POST',
      url: '/v1/customer/zone-votes',
      payload: { deviceId, location },
    });

  const cityOf = async (deviceId: string) =>
    (
      await sql.query('SELECT city_id FROM geo.zone_votes WHERE device_id = $1', [deviceId])
    ).rows.map((row) => row.city_id);

  it('records one vote per device within 500 m, in the nearest city', async () => {
    const deviceId = randomUUID();
    expect((await vote(deviceId, far)).json()).toEqual({ status: 'recorded' });
    // About 450 m east, then about 900 m.
    const near = { latitude: far.latitude, longitude: far.longitude + 0.005 };
    expect((await vote(deviceId, near)).json()).toEqual({ status: 'already_voted' });
    const further = { latitude: far.latitude, longitude: far.longitude + 0.01 };
    expect((await vote(deviceId, further)).json()).toEqual({ status: 'recorded' });
    expect((await vote(randomUUID(), far)).json()).toEqual({ status: 'recorded' });
    expect(await cityOf(deviceId)).toEqual([azaz, azaz]);
  });

  it('gives a vote the city whose zones are nearest, and none past 50 km', async () => {
    const { rows } = await sql.query<{ id: string }>(
      "INSERT INTO geo.cities (code, name) VALUES ('MN', 'منبج') RETURNING id",
    );
    const manbij = { latitude: 36.528, longitude: 37.955 };
    await app
      .get(GeoService)
      .createZone(rows[0]!.id, { name: 'مركز منبج', area: square(manbij), active: true }, change);
    const nearManbij = randomUUID();
    await vote(nearManbij, { latitude: manbij.latitude, longitude: manbij.longitude - 0.05 });
    expect(await cityOf(nearManbij)).toEqual([rows[0]!.id]);
    const damascus = randomUUID();
    expect((await vote(damascus, { latitude: 33.513, longitude: 36.292 })).json()).toEqual({
      status: 'recorded',
    });
    expect(await cityOf(damascus)).toEqual([null]);
  });

  it('refuses a vote from inside a zone', async () => {
    const answer = await vote(randomUUID(), east);
    expect(answer.statusCode).toBe(409);
    expect(answer.json()).toMatchObject({ error: 'inside_zone' });
  });
});

describe('the details (CU §5.3)', () => {
  const details = {
    firstName: 'أحمد',
    lastName: 'الحلبي',
    gender: 'male',
    birthday: '1995-04-01',
  };

  it('are empty until completed, need the terms once, then change', async () => {
    const headers = await signedIn();
    expect((await call(headers, 'GET', '/v1/customer/profile')).json()).toEqual({
      completed: false,
      profile: null,
    });
    const noTerms = await call(headers, 'PUT', '/v1/customer/profile', {
      ...details,
      acceptTerms: false,
    });
    expect(noTerms.statusCode).toBe(400);
    expect(noTerms.json()).toMatchObject({ error: 'terms_required' });
    const saved = await call(headers, 'PUT', '/v1/customer/profile', {
      ...details,
      acceptTerms: true,
    });
    expect(saved.json()).toEqual({ completed: true, profile: details });
    // The tick accepts the customer terms in force (AP §9.13).
    expect((await call(headers, 'GET', '/v1/customer/terms')).json()).toMatchObject({
      pending: false,
    });
    const edited = await call(headers, 'PUT', '/v1/customer/profile', {
      ...details,
      firstName: 'Ahmad-Ali',
      lastName: null,
      birthday: null,
      acceptTerms: false,
    });
    expect(edited.statusCode).toBe(200);
    expect((await call(headers, 'GET', '/v1/customer/profile')).json()).toEqual({
      completed: true,
      profile: { ...details, firstName: 'Ahmad-Ali', lastName: null, birthday: null },
    });
  });

  it.each([
    ['a one-letter name', { firstName: 'أ' }],
    ['a name with digits', { firstName: 'أحمد2' }],
    ['a name of dashes', { firstName: '- -' }],
    ['another gender', { gender: 'other' }],
  ])('refuse %s', async (_, wrong) => {
    const headers = await signedIn();
    const answer = await call(headers, 'PUT', '/v1/customer/profile', {
      ...details,
      ...wrong,
      acceptTerms: true,
    });
    expect(answer.statusCode).toBe(400);
  });

  it('take Arabic marks on a name', async () => {
    const headers = await signedIn();
    const answer = await call(headers, 'PUT', '/v1/customer/profile', {
      ...details,
      firstName: 'محمّد',
      acceptTerms: true,
    });
    expect(answer.statusCode).toBe(200);
  });

  it('refuse a birthday that is not past', async () => {
    const headers = await signedIn();
    const answer = await call(headers, 'PUT', '/v1/customer/profile', {
      ...details,
      birthday: new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Damascus' }).format(new Date()),
      acceptTerms: true,
    });
    expect(answer.json()).toMatchObject({ error: 'invalid_birthday' });
  });

  it('need the account', async () => {
    expect((await call({}, 'GET', '/v1/customer/profile')).statusCode).toBe(401);
  });
});

describe('the saved addresses (CU §7.3)', () => {
  const home = {
    location: centre,
    label: 'home',
    customLabel: null,
    street: 'شارع الجامع، بناء 4',
    floor: null,
    landmark: 'قرب جامع النور',
    contactPhone: null,
    recipientName: null,
    directions: 'الباب الأزرق بجانب الصيدلية',
  };

  it('make the first the default, show the neighbourhood and keep another number with its recipient', async () => {
    const headers = await signedIn();
    const first = await call(headers, 'POST', '/v1/customer/addresses', {
      ...home,
      isDefault: false,
    });
    expect(first.statusCode).toBe(201);
    expect(first.json()).toEqual({
      ...home,
      id: expect.any(String),
      isDefault: true,
      neighbourhood: 'المركز',
    });
    const work = await call(headers, 'POST', '/v1/customer/addresses', {
      ...home,
      location: east,
      label: 'other',
      customLabel: 'بيت أهلي',
      contactPhone: '+905321234567',
      recipientName: 'محمد',
      isDefault: true,
    });
    expect(work.json()).toMatchObject({
      isDefault: true,
      customLabel: 'بيت أهلي',
      contactPhone: '+905321234567',
      neighbourhood: 'الشرق',
    });
    const list = (await call(headers, 'GET', '/v1/customer/addresses')).json().addresses;
    expect(list.map((entry: { isDefault: boolean }) => entry.isDefault)).toEqual([true, false]);
    const { rows } = await sql.query(
      'SELECT contact_phone_encrypted FROM customers.addresses WHERE id = $1',
      [work.json().id],
    );
    expect(rows[0].contact_phone_encrypted).not.toContain('5321234567');
  });

  it('refuse another number without a recipient, «آخر» without its name, and a pin outside the zones', async () => {
    const headers = await signedIn();
    const noName = await call(headers, 'POST', '/v1/customer/addresses', {
      ...home,
      label: 'other',
      isDefault: false,
    });
    expect(noName.statusCode).toBe(400);
    const noRecipient = await call(headers, 'POST', '/v1/customer/addresses', {
      ...home,
      contactPhone: '+963933123456',
      isDefault: false,
    });
    expect(noRecipient.statusCode).toBe(400);
    const outside = await call(headers, 'POST', '/v1/customer/addresses', {
      ...home,
      location: far,
      isDefault: false,
    });
    expect(outside.statusCode).toBe(409);
    expect(outside.json()).toMatchObject({ error: 'outside_zones' });
  });

  it('edit every field, move the default, and pass it on when the default is deleted', async () => {
    const headers = await signedIn();
    const a = (
      await call(headers, 'POST', '/v1/customer/addresses', { ...home, isDefault: false })
    ).json();
    const b = (
      await call(headers, 'POST', '/v1/customer/addresses', { ...home, isDefault: false })
    ).json();
    const edited = await call(headers, 'PUT', `/v1/customer/addresses/${b.id}`, {
      ...home,
      location: east,
      label: 'work',
      street: 'شارع السوق',
    });
    expect(edited.json()).toMatchObject({
      label: 'work',
      street: 'شارع السوق',
      neighbourhood: 'الشرق',
    });
    const moved = await call(headers, 'PUT', `/v1/customer/addresses/${b.id}/default`);
    expect(moved.json()).toMatchObject({ isDefault: true });
    expect((await call(headers, 'DELETE', `/v1/customer/addresses/${b.id}`)).json()).toEqual({
      status: 'deleted',
    });
    const list = (await call(headers, 'GET', '/v1/customer/addresses')).json().addresses;
    expect(list).toEqual([expect.objectContaining({ id: a.id, isDefault: true })]);
  });

  it('show an address whose zone was turned off as outside the delivery area, and never make it the default', async () => {
    const headers = await signedIn();
    const geo = app.get(GeoService);
    const north = { latitude: 36.627, longitude: 37.046 };
    const zone = await geo.createZone(
      azaz,
      { name: 'الشمال', area: square(north), active: true },
      change,
    );
    const add = async (location: Point) =>
      (
        await call(headers, 'POST', '/v1/customer/addresses', {
          ...home,
          location,
          isDefault: false,
        })
      ).json();
    const first = await add(centre);
    const inside = await add(centre);
    const off = await add(north);
    await geo.setZoneActive(azaz, zone, false, change);
    const list = (await call(headers, 'GET', '/v1/customer/addresses')).json().addresses;
    expect(list).toContainEqual(expect.objectContaining({ id: off.id, neighbourhood: null }));
    const moved = await call(headers, 'PUT', `/v1/customer/addresses/${off.id}/default`);
    expect(moved.json()).toMatchObject({ error: 'outside_zones' });
    await call(headers, 'DELETE', `/v1/customer/addresses/${first.id}`);
    const after = (await call(headers, 'GET', '/v1/customer/addresses')).json().addresses;
    expect(after[0]).toMatchObject({ id: inside.id, isDefault: true });
  });

  it("keep up to 10 and refuse another customer's", async () => {
    const headers = await signedIn();
    let id = '';
    for (let n = 0; n < 10; n += 1) {
      id = (
        await call(headers, 'POST', '/v1/customer/addresses', { ...home, isDefault: false })
      ).json().id;
    }
    const eleventh = await call(headers, 'POST', '/v1/customer/addresses', {
      ...home,
      isDefault: false,
    });
    expect(eleventh.json()).toMatchObject({ error: 'address_limit' });
    const other = await signedIn();
    expect((await call(other, 'DELETE', `/v1/customer/addresses/${id}`)).statusCode).toBe(404);
    expect((await call(other, 'PUT', `/v1/customer/addresses/${id}`, home)).statusCode).toBe(404);
    expect((await call(other, 'PUT', `/v1/customer/addresses/${id}/default`)).statusCode).toBe(404);
    expect((await call(other, 'GET', '/v1/customer/addresses')).json()).toEqual({ addresses: [] });
  });
});
