import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { INestApplicationContext } from '@nestjs/common';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { Centrifuge, type Subscription } from 'centrifuge';
import { decodeJwt } from 'jose';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestCentrifugo, type TestCentrifugo } from '../../centrifugo/test-centrifugo.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { createBackgroundContext } from '../../roles/start-role.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { CaptainsService } from '../captains/index.js';
import { DispatchService } from '../dispatch/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
} from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { OrderAlerts } from './order-alerts.js';
import { OrderTimers } from './order-timers.js';
import { ResendNotification } from './resend-notification.js';

// Architecture §6.1–6.2, RA §4.3, CU §4.3: the apps connect to Centrifugo
// with a short-lived token from the API, the API checks every subscription,
// and the outbox relay of the worker publishes the order's events to the
// restaurant's and the order's channels. The API listens on a real port, so
// Centrifugo's subscription proxy calls it.
// Each test waits on Centrifugo and the worker's loops (eventually, up to
// 10 s a step), so the default 5 s is too short for a full parallel run.
vi.setConfig({ testTimeout: 30_000 });

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
  // AP §9.12.5: a pay table in force, which placing needs (captain_pay_unset).
  const payRate = {
    basePay: 2500n,
    includedMetres: 3000,
    perExtraKm: 500n,
    waitingPerMinute: 0n,
    minimumPay: 2500n,
  };
  await app.get(CaptainsService).setPayTable(
    azaz,
    {
      currency: 'TRY',
      rates: { walking: payRate, bicycle: payRate, motorbike: payRate, car: payRate },
    },
    change,
  );
  const settings = app.get(SettingsService);
  await settings.update('dispatch.capacity_check', { cityId: azaz }, false, bySystem);
  // Every test signs in from the same address (architecture §8.3.3 item 2).
  await settings.update('otp.ip_hourly_max', {}, 1000, bySystem);
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
  // A customer orders (CU §4.7) and a captain goes online (K7) once the terms
  // in force (the seeded version 1) are accepted.
  if (party !== 'merchant') {
    await app.inject({
      method: 'POST',
      url: `/v1/${party}/terms/accept`,
      headers: { authorization: `Bearer ${answer.json().accessToken}` },
      payload: { version: 1 },
    });
  }
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
  party: 'customer' | 'merchant' | 'captain' | 'admin',
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
      await captains.goOnline(
        captainId,
        { appVersion: '1.0.0', simulatedLocation: false, termsPending: false },
        now,
      );
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

// A panel user with these roles: the cookie of its session.
let operators = 0;
async function operator(roles: string[]): Promise<Record<string, string>> {
  return (await operatorAccount(roles)).cookies;
}

