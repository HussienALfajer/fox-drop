import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { INestApplicationContext } from '@nestjs/common';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { Centrifuge, type Subscription } from 'centrifuge';
import { decodeJwt } from 'jose';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestCentrifugo, type TestCentrifugo } from '../../centrifugo/test-centrifugo.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { createBackgroundContext } from '../../roles/start-role.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { DispatchService } from '../dispatch/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import {
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { OrderTimers } from './order-timers.js';

// Architecture §6.1–6.2, RA §4.3, CU §4.3: the apps connect to Centrifugo
// with a short-lived token from the API, the API checks every subscription,
// and the outbox relay of the worker publishes the order's events to the
// restaurant's and the order's channels. The API listens on a real port, so
// Centrifugo's subscription proxy calls it.
let database: TestDatabase;
let cache: TestValkey;
let centrifugo: TestCentrifugo;
let app: NestFastifyApplication;
let worker: INestApplicationContext;
let sql: pg.Pool;
let restaurant: string;
let otherRestaurant: string;
let item: string;
const proxySecret = randomBytes(32).toString('hex');
const tokenSecret = randomBytes(32).toString('hex');

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const centre = { latitude: 36.587, longitude: 37.046 };
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

function square({ latitude, longitude }: Point, half = 0.02): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

async function restaurantWith(azaz: string, name: string): Promise<{ id: string; item: string }> {
  const merchants = app.get(MerchantsService);
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: name,
      location: centre,
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  await merchants.setWeeklySchedule(id, allWeek, change);
  const category = await merchants.addCategory(id, { name: 'وجبات' }, change);
  const itemId = await merchants.addItem(
    id,
    { categoryId: category, name: 'شاورما', price: { amount: 12_000n, currency: 'TRY' } },
    change,
  );
  return { id, item: itemId };
}

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  app = await createApiApp(ApiModule);
  await app.listen({ host: '127.0.0.1', port: 0 });
  const port = Number(new URL(await app.getUrl()).port);
  centrifugo = await startTestCentrifugo({ apiPort: port, proxySecret, tokenSecret });
  Object.assign(process.env, centrifugo.env);
  worker = await createBackgroundContext('worker');

  const azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  const settings = app.get(SettingsService);
  await settings.update('dispatch.capacity_check', { cityId: azaz }, false, bySystem);
  await settings.update(
    'currency.<code>.rounding_unit',
    { cityId: azaz, parameter: 'TRY' },
    { amountMinor: 500 },
    bySystem,
  );
  const geo = app.get(GeoService);
  await geo.createZone(azaz, { name: 'المركز', area: square(centre), active: true }, change);
  await geo.setDeliveryFeeRule(
    azaz,
    { kind: 'flat', currency: 'TRY', flatFee: 4000n, minimumFee: null, freeDeliveryFrom: null },
    change,
  );
  ({ id: restaurant, item } = await restaurantWith(azaz, 'مطعم الاختبار'));
  ({ id: otherRestaurant } = await restaurantWith(azaz, 'مطعم آخر'));
}, 300_000);

afterAll(async () => {
  await worker?.close();
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), centrifugo?.stop()]);
});

