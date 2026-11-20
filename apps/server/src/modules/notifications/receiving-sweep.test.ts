import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import { Centrifuge } from 'centrifuge';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { startTestCentrifugo, type TestCentrifugo } from '../../centrifugo/test-centrifugo.js';
import { DATABASE } from '../../database/database.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import {
  CODE_SENDER,
  type DevelopmentCodeSender,
  MerchantAccountsService,
  OpenAppSessions,
} from '../identity/index.js';
import { MerchantsService, ReceivingDevicesService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { AlertsService } from './alerts.service.js';
import { PushQueue } from './push-queue.js';
import { RealtimePublisher } from './realtime-publisher.js';
import { ReceivingSweep } from './receiving-sweep.js';

// RA §4.3–4.6, AP §9.1.1, §9.1.3 (slice 2.42): the worker reads who is on
// each restaurant's channel, counts its receiving devices and raises «مطعم
// مفتوح بلا جهاز استقبال» after merchant.no_device_alert_min, with the
// owners' push. A real Centrifugo, the API on a real port behind its proxy.
vi.setConfig({ testTimeout: 60_000 });

let database: TestDatabase;
let cache: TestValkey;
let centrifugo: TestCentrifugo;
let app: NestFastifyApplication;
let sql: pg.Pool;
let sweep: ReceivingSweep;
let azaz: string;
const clients: Centrifuge[] = [];

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };
const bySystem = { editor: 'system', context: change.context, reason: 'test' } as const;
const allWeek = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({ weekday, opensAt: 0, closesAt: 0 }));

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
  centrifugo = await startTestCentrifugo({
    apiPort: port,
    proxySecret: randomBytes(32).toString('hex'),
    tokenSecret: randomBytes(32).toString('hex'),
  });
  Object.assign(process.env, centrifugo.env);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  await app.get(SettingsService).update('otp.ip_hourly_max', {}, 1000, bySystem);
  sweep = new ReceivingSweep(
    app.get(DATABASE),
    app.get(GeoService),
    app.get(MerchantsService),
    app.get(ReceivingDevicesService),
    app.get(OpenAppSessions),
    app.get(RealtimePublisher, { strict: false }),
    app.get(SettingsService),
    app.get(AlertsService, { strict: false }),
    app.get(NotificationTexts, { strict: false }),
    app.get(PushQueue, { strict: false }),
  );
}, 300_000);

afterAll(async () => {
  for (const client of clients) client.disconnect();
  await app?.close();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop(), centrifugo?.stop()]);
});

async function restaurant(): Promise<string> {
  const merchants = app.get(MerchantsService);
  const id = await merchants.createRestaurant(
    azaz,
    {
      nameAr: `مطعم ${randomUUID()}`,
      location: { latitude: 36.587, longitude: 37.046 },
      coverage: { kind: 'radius', radiusMetres: 1000 },
      minimumOrder: { amount: 10_000n, currency: 'TRY' },
      commissionBp: 1500,
      defaultPrepMin: 20,
    },
    change,
  );
  await merchants.setAccountStatus(id, 'active', change);
  await merchants.setWeeklySchedule(id, allWeek, change);
  return id;
}

