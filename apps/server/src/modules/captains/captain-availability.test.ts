import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { Valkey } from 'iovalkey';
import { ApiModule } from '../../api.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import {
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { CaptainsService } from './index.js';

// The captain app's availability and location routes (CA §4.3, §7), served
// by the API app as in production, on a fresh database and Valkey.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let valkey: Valkey;
let captains: CaptainsService;
let azaz: string;

const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  valkey = new Valkey(cache.url);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  captains = app.get(CaptainsService);
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
}, 300_000);

afterAll(async () => {
  await app?.close();
  valkey?.disconnect();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

beforeEach(async () => {
  await valkey.flushall();
});

// An activated captain, signed in on a new device, who accepted the terms in
// force (K7) unless told not to; the headers of its calls.
async function signedIn({ acceptTerms = true } = {}) {
  const captainId = await captains.createCaptain(
    azaz,
    {
      name: 'كابتن اختبار',
      vehicle: 'walking',
      custodyLimit: { amount: 300_000n, currency: 'TRY' },
    },
    change,
  );
  const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
  await app.get(CaptainAccountsService).addAccount(captainId, phone, change);
  const deviceId = randomUUID();
  await app.inject({ method: 'POST', url: '/v1/captain/auth/code', payload: { phone, deviceId } });
  const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
  const answer = await app.inject({
    method: 'POST',
    url: '/v1/captain/auth/sign-in',
    payload: { phone, deviceId, code },
  });
  const headers = { authorization: `Bearer ${answer.json().accessToken}` };
  if (acceptTerms) {
    await app.inject({
      method: 'POST',
      url: '/v1/captain/terms/accept',
      headers,
      payload: { version: 1 },
    });
  }
  return { captainId, headers };
}

type Headers = Record<string, string>;
const call = (headers: Headers, method: 'GET' | 'POST', url: string, payload?: object) =>
  app.inject({ method, url, headers, ...(payload ? { payload } : {}) });
const goOnline = (headers: Headers, simulatedLocation = false) =>
  call(headers, 'POST', '/v1/captain/availability/online', {
    appVersion: '1.0.0',
    simulatedLocation,
  });
const point = (recordedAt: Date, simulated = false) => ({
  latitude: 36.5866,
  longitude: 37.0463,
  accuracyMetres: 8,
  recordedAt: recordedAt.toISOString(),
  simulated,
});
const sendPoints = (headers: Headers, points: object[]) =>
  call(headers, 'POST', '/v1/captain/location', { points });

describe('the availability routes (CA §7)', () => {
  it('answers the state with the cash, goes online and offline', async () => {
    const { headers } = await signedIn();
    const state = await call(headers, 'GET', '/v1/captain/availability');
    expect(state.json()).toMatchObject({
      availability: { state: 'offline' },
      custody: {
        usage: { amount: '0', currency: 'TRY' },
        limit: { amount: '300000', currency: 'TRY' },
        warn: false,
        closedDue: { amount: '0', currency: 'TRY' },
      },
    });
    const online = await goOnline(headers);
    expect(online.statusCode).toBe(200);
    expect(online.json().availability).toMatchObject({ state: 'online_available' });
    const offline = await call(headers, 'POST', '/v1/captain/availability/offline');
    expect(offline.json()).toEqual({ handIn: null });
    expect((await call(headers, 'GET', '/v1/captain/availability')).json().availability).toEqual({
      state: 'offline',
      since: null,
      reasons: [],
      suspensionReason: null,
      suspendedUntil: null,
    });
  });

  it('waits for the terms in force before going online (K7)', async () => {
    const { headers } = await signedIn({ acceptTerms: false });
    const refused = await goOnline(headers);
    expect(refused.statusCode).toBe(409);
    expect(refused.json()).toMatchObject({ blocks: [{ kind: 'terms_not_accepted' }] });
    await call(headers, 'POST', '/v1/captain/terms/accept', { version: 1 });
    expect((await goOnline(headers)).statusCode).toBe(200);
  });

  it('refuses going online with 409 and every block', async () => {
    const { captainId, headers } = await signedIn();
    await captains.setStatus(captainId, 'suspended', { ...change, reason: 'تأخر' }, new Date());
    const refused = await goOnline(headers, true);
    expect(refused.statusCode).toBe(409);
    expect(refused.json()).toMatchObject({
      error: 'online_blocked',
      blocks: [{ kind: 'suspended', reason: 'تأخر', until: null }, { kind: 'simulated_location' }],
    });
  });

  it('refuses an app version that is not major.minor.patch', async () => {
    const { headers } = await signedIn();
    const refused = await call(headers, 'POST', '/v1/captain/availability/online', {
      appVersion: '1.0',
      simulatedLocation: false,
    });
    expect(refused.statusCode).toBe(400);
  });

  it('needs a captain token: none, or a customer token, answers 401 on every captain route', async () => {
    const phone = `+9639${randomInt(100_000_000).toString().padStart(8, '0')}`;
    const deviceId = randomUUID();
    await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/code',
      payload: { phone, deviceId },
    });
    const code = app.get<DevelopmentCodeSender>(CODE_SENDER).lastCode(phone);
    const customer = await app.inject({
      method: 'POST',
      url: '/v1/customer/auth/sign-in',
      payload: { phone, deviceId, code },
    });
    const headers = { authorization: `Bearer ${customer.json().accessToken}` };
    const routes: ['GET' | 'POST', string, object?][] = [
      ['GET', '/v1/captain/auth/session'],
      ['GET', '/v1/captain/availability'],
      [
        'POST',
        '/v1/captain/availability/online',
        { appVersion: '1.0.0', simulatedLocation: false, termsPending: false },
      ],
      ['POST', '/v1/captain/availability/offline'],
      ['POST', '/v1/captain/location', { points: [point(new Date())] }],
    ];
    for (const [method, url, payload] of routes) {
      expect((await call(headers, method, url, payload)).statusCode, url).toBe(401);
      expect((await call({}, method, url, payload)).statusCode, url).toBe(401);
    }
  });
});