const phoneNumber = () => `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;

// A signed-in app user: the headers of its calls.
async function signedIn(
  party: 'customer' | 'merchant',
  restaurantId = restaurant,
  role: 'owner' | 'cashier' = 'cashier',
): Promise<Record<string, string>> {
  const phone = phoneNumber();
  if (party === 'merchant') {
    await app
      .get(MerchantAccountsService)
      .addAccount(restaurantId, { role, name: role, phone }, change);
  }
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: `/v1/${party}/auth/code`, payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: `/v1/${party}/auth/sign-in`,
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

async function realtimeToken(
  party: 'customer' | 'merchant' | 'captain',
  headers: Record<string, string>,
) {
  const answer = await app.inject({ method: 'POST', url: `/v1/${party}/realtime/token`, headers });
  expect(answer.statusCode).toBe(200);
  return answer.json().token as string;
}

async function place(headers: Record<string, string>): Promise<string> {
  const lines = [{ itemId: item, optionIds: [], quantity: 1, note: null, knownUnitPrice: '12000' }];
  const body = { restaurantId: restaurant, lines, payIn: null, appVersion: '1.0.0' };
  const quote = await app.inject({
    method: 'POST',
    url: '/v1/customer/quote',
    payload: { ...body, location: centre },
  });
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/customer/orders',
    headers: { ...headers, 'idempotency-key': randomUUID() },
    payload: {
      ...body,
      quoteVersion: quote.json().version,
      addressId: null,
      unsavedAddress: {
        location: centre,
        street: 'شارع السوق، بناء 4',
        floor: null,
        landmark: 'قرب جامع النور',
        contactPhone: null,
        recipientName: null,
        directions: null,
      },
      note: null,
    },
  });
  expect(answer.statusCode).toBe(201);
  return answer.json().order.id;
}

// The proxy's answer to a subscription, as Centrifugo asks for it.
async function proxied(
  party: 'customer' | 'merchant' | 'captain',
  token: string,
  channel: string,
  secret: string | null = proxySecret,
) {
  const claims = decodeJwt(token);
  return app.inject({
    method: 'POST',
    url: `/v1/${party}/realtime/subscribe`,
    headers: secret === null ? {} : { 'x-centrifugo-proxy-secret': secret },
    payload: {
      client: randomUUID(),
      transport: 'websocket',
      protocol: 'json',
      encoding: 'json',
      user: claims.sub,
      channel,
      meta: claims.meta,
    },
  });
}

// A connected client and its subscription; its publications as they arrive.
function subscribed(token: string, channel: string) {
  const client = new Centrifuge(centrifugo.websocketUrl, { token, websocket: WebSocket });
  const subscription: Subscription = client.newSubscription(channel);
  const received: unknown[] = [];
  subscription.on('publication', (context) => received.push(context.data));
  const outcome = new Promise<'subscribed' | number>((resolve) => {
    subscription.on('subscribed', () => resolve('subscribed'));
    subscription.on('unsubscribed', (context) => resolve(context.code));
  });
  const disconnected = new Promise<number>((resolve) => {
    client.on('disconnected', (context) => resolve(context.code));
  });
  subscription.subscribe();
  client.connect();
  return { client, outcome, disconnected, received };
}

async function eventually(check: () => boolean, ms = 10_000): Promise<void> {
  const deadline = Date.now() + ms;
  while (!check()) {
    if (Date.now() > deadline) throw new Error('timed out');
    await new Promise((resolve) => setTimeout(resolve, 100));
  }
}

describe('connection tokens (architecture §6.1)', () => {
  it("issues a short-lived token for the session, without the app's secret", async () => {
    const token = await realtimeToken('merchant', await signedIn('merchant'));
    const claims = decodeJwt(token);
    expect(claims.meta).toMatchObject({ party: 'merchant' });
    expect(claims.exp! - claims.iat!).toBe(15 * 60);
  });

  it('answers 503 while real time is off', async () => {
    const headers = await signedIn('customer');
    delete process.env.CENTRIFUGO_TOKEN_SECRET;
    try {
      const answer = await app.inject({
        method: 'POST',
        url: '/v1/customer/realtime/token',
        headers,
      });
      expect(answer.statusCode).toBe(503);
      expect(answer.json()).toMatchObject({ error: 'realtime_unavailable' });
    } finally {
      Object.assign(process.env, centrifugo.env);
    }
  });

  it('refuses the owners of a terminated restaurant, who keep only the money section (RA §5.5)', async () => {
    const azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
    const { id } = await restaurantWith(azaz, 'مطعم يغلق');
    const owner = await signedIn('merchant', id, 'owner');
    const token = await realtimeToken('merchant', owner);
    await app.get(MerchantsService).setAccountStatus(id, 'terminated', change);

    const answer = await app.inject({
      method: 'POST',
      url: '/v1/merchant/realtime/token',
      headers: owner,
    });
    expect(answer.statusCode).toBe(403);
    expect(answer.json()).toMatchObject({ error: 'restaurant_terminated' });
    expect((await proxied('merchant', token, `merchant:${id}`)).json()).toMatchObject({
      error: { code: 403 },
    });
  });

  it('needs a signed-in user of the app', async () => {
    const anonymous = await app.inject({ method: 'POST', url: '/v1/customer/realtime/token' });
    expect(anonymous.statusCode).toBe(401);
    const merchant = await signedIn('merchant');
    const crossed = await app.inject({
      method: 'POST',
      url: '/v1/customer/realtime/token',
      headers: merchant,
    });
    expect(crossed.statusCode).toBe(401);
  });
});

describe('the subscription proxy (architecture §6.1–6.2)', () => {
  it('lets a restaurant device into its own restaurant only', async () => {
    const token = await realtimeToken('merchant', await signedIn('merchant'));
    expect((await proxied('merchant', token, `merchant:${restaurant}`)).json()).toEqual({
      result: {},
    });
    expect((await proxied('merchant', token, `merchant:${otherRestaurant}`)).json()).toEqual({
      error: { code: 403, message: 'permission denied' },
    });
  });

  it("lets a customer into their own order only, and nobody into another app's channel", async () => {
    const customer = await signedIn('customer');
    const token = await realtimeToken('customer', customer);
    const order = await place(customer);
    const stranger = await realtimeToken('customer', await signedIn('customer'));
    const merchant = await realtimeToken('merchant', await signedIn('merchant'));

    expect((await proxied('customer', token, `order:${order}`)).json()).toEqual({ result: {} });
    expect((await proxied('customer', stranger, `order:${order}`)).json()).toMatchObject({
      error: { code: 403 },
    });
    expect((await proxied('customer', token, `merchant:${restaurant}`)).json()).toMatchObject({
      error: { code: 403 },
    });
    expect((await proxied('merchant', merchant, `order:${order}`)).json()).toMatchObject({
      error: { code: 403 },
    });
    expect((await proxied('merchant', token, `merchant:${restaurant}`)).json()).toMatchObject({
      error: { code: 403 },
    });
  });

  it('ends the connection of a session that was signed out', async () => {
    const headers = await signedIn('merchant');
    const token = await realtimeToken('merchant', headers);
    const signOut = await app.inject({
      method: 'POST',
      url: '/v1/merchant/auth/sign-out',
      headers,
    });
    expect(signOut.statusCode).toBeLessThan(300);
    expect((await proxied('merchant', token, `merchant:${restaurant}`)).json()).toEqual({
      disconnect: { code: 4501, reason: 'session ended' },
    });
  });

  it("refuses a call without Centrifugo's secret, and every call while none is set", async () => {
    const token = await realtimeToken('merchant', await signedIn('merchant'));
    expect((await proxied('merchant', token, `merchant:${restaurant}`, null)).statusCode).toBe(403);
    expect((await proxied('merchant', token, `merchant:${restaurant}`, 'wrong')).statusCode).toBe(
      403,
    );
    delete process.env.CENTRIFUGO_PROXY_SECRET;
    try {
      expect((await proxied('merchant', token, `merchant:${restaurant}`)).statusCode).toBe(403);
    } finally {
      Object.assign(process.env, centrifugo.env);
    }
  });

  it('refuses a malformed channel and a session it does not know', async () => {
    const token = await realtimeToken('merchant', await signedIn('merchant'));
    for (const channel of [
      `merchant:${restaurant}:x`,
      'merchant:x',
      `captain:${restaurant}`,
      restaurant,
    ]) {
      expect((await proxied('merchant', token, channel)).json()).toMatchObject({
        error: { code: 403 },
      });
    }
    const claims = decodeJwt(token);
    const unknown = await app.inject({
      method: 'POST',
      url: '/v1/merchant/realtime/subscribe',
      headers: { 'x-centrifugo-proxy-secret': proxySecret },
      payload: { user: randomUUID(), channel: `merchant:${restaurant}`, meta: claims.meta },
    });
    expect(unknown.json()).toEqual({ disconnect: { code: 4501, reason: 'session ended' } });
  });
});

describe('the order reaches the apps through Centrifugo (RA §4.3, CU §4.3)', () => {
  it("rings the restaurant's devices with the new order and updates the customer's order screen", async () => {
    const cashier = subscribed(
      await realtimeToken('merchant', await signedIn('merchant')),
      `merchant:${restaurant}`,
    );
    // Another restaurant's device, on its own channel and on this one.
    const elsewhere = subscribed(
      await realtimeToken('merchant', await signedIn('merchant', otherRestaurant)),
      `merchant:${otherRestaurant}`,
    );
    const intruder = subscribed(
      await realtimeToken('merchant', await signedIn('merchant', otherRestaurant)),
      `merchant:${restaurant}`,
    );
    try {
      expect(await cashier.outcome).toBe('subscribed');
      expect(await elsewhere.outcome).toBe('subscribed');
      expect(await intruder.outcome).toBe(403);

      const customer = await signedIn('customer');
      const orderId = await place(customer);
      // The restaurant's events of this order, in the order they came; an
      // earlier test's order may still arrive.
      const ofOrder = () =>
        cashier.received.filter((data) => (data as { orderId: string }).orderId === orderId);
      await eventually(() => ofOrder().length > 0);
      expect(ofOrder()[0]).toMatchObject({
        type: 'order.placed',
        schema: 1,
        orderId,
        number: expect.stringMatching(/^\d+$/) as unknown,
        restaurantId: restaurant,
        status: 'placed',
        version: 1,
      });
      // Only what the apps need (RA §4.3).
      expect(ofOrder()[0]).not.toHaveProperty('customerAccountId');

      const screen = subscribed(await realtimeToken('customer', customer), `order:${orderId}`);
      try {
        expect(await screen.outcome).toBe('subscribed');
        // The restaurant does not answer in time (AP §8.3).
        const { rows } = await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [
          orderId,
        ]);
        await worker
          .get(OrderTimers)
          .merchantAutoCancel(
            { orderId, placedAt: rows[0].placed_at.toISOString(), version: 1 },
            new Date(),
          );
        await eventually(() => screen.received.length > 0);
        expect(screen.received[0]).toMatchObject({
          type: 'order.cancelled',
          orderId,
          status: 'cancelled',
          version: 2,
          reason: 'merchant_auto_cancel',
        });
        await eventually(() => ofOrder().length > 1);
        expect(ofOrder()[1]).toMatchObject({ orderId, status: 'cancelled', version: 2 });
      } finally {
        screen.client.disconnect();
      }
      expect(elsewhere.received).toEqual([]);
    } finally {
      for (const each of [cashier, elsewhere, intruder]) each.client.disconnect();
    }
  });
});

describe('a sign-out applies at once (CU §5.4, RA §5.1)', () => {
  it('disconnects the connections of a session that signs out, and only them', async () => {
    const leaving = await signedIn('merchant');
    const leavingDevice = subscribed(
      await realtimeToken('merchant', leaving),
      `merchant:${restaurant}`,
    );
    const staying = subscribed(
      await realtimeToken('merchant', await signedIn('merchant')),
      `merchant:${restaurant}`,
    );
    try {
      expect(await leavingDevice.outcome).toBe('subscribed');
      expect(await staying.outcome).toBe('subscribed');

      await app.inject({ method: 'POST', url: '/v1/merchant/auth/sign-out', headers: leaving });

      expect(await leavingDevice.disconnected).toBe(4501);
      const customer = await signedIn('customer');
      const orderId = await place(customer);
      await eventually(() =>
        staying.received.some((data) => (data as { orderId: string }).orderId === orderId),
      );
      expect(leavingDevice.received).not.toContainEqual(expect.objectContaining({ orderId }));
    } finally {
      leavingDevice.client.disconnect();
      staying.client.disconnect();
    }
  });
});

// An activated motorbike captain with its app account's phone.
async function captainSignedIn() {
  const phone = phoneNumber();
  const azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const captainId = await app.get(CaptainsService).createCaptain(
    azaz,
    {
      name: 'كابتن القناة',
      vehicle: 'motorbike',
      plateNumber: randomUUID().slice(0, 6),
      custodyLimit: { amount: 300_000n, currency: 'TRY' },
    },
    change,
  );
  await app.get(CaptainAccountsService).addAccount(captainId, phone, change);
  return { captainId, phone };
}

// The captain signed in on a new device: its headers. Signing in again is
// another device (CA §4.9).
async function captainDevice(phone: string) {
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/captain/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/captain/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  expect(answer.statusCode).toBe(200);
  return { authorization: `Bearer ${answer.json().accessToken}` };
}

describe("the captain's channel (architecture §6.2, CA §15)", () => {
  it('lets a captain into its own channel only, and carries its offers', async () => {
    const { captainId, phone } = await captainSignedIn();
    const other = await captainSignedIn();
    const device = await captainDevice(phone);
    const token = await realtimeToken('captain', device);
    expect((await proxied('captain', token, `captain:${captainId}`)).json()).toEqual({
      result: {},
    });
    expect((await proxied('captain', token, `captain:${other.captainId}`)).json()).toMatchObject({
      error: { code: 403 },
    });
    // Another app's proxy refuses a captain's connection.
    expect((await proxied('merchant', token, `merchant:${restaurant}`)).json()).toMatchObject({
      error: { code: 403 },
    });

    const channel = subscribed(token, `captain:${captainId}`);
    try {
      expect(await channel.outcome).toBe('subscribed');
      const captains = app.get(CaptainsService);
      const now = new Date();
      await captains.goOnline(captainId, { appVersion: '1.0.0', simulatedLocation: false }, now);
      await captains.recordLocations(
        captainId,
        [{ ...centre, accuracyMetres: 8, recordedAt: now, simulated: false }],
        new Date(now.getTime() + 1),
      );
      const orderId = await place(await signedIn('customer'));
      const accepted = await app.inject({
        method: 'POST',
        url: `/v1/merchant/orders/${orderId}/accept`,
        headers: { ...(await signedIn('merchant')), 'idempotency-key': randomUUID() },
        payload: { prepMin: 20 },
      });
      expect(accepted.statusCode).toBe(200);
      const state = await app.get(DispatchService).assign(
        {
          orderId,
          captainId,
          admin: { accountId: randomUUID(), roles: ['OPS'] },
          context: { ipAddress: null, device: null },
          idempotencyKey: randomUUID(),
        },
        new Date(),
      );
      await eventually(() => channel.received.length > 0);
      expect(channel.received[0]).toMatchObject({
        type: 'order.offered',
        orderId,
        status: 'accepted',
        version: state.version,
        captainTrack: 'offered',
      });
      expect(channel.received[0]).not.toHaveProperty('captainId');
    } finally {
      channel.client.disconnect();
      await app.get(CaptainsService).goOffline(captainId, new Date());
    }
  });

  it("ends a captain's connection when the captain signs in on another device (CA §4.9)", async () => {
    const { captainId, phone } = await captainSignedIn();
    const first = subscribed(
      await realtimeToken('captain', await captainDevice(phone)),
      `captain:${captainId}`,
    );
    try {
      expect(await first.outcome).toBe('subscribed');
      // Past the resend wait of the first code (otp.resend_after_sec).
      await sql.query(
        "UPDATE identity.app_sign_in_codes SET created_at = created_at - interval '5 minutes'",
      );
      await captainDevice(phone);
      expect(await first.disconnected).toBe(4501);
    } finally {
      first.client.disconnect();
    }
  });
});