async function operatorAccount(
  roles: string[],
): Promise<{ accountId: string; sessionId: string; cookies: Record<string, string> }> {
  operators += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Operator ${operators}`, `realtime${operators}@example.test`],
  );
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [rows[0].id, role],
    );
  }
  const { token, session } = await app
    .get(AdminSessionsService)
    .start(
      app.get<Database>(DATABASE).db,
      rows[0].id,
      { ipAddress: '203.0.113.9', device: 'test' },
      new Date(),
    );
  return {
    accountId: rows[0].id,
    sessionId: session.id,
    cookies: { [ADMIN_SESSION_COOKIE]: token },
  };
}

async function panelToken(cookies: Record<string, string>): Promise<string> {
  const answer = await app.inject({ method: 'POST', url: '/v1/admin/realtime/token', cookies });
  expect(answer.statusCode).toBe(200);
  return answer.json().token as string;
}

const azazId = async (): Promise<string> =>
  (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;

describe("the panel's city channel (architecture §6.2, §10.3)", () => {
  it('issues a token for the cookie session, and none without one', async () => {
    const claims = decodeJwt(await panelToken(await operator(['OPS'])));
    expect(claims.meta).toMatchObject({ party: 'admin' });
    expect(claims.exp! - claims.iat!).toBe(15 * 60);
    const anonymous = await app.inject({ method: 'POST', url: '/v1/admin/realtime/token' });
    expect(anonymous.statusCode).toBe(401);
  });

  it('lets in the users who see the board or receive alerts, and nobody else (owner decision 2026-11-08)', async () => {
    const channel = `ops:city.${await azazId()}`;
    for (const roles of [['OPS'], ['OWN'], ['SUP'], ['FIN']]) {
      const token = await panelToken(await operator(roles));
      expect((await proxied('admin', token, channel)).json(), roles.join()).toEqual({ result: {} });
    }
    const data = await panelToken(await operator(['DATA']));
    expect((await proxied('admin', data, channel)).json()).toMatchObject({ error: { code: 403 } });
    const ops = await panelToken(await operator(['OPS']));
    for (const malformed of [`ops:${await azazId()}`, 'ops:city.x', `ops:city.${randomUUID()}:x`]) {
      expect((await proxied('admin', ops, malformed)).json()).toMatchObject({
        error: { code: 403 },
      });
    }
    // An app's session never reaches the panel's channel, nor the panel an app's.
    const merchant = await realtimeToken('merchant', await signedIn('merchant'));
    expect((await proxied('merchant', merchant, channel)).json()).toMatchObject({
      error: { code: 403 },
    });
    expect((await proxied('admin', merchant, channel)).json()).toMatchObject({
      error: { code: 403 },
    });
    expect((await proxied('admin', ops, `merchant:${restaurant}`)).json()).toMatchObject({
      error: { code: 403 },
    });
  });

  it('disconnects a panel session past its idle end or of a disabled account, without recording activity (AP §5.2)', async () => {
    const channel = `ops:city.${await azazId()}`;
    const idle = await operatorAccount(['OPS']);
    const idleToken = await panelToken(idle.cookies);
    const before = new Date(Date.now() - 2 * 3_600_000);
    await sql.query('UPDATE identity.admin_sessions SET last_activity_at = $2 WHERE id = $1', [
      idle.sessionId,
      before,
    ]);
    expect((await proxied('admin', idleToken, channel)).json()).toEqual({
      disconnect: { code: 4501, reason: 'session ended' },
    });
    const { rows } = await sql.query(
      'SELECT last_activity_at, ended_at FROM identity.admin_sessions WHERE id = $1',
      [idle.sessionId],
    );
    expect(rows[0]).toEqual({ last_activity_at: before, ended_at: null });

    const disabled = await operatorAccount(['OPS']);
    const disabledToken = await panelToken(disabled.cookies);
    await sql.query("UPDATE identity.admin_accounts SET status = 'disabled' WHERE id = $1", [
      disabled.accountId,
    ]);
    expect((await proxied('admin', disabledToken, channel)).json()).toEqual({
      disconnect: { code: 4501, reason: 'session ended' },
    });
  });

  it('ends the connection at a forced sign-out and checks it again at a role change (AP §5.3, §6.1)', async () => {
    const channel = `ops:city.${await azazId()}`;
    const owner = await operator(['OWN']);
    const forced = await operatorAccount(['OPS']);
    const forcedBoard = subscribed(await panelToken(forced.cookies), channel);
    const demoted = await operatorAccount(['OPS']);
    const client = new Centrifuge(centrifugo.websocketUrl, {
      token: await panelToken(demoted.cookies),
      websocket: WebSocket,
    });
    const subscription = client.newSubscription(channel);
    const states: (string | number)[] = [];
    subscription.on('subscribed', () => states.push('subscribed'));
    subscription.on('unsubscribed', (context) => states.push(context.code));
    subscription.subscribe();
    client.connect();
    try {
      expect(await forcedBoard.outcome).toBe('subscribed');
      await eventually(() => states.includes('subscribed'));

      const signOut = await app.inject({
        method: 'POST',
        url: `/v1/admin/team/users/${forced.accountId}/sign-out`,
        cookies: owner,
      });
      expect(signOut.statusCode).toBeLessThan(300);
      expect(await forcedBoard.disconnected).toBe(4501);

      // DATA neither sees the board nor receives alerts: the reconnect's
      // subscription is refused.
      const roles = await app.inject({
        method: 'PUT',
        url: `/v1/admin/team/users/${demoted.accountId}/roles`,
        cookies: owner,
        payload: { roles: ['DATA'] },
      });
      expect(roles.statusCode).toBeLessThan(300);
      await eventually(() => states.includes(403));
    } finally {
      forcedBoard.client.disconnect();
      client.disconnect();
    }
  });

  it('ends the connection of a panel session that signs out', async () => {
    const cookies = await operator(['OPS']);
    const channel = `ops:city.${await azazId()}`;
    const board = subscribed(await panelToken(cookies), channel);
    try {
      expect(await board.outcome).toBe('subscribed');
      await app.inject({ method: 'POST', url: '/v1/admin/auth/sign-out', cookies });
      expect(await board.disconnected).toBe(4501);
    } finally {
      board.client.disconnect();
    }
  });

  it("carries the order's events and its alert «مطعم لم يقبل» to the board within seconds (AP §7.3)", async () => {
    const board = subscribed(
      await panelToken(await operator(['OPS'])),
      `ops:city.${await azazId()}`,
    );
    try {
      expect(await board.outcome).toBe('subscribed');
      const orderId = await place(await signedIn('customer'));
      const ofOrder = () =>
        board.received.filter((data) => (data as { orderId?: string }).orderId === orderId);
      await eventually(() => ofOrder().length > 0);
      expect(ofOrder()[0]).toMatchObject({ type: 'order.placed', orderId, version: 1 });
      expect(ofOrder()[0]).not.toHaveProperty('customerAccountId');

      // The restaurant leaves it unaccepted past order.merchant_accept_alert_min.
      const { rows } = await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [
        orderId,
      ]);
      const placedAt: Date = rows[0].placed_at;
      await worker
        .get(OrderAlerts)
        .sync(
          { orderId, placedAt: placedAt.toISOString() },
          new Date(placedAt.getTime() + 4 * 60_000),
          false,
        );
      const alerts = await app.inject({
        method: 'GET',
        url: `/v1/admin/alerts?cityId=${await azazId()}`,
        cookies: await operator(['OPS']),
      });
      const alert = (
        alerts.json().alerts as { id: string; code: string; subjectId: string }[]
      ).find((each) => each.subjectId === orderId);
      expect(alert).toMatchObject({ code: 'restaurant_not_accepted' });
      await eventually(() =>
        board.received.some((data) => (data as { alertId?: string }).alertId === alert!.id),
      );
      expect(
        board.received.find((data) => (data as { alertId?: string }).alertId === alert!.id),
      ).toEqual({
        type: 'alert.raised',
        schema: 1,
        alertId: alert!.id,
        at: expect.any(String) as unknown,
      });

      // «استلام» reaches every board of the city, so its sound stops (AP §7.3).
      const taken = await app.inject({
        method: 'POST',
        url: `/v1/admin/alerts/${alert!.id}/acknowledge`,
        cookies: await operator(['OPS']),
      });
      expect(taken.statusCode).toBe(200);
      await eventually(() =>
        board.received.some(
          (data) =>
            (data as { alertId?: string; type: string }).alertId === alert!.id &&
            (data as { type: string }).type === 'alert.acknowledged',
        ),
      );
    } finally {
      board.client.disconnect();
    }
  });
});

describe("the order's pushes (architecture §8.1, CU §14, RA §16, CA §14)", () => {
  // The pushes queued for the order, by template: the worker turns each
  // event into them within seconds, whether push is on or not.
  async function pushesOf(orderId: string) {
    const { rows } = await sql.query(
      `SELECT template_key, body, party, priority, level FROM notifications.push_messages
       WHERE data->>'orderId' = $1 ORDER BY created_at, template_key`,
      [orderId],
    );
    return rows as {
      template_key: string;
      body: string;
      party: string;
      priority: string;
      level: string;
    }[];
  }

  async function eventuallyPushed(orderId: string, templateKey: string) {
    const deadline = Date.now() + 10_000;
    for (;;) {
      const found = (await pushesOf(orderId)).find((row) => row.template_key === templateKey);
      if (found) return found;
      if (Date.now() > deadline) throw new Error(`no ${templateKey} for ${orderId}`);
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
  }

  it('rings the restaurant, tells the customer the time and offers the captain the pay', async () => {
    const { captainId, phone } = await captainSignedIn();
    await captainDevice(phone);
    const captains = app.get(CaptainsService);
    const now = new Date();
    await captains.goOnline(
      captainId,
      { appVersion: '1.0.0', simulatedLocation: false, termsPending: false },
      now,
    );
    await captains.recordLocations(
      captainId,
      [{ ...centre, accuracyMetres: 8, recordedAt: now, simulated: false }],
      new Date(now.getTime() + 1),
    );
    try {
      const orderId = await place(await signedIn('customer'));
      const number = (
        await sql.query('SELECT number FROM ordering.orders WHERE id = $1', [orderId])
      ).rows[0].number;
      expect(await eventuallyPushed(orderId, 'merchant.new_order')).toEqual({
        template_key: 'merchant.new_order',
        body: `طلب جديد #${number}`,
        party: 'merchant',
        priority: 'high',
        level: 'ring',
      });

      const accepted = await app.inject({
        method: 'POST',
        url: `/v1/merchant/orders/${orderId}/accept`,
        headers: { ...(await signedIn('merchant')), 'idempotency-key': randomUUID() },
        payload: { prepMin: 20 },
      });
      expect(accepted.statusCode).toBe(200);
      expect((await eventuallyPushed(orderId, 'customer.accepted')).body).toMatch(
        /^المطعم يحضّر طلبك\. يصل حوالي \d{1,2}:\d{2} [صم]$/,
      );

      await app.get(DispatchService).assign(
        {
          orderId,
          captainId,
          admin: { accountId: randomUUID(), roles: ['OPS'] },
          context: { ipAddress: null, device: null },
          idempotencyKey: randomUUID(),
        },
        new Date(),
      );
      expect(await eventuallyPushed(orderId, 'captain.new_offer')).toMatchObject({
        body: 'عرض جديد: 25 ₺ — مطعم الاختبار',
        party: 'captain',
        level: 'offer',
      });
    } finally {
      await captains.goOffline(captainId, new Date());
    }
  });

  it("apologises to the customer for an automatic cancellation and counts the restaurant's (AP §8.3)", async () => {
    const orderId = await place(await signedIn('customer'));
    const { rows } = await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [
      orderId,
    ]);
    await worker
      .get(OrderTimers)
      .merchantAutoCancel(
        { orderId, placedAt: rows[0].placed_at.toISOString(), version: 1 },
        new Date(),
      );
    const apology = await eventuallyPushed(orderId, 'customer.cancelled');
    expect(apology.body.startsWith('أُلغي طلبك: ')).toBe(true);
    expect(apology.body.length).toBeGreaterThan('أُلغي طلبك: '.length);
    expect((await eventuallyPushed(orderId, 'merchant.auto_cancelled')).body).toMatch(
      /^أُلغي الطلب #\d+ لعدم الرد \(\d+ من 3 اليوم\)$/,
    );
  });

  it('pushes the current state again on «إعادة إرسال الإشعار» (AP §9.3.2)', async () => {
    const orderId = await place(await signedIn('customer'));
    await eventuallyPushed(orderId, 'merchant.new_order');
    const resends = app.get(ResendNotification);
    const command = (to: 'customer' | 'merchant' | 'captain') => ({
      orderId,
      to,
      admin: { accountId: randomUUID(), roles: ['SUP'] },
      context: { ipAddress: null, device: null },
    });
    expect(await resends.resend(command('merchant'), new Date())).toEqual({
      body: expect.stringMatching(/^طلب جديد #\d+$/) as unknown,
    });
    expect(
      (await pushesOf(orderId)).filter((row) => row.template_key === 'merchant.new_order'),
    ).toHaveLength(2);
    await expect(resends.resend(command('customer'), new Date())).rejects.toMatchObject({
      refusal: 'nothing_to_resend',
    });
    await expect(resends.resend(command('captain'), new Date())).rejects.toMatchObject({
      refusal: 'order_state_changed',
    });
    const { rows } = await sql.query(
      "SELECT changes FROM audit.events WHERE action = 'order.resend_notification' AND target_id = $1",
      [orderId],
    );
    expect(rows.map((row) => row.changes)).toEqual([
      {
        to: { before: null, after: 'merchant' },
        templateKey: { before: null, after: 'merchant.new_order' },
      },
    ]);
  });

  it('answers the panel by its route: who may, a missing order, and a step already past', async () => {
    const orderId = await place(await signedIn('customer'));
    await eventuallyPushed(orderId, 'merchant.new_order');
    const resend = (cookies: Record<string, string>, id = orderId, to = 'merchant') =>
      app.inject({
        method: 'POST',
        url: `/v1/admin/orders/${id}/resend-notification`,
        cookies,
        payload: { to },
      });
    const support = await operator(['SUP']);
    expect((await resend({})).statusCode).toBe(401);
    expect((await resend(await operator(['FIN']))).statusCode).toBe(403);
    const sent = await resend(support);
    expect(sent.statusCode).toBe(200);
    expect(sent.json().body).toMatch(/^طلب جديد #\d+$/);
    expect((await resend(support, randomUUID())).json()).toMatchObject({
      statusCode: 404,
      error: 'unknown_order',
    });

    // Accepted, the restaurant has nothing of the order's state to hear again.
    const accepted = await app.inject({
      method: 'POST',
      url: `/v1/merchant/orders/${orderId}/accept`,
      headers: { ...(await signedIn('merchant')), 'idempotency-key': randomUUID() },
      payload: { prepMin: 20 },
    });
    expect(accepted.statusCode).toBe(200);
    expect((await resend(support)).json()).toMatchObject({
      statusCode: 409,
      error: 'nothing_to_resend',
    });
    await eventuallyPushed(orderId, 'customer.accepted');
    expect((await resend(support, orderId, 'customer')).json().body).toMatch(/^المطعم يحضّر طلبك/);
  });
});