// A restaurant user signed in on a named device.
async function user(restaurantId: string, role: 'owner' | 'cashier') {
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  await app
    .get(MerchantAccountsService)
    .addAccount(restaurantId, { role, name: role, phone }, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/merchant/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const signedIn = await app.inject({
    method: 'POST',
    url: '/v1/merchant/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  const headers = { authorization: `Bearer ${signedIn.json().accessToken}` };
  await app.inject({
    method: 'PUT',
    url: '/v1/merchant/auth/device',
    headers,
    payload: { name: role, platform: 'android', appVersion: '1.0.0' },
  });
  return { deviceId, headers };
}

// The device's app on its restaurant's channel.
async function connect(restaurantId: string, headers: Record<string, string>) {
  const answer = await app.inject({ method: 'POST', url: '/v1/merchant/realtime/token', headers });
  const client = new Centrifuge(centrifugo.websocketUrl, {
    token: answer.json().token as string,
    websocket: WebSocket,
  });
  clients.push(client);
  const subscription = client.newSubscription(`merchant:${restaurantId}`);
  const subscribed = new Promise<void>((resolve) => subscription.on('subscribed', () => resolve()));
  subscription.subscribe();
  client.connect();
  await subscribed;
  return client;
}

async function openAlerts(restaurantId: string) {
  const { rows } = await sql.query(
    `SELECT code, details FROM notifications.alerts
     WHERE subject_id = $1 AND code = 'restaurant_without_device' AND resolved_at IS NULL`,
    [restaurantId],
  );
  return rows;
}

async function devices(headers: Record<string, string>) {
  const answer = await app.inject({ method: 'GET', url: '/v1/merchant/devices', headers });
  return answer.json().devices as { deviceId: string; connected: boolean; ringing: boolean }[];
}

const minutes = (at: Date, count: number) => new Date(at.getTime() + count * 60_000);

describe('the receiving devices (RA §4.3–4.6)', () => {
  it('sees the devices on the channel, alerts after 5 minutes without one and clears', async () => {
    const id = await restaurant();
    const owner = await user(id, 'owner');
    const ownerClient = await connect(id, owner.headers);
    const start = new Date();

    await sweep.run(start);
    expect((await devices(owner.headers))[0]).toMatchObject({
      deviceId: owner.deviceId,
      connected: true,
      ringing: true,
    });
    expect(await app.get(ReceivingDevicesService).withoutDeviceSince(id)).toBeNull();

    // An owner turns ringing off on their only device: no receiving device.
    await app.inject({
      method: 'PUT',
      url: '/v1/merchant/device',
      headers: owner.headers,
      payload: { appVersion: '1.0.0', ringing: false },
    });
    await sweep.run(minutes(start, 1));
    expect(await app.get(ReceivingDevicesService).withoutDeviceSince(id)).toEqual(
      minutes(start, 1),
    );
    await sweep.run(minutes(start, 5.9));
    expect(await openAlerts(id)).toEqual([]);
    await sweep.run(minutes(start, 6));
    expect(await openAlerts(id)).toMatchObject([
      { details: { restaurantName: expect.any(String) } },
    ]);
    // RA §16 #27: the owners hear it once per stretch.
    await sweep.run(minutes(start, 6.1));
    const pushes = await sql.query(
      `SELECT body, owners_only AS owners FROM notifications.push_messages
       WHERE restaurant_id = $1 AND template_key = 'merchant.no_receiving_device'`,
      [id],
    );
    expect(pushes.rows).toEqual([
      { body: 'لا يوجد جهاز يستقبل الطلبات في مطعمك الآن', owners: true },
    ]);
    expect((await app.get(ReceivingDevicesService).withoutDevice([id])).has(id)).toBe(true);

    // A cashier's device rings whatever its setting: it receives.
    const cashier = await user(id, 'cashier');
    const cashierClient = await connect(id, cashier.headers);
    await sweep.run(minutes(start, 7));
    expect(await openAlerts(id)).toEqual([]);
    expect(await app.get(ReceivingDevicesService).withoutDeviceSince(id)).toBeNull();

    // Off the channel, a device still counts for 60 seconds (RA §4.3).
    cashierClient.disconnect();
    ownerClient.disconnect();
    await sweep.run(minutes(start, 7.5));
    expect(await app.get(ReceivingDevicesService).withoutDeviceSince(id)).toBeNull();
    await sweep.run(minutes(start, 8.1));
    expect(await app.get(ReceivingDevicesService).withoutDeviceSince(id)).toEqual(
      minutes(start, 8.1),
    );
  });

  it('never alerts while the restaurant is not open, and the restaurant stays as it is', async () => {
    const id = await restaurant();
    await app.get(MerchantsService).setWeeklySchedule(id, [], change);
    const start = new Date();
    await sweep.run(start);
    await sweep.run(minutes(start, 10));
    expect(await openAlerts(id)).toEqual([]);
    expect(await app.get(ReceivingDevicesService).withoutDeviceSince(id)).toBeNull();
  });
});