describe('the location route (CA §4.3, architecture §7.3)', () => {
  it('keeps the points of an online captain once, and the newest in Valkey', async () => {
    const { captainId, headers } = await signedIn();
    const before = new Date(Date.now() - 60_000);
    await goOnline(headers);
    const first = new Date(Date.now() + 1_000);
    const second = new Date(first.getTime() + 10_000);
    const sent = await sendPoints(headers, [point(before), point(first), point(second)]);
    // The point recorded before going online is dropped.
    expect(sent.json()).toEqual({ accepted: 2 });
    // A retry keeps nothing new, and an older batch never moves the position back.
    expect((await sendPoints(headers, [point(first)])).json()).toEqual({ accepted: 0 });
    const { rows } = await sql.query(
      'SELECT count(*)::int AS n FROM captains.locations WHERE captain_id = $1',
      [captainId],
    );
    expect(rows).toEqual([{ n: 2 }]);
    expect(await valkey.hget(`captains:position:${captainId}`, 'recordedAt')).toBe(
      String(second.getTime()),
    );
    expect(await valkey.geopos(`captains:online:${azaz}`, captainId)).toHaveLength(1);
  });

  it('stops offers while the newest point is simulated, never showing it as the live position', async () => {
    const { captainId, headers } = await signedIn();
    await goOnline(headers);
    await sendPoints(headers, [point(new Date(Date.now() + 1_000), true)]);
    expect(await valkey.exists(`captains:position:${captainId}`)).toBe(0);
    expect((await call(headers, 'GET', '/v1/captain/availability')).json().availability).toEqual({
      state: 'not_receiving_offers',
      since: expect.any(String),
      reasons: ['simulated_location'],
      suspensionReason: null,
      suspendedUntil: null,
    });
    await sendPoints(headers, [point(new Date(Date.now() + 2_000))]);
    expect((await call(headers, 'GET', '/v1/captain/availability')).json().availability.state).toBe(
      'online_available',
    );
  });

  it('refuses points while offline, and forgets the live position on going offline', async () => {
    const { captainId, headers } = await signedIn();
    const offline = await sendPoints(headers, [point(new Date())]);
    expect(offline.statusCode).toBe(409);
    expect(offline.json()).toMatchObject({ error: 'not_online' });

    await goOnline(headers);
    const onlineAt = new Date();
    await sendPoints(headers, [point(onlineAt)]);
    await new Promise((resolve) => setTimeout(resolve, 20));
    await call(headers, 'POST', '/v1/captain/availability/offline');
    expect(await valkey.exists(`captains:position:${captainId}`)).toBe(0);
    expect(await valkey.zscore(`captains:online:${azaz}`, captainId)).toBeNull();
    // A point queued while online and sent after going offline is kept for
    // the route, but never brings the live position back.
    const late = await sendPoints(headers, [point(new Date(onlineAt.getTime() + 5))]);
    expect(late.json()).toEqual({ accepted: 1 });
    expect(await valkey.exists(`captains:position:${captainId}`)).toBe(0);
    // A point recorded offline is not.
    const afterOffline = await sendPoints(headers, [point(new Date(Date.now() + 30_000))]);
    expect(afterOffline.statusCode).toBe(409);
  });

  it('refuses a point recorded in the future and a point off the globe', async () => {
    const { headers } = await signedIn();
    await goOnline(headers);
    const future = await sendPoints(headers, [point(new Date(Date.now() + 5 * 60_000))]);
    expect(future.statusCode).toBe(400);
    expect(future.json()).toMatchObject({ error: 'invalid_location' });
    const offGlobe = await sendPoints(headers, [{ ...point(new Date()), latitude: 91 }]);
    expect(offGlobe.statusCode).toBe(400);
  });
});
