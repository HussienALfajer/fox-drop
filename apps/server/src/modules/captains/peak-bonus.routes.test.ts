import 'reflect-metadata';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import type { NestFastifyApplication } from '@nestjs/platform-fastify';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ApiModule } from '../../api.module.js';
import { createDatabase, type Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { createApiApp } from '../../http/create-api-app.js';
import { startTestValkey, type TestValkey } from '../../valkey/test-valkey.js';
import { FxService } from '../fx/index.js';
import { GeoService, type Point } from '../geo/index.js';
import {
  ADMIN_SESSION_COOKIE,
  AdminSessionsService,
  CaptainAccountsService,
  CODE_SENDER,
  type DevelopmentCodeSender,
} from '../identity/index.js';
import { CaptainsService, localClock } from './index.js';

// The peak bonus routes (AP §9.12.5, CA §12.5) served by the API app: the
// panel's read and save, and the captain app's windows.
let database: TestDatabase;
let cache: TestValkey;
let app: NestFastifyApplication;
let sql: pg.Pool;
let db: Database;
let azaz: string;
let zoneId: string;
const system = { type: 'system', id: null, role: null } as const;
const change = { actor: system, context: { ipAddress: null, device: null }, reason: 'test' };

function square({ latitude, longitude }: Point, half = 0.05): Point[] {
  return [
    { latitude: latitude - half, longitude: longitude - half },
    { latitude: latitude - half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude + half },
    { latitude: latitude + half, longitude: longitude - half },
  ];
}

beforeAll(async () => {
  [database, cache] = await Promise.all([startTestDatabase(), startTestValkey()]);
  process.env.DATABASE_URL = database.appUrl;
  process.env.VALKEY_URL = cache.url;
  process.env.IDENTITY_ENCRYPTION_KEY = randomBytes(32).toString('base64');
  process.env.FOX_DROP_ENVIRONMENT = 'development';
  sql = new pg.Pool({ connectionString: database.appUrl });
  db = createDatabase(database.appUrl);
  app = await createApiApp(ApiModule);
  await app.init();
  await app.getHttpAdapter().getInstance().ready();
  azaz = (await sql.query("SELECT id FROM geo.cities WHERE code = 'AZ'")).rows[0].id;
  const fx = app.get(FxService);
  await fx.setCityCurrency(azaz, { currency: 'TRY', displayOrder: 1, enabled: true }, change);
  await fx.setBaseCurrency(azaz, 'TRY', change);
  zoneId = await app
    .get(GeoService)
    .createZone(
      azaz,
      { name: 'المركز', area: square({ latitude: 36.587, longitude: 37.046 }), active: true },
      change,
    );
}, 300_000);

afterAll(async () => {
  await app?.close();
  await db?.pool.end();
  await sql?.end();
  await Promise.all([database?.stop(), cache?.stop()]);
});

let accounts = 0;
async function admin(roles: string[]) {
  accounts += 1;
  const { rows } = await sql.query(
    `INSERT INTO identity.admin_accounts (name, email, status, password_hash, totp_secret_encrypted)
     VALUES ($1, $2, 'active', 'not used', 'not used') RETURNING id`,
    [`Pricing ${accounts}`, `pricing${accounts}@example.test`],
  );
  const accountId: string = rows[0].id;
  for (const role of roles) {
    await sql.query(
      'INSERT INTO identity.admin_account_roles (account_id, role_code) VALUES ($1, $2)',
      [accountId, role],
    );
  }
  const { token } = await app
    .get(AdminSessionsService)
    .start(db.db, accountId, { ipAddress: '203.0.113.9', device: 'test' }, new Date());
  const cookies = { [ADMIN_SESSION_COOKIE]: token };
  return {
    get: (cityId: string) =>
      app.inject({ method: 'GET', url: `/v1/admin/peak-bonus?cityId=${cityId}`, cookies }),
    put: (payload: object) =>
      app.inject({ method: 'PUT', url: '/v1/admin/peak-bonus', cookies, payload }),
  };
}

async function captain() {
  const captainId = await app
    .get(CaptainsService)
    .createCaptain(
      azaz,
      {
        name: 'كابتن الذروة',
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
  return () => app.inject({ method: 'GET', url: '/v1/captain/peak-bonus', headers });
}

// A window running now on Azaz's clock, for the centre zone.
function aroundNow() {
  const { minute } = localClock(new Date(), 'Asia/Damascus');
  return {
    days: [1, 2, 3, 4, 5, 6, 7],
    startMinute: (minute - 60 + 1440) % 1440,
    endMinute: (minute + 60) % 1440,
    amount: '500',
    zoneIds: [zoneId],
  };
}

describe('the peak bonus routes (AP §9.12.5, CA §12.5)', () => {
  it('is off until OWN saves it, and the captain sees the windows', async () => {
    const owner = await admin(['OWN']);
    const windows = await captain();
    const before = await owner.get(azaz);
    expect(before.statusCode).toBe(200);
    expect(before.json()).toMatchObject({
      inForce: null,
      pending: null,
      baseCurrency: 'TRY',
      zones: [{ id: zoneId, name: 'المركز', active: true }],
    });
    expect((await windows()).json()).toEqual({ windows: [], active: [] });

    const saved = await owner.put({ cityId: azaz, enabled: true, windows: [aroundNow()] });
    expect(saved.statusCode).toBe(200);
    expect(saved.json()).toMatchObject({
      inForce: {
        enabled: true,
        currency: 'TRY',
        windows: [{ amount: '500', zones: [{ id: zoneId, name: 'المركز' }] }],
      },
      pending: null,
    });
    const seen = (await windows()).json();
    expect(seen.windows).toMatchObject([
      { amount: { amount: '500', currency: 'TRY' }, zones: [{ name: 'المركز' }] },
    ]);
    expect(seen.active).toHaveLength(1);
    expect(new Date(seen.active[0].until).getTime()).toBeGreaterThan(Date.now());
  });

  it('answers a lowering during the window as waiting', async () => {
    const owner = await admin(['OWN']);
    await owner.put({ cityId: azaz, enabled: true, windows: [aroundNow()] });
    const lowered = await owner.put({ cityId: azaz, enabled: false, windows: [] });
    expect(lowered.statusCode).toBe(200);
    expect(lowered.json().inForce.enabled).toBe(true);
    expect(lowered.json().pending).toMatchObject({ enabled: false, windows: [] });
  });

  it('refuses a window it cannot save, and an unknown city', async () => {
    const owner = await admin(['OWN']);
    const invalid = await owner.put({
      cityId: azaz,
      enabled: true,
      windows: [{ ...aroundNow(), endMinute: aroundNow().startMinute }],
    });
    expect(invalid.statusCode).toBe(400);
    expect(invalid.json().error).toBe('invalid_peak_bonus');
    const unknown = await owner.put({ cityId: randomUUID(), enabled: true, windows: [] });
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json().error).toBe('unknown_city');
  });

  it('lets operations read it but only the owner save it', async () => {
    const ops = await admin(['OPS']);
    expect((await ops.get(azaz)).statusCode).toBe(200);
    expect((await ops.put({ cityId: azaz, enabled: false, windows: [] })).statusCode).toBe(403);
  });
});
